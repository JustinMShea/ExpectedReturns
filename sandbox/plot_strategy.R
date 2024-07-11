plot_strategy <- function(return_list,
                          names = NULL,
                          t_oos = NULL,
                          ...) {
  if (is.null(names)) {
    names <- paste("Strategy", as.character(seq(1, length(return_list))))
  }
  cum_returns <- data.frame()
  for (n in 1:length(return_list)) {
    portf_returns <- return_list[[n]]
    if (ncol(portf_returns) != 2) {
      stop("Error: each element in the return list must be a matrix, dataframe, or zoo object with a time column and a return column.")
    }
    names(portf_returns) <- c("Time", "Return")
    # Check whether time can be converted to time and return is numeric
    ########

    portf_returns[, "Return"] <- cumprod(1 + portf_returns[, "Return"])
    portf_returns[, "Strategy"] <- rep(names[n], nrow(portf_returns))
    cum_returns <- rbind(cum_returns, portf_returns)
  }
  ggplot(cum_returns) +
    geom_line(aes(x = Time, y = Return, color = Strategy)) +
    theme_minimal()
}
