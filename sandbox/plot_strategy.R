plot_strategy <- function(return_list,
                          names = NULL,
                          t_oos = NULL,
                          barplot = TRUE,
                          cumulative = TRUE,
                          ...) {
  if (is.null(names)) {
    names <- paste("Strategy", as.character(seq(1, length(return_list))))
  }

  plots <- new.env()

  cum_returns <- data.frame()
  for (n in 1:length(return_list)) {
    portf_returns <- return_list[[n]]
    if (ncol(portf_returns) != 2) {
      stop("Error: each element in the return list must be a matrix, dataframe, or zoo object with a time column and a return column.")
    }
    names(portf_returns) <- c("Time", "Return")
    # Check whether time can be converted to time and return is numeric
    ########

    portf_returns[, "CumReturn"] <- cumprod(1 + portf_returns[, "Return"])
    portf_returns[, "Strategy"] <- rep(names[n], nrow(portf_returns))
    cum_returns <- rbind(cum_returns, portf_returns)
    setDT(cum_returns)
  }

  if (barplot) {
    date_range <- range(cum_returns$Time)
    time_diff <- as.numeric(difftime(date_range[2], date_range[1], units = "mins"))
    if (nrow(cum_returns) > 30) {
      if (time_diff > 5256000) {  # More than 10 years
        agg_returns <- cum_returns[, .(Return = DescTools::Gmean(Return + 1, na.rm = TRUE) - 1), by = .(Time = year(Time), Strategy)]
      } else if (time_diff > 525600) {  # More than 1 year
        agg_returns <- cum_returns[, .(Return = DescTools::Gmean(Return + 1, na.rm = TRUE) - 1), by = .(Time = format(Time, "%Y-%m"), Strategy)]
      } else if (time_diff > 43200) {  # More than 1 month
        agg_returns <- cum_returns[, .(Return = DescTools::Gmean(Return + 1, na.rm = TRUE) - 1), by = .(Time = format(Time, "%Y-%U"), Strategy)]
      } else if (time_diff > 1440) {  # More than 1 day
        agg_returns <- cum_returns[, .(Return = DescTools::Gmean(Return + 1, na.rm = TRUE) - 1), by = .(Time = as.Date(Time), Strategy)]
      } else if (time_diff > 60) {  # More than 1 hour
        agg_returns <- cum_returns[, .(Return = DescTools::Gmean(Return + 1, na.rm = TRUE) - 1), by = .(Time = format(Time, "%Y-%m-%d %H:00"), Strategy)]
      } else {
        agg_returns <- cum_returns[, .(Return = DescTools::Gmean(Return + 1, na.rm = TRUE) - 1), by = .(Time = format(Time, "%Y-%m-%d %H:%M"), Strategy)]
      }
    } else {
      agg_returns <- cum_returns[, c("Time", "Return", "Strategy")]
    }
    plot$barplot <- ggplot(agg_returns) +
      geom_bar(aes(x = Time, y = Return, fill = Strategy), stat = "identity") +
      labs(title = "Portfolio Returns", x = "Time", y = "Return") +
      theme_minimal()
  }

  if (cumulative) {
    plots$cumulative <- ggplot(cum_returns) +
      geom_line(aes(x = Time, y = CumReturn, color = Strategy)) +
      theme_minimal()
  }
}
