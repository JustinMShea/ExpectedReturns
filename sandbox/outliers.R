interval <- function(data,
                     varnames = NULL,
                     m = 5,
                     time_var = "DATE",
                     filter = FALSE) {
  # note to self: add function to make check and convert data to data.table
  if (is.null(varnames)) {varnames = colnames(data)}
  remove_row <- c()
  plots <- list()
  outlier_dates <- list()
  for (variable in varnames) {
    col_mean <- mean(data[[variable]], na.rm = TRUE)
    col_sd <- sd(data[[variable]], na.rm = TRUE)
    interval <- c(col_mean - m * col_sd, col_mean + m * col_sd)
    outside_idx <- which(data[[variable]] < interval[1] | data[[variable]] > interval[2])
    anomaly_data <- copy(data)
    anomaly_data[, anomaly := FALSE]
    anomaly_data[outside_idx, anomaly := TRUE]
    p <- ggplot(data, aes_string(x = time_var, y = variable)) +
      geom_line() +
      geom_point(data = anomaly_data[anomaly == TRUE], aes_string(x = time_var, y = variable, color = "anomaly")) +
      labs(title = paste("Anomalies in", variable), x = "Time", y = variable) +
      scale_color_manual(values = c("black", "red")) +
      theme_minimal()
    plots[[variable]] <- p
    outlier_dates[[variable]] <- data[outside_idx, "DATE"]
    remove_row <- c(remove_row, outside_idx)
  }
  remove_row <- unique(remove_row)
  if (filter == TRUE) {
    data <- data[-remove_row, ]
  }
  return(list(data = data, outlier_dates = outlier_dates, remove_index = remove_row, plots = plots))
}
