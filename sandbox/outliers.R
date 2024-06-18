interval <- function(data,
                     varnames = NULL,
                     m = 5,
                     time_var = "DATE",
                     filter = FALSE) {
  # note to self: add function to make check and convert data to data.table
  if (is.null(varnames)) {
    varnames <- setdiff(colnames(data), time_var)
  }
  remove_row <- c()
  plots <- list()
  outlier_dates <- list()
  for (variable in varnames) {
    col_mean <- mean(data[[variable]], na.rm = TRUE)
    col_sd <- sd(data[[variable]], na.rm = TRUE)
    interval <- c(col_mean - m * col_sd, col_mean + m * col_sd)
    outlier_idx <- which(data[[variable]] < interval[1] | data[[variable]] > interval[2])
    anomaly_data <- copy(data)
    anomaly_data[, anomaly := FALSE]
    anomaly_data[outlier_idx, anomaly := TRUE]
    p <- ggplot(data, aes_string(x = time_var, y = variable)) +
      geom_line() +
      geom_point(data = anomaly_data[anomaly == TRUE], aes_string(x = time_var, y = variable, color = "anomaly")) +
      labs(title = paste("Anomalies in", variable), x = "Time", y = variable) +
      scale_color_manual(values = c("black", "red")) +
      theme_minimal()
    plots[[variable]] <- p
    outlier_dates[[variable]] <- data[outlier_idx, "DATE"]
    remove_row <- c(remove_row, outlier_idx)
  }
  remove_row <- unique(remove_row)
  if (filter) {
    data <- data[-remove_row, ]
  }
  return(list(data = data, outlier_dates = outlier_dates, remove_index = remove_row, plots = plots))
}

winsorize <- function(data,
                  varnames = NULL,
                  q = 0.01,
                  time_var = "DATE",
                  winsorize = FALSE) {
  # note to self: add function to make check and convert data to data.table
  if (is.null(varnames)) {
    varnames <- setdiff(colnames(data), time_var)
  }

  plots <- list()
  outlier_dates <- list()

  for (variable in varnames) {
    lower_bound <- quantile(data[[variable]], q, na.rm = TRUE)
    upper_bound <- quantile(data[[variable]], 1 - q, na.rm = TRUE)

    # Identify outliers
    outlier_idx <- which(data[[variable]] < lower_bound | data[[variable]] > upper_bound)

    # Store the indices in the list
    outlier_dates[[variable]] <- data[outlier_idx, "DATE"]

    # Perform winsorization if filter is TRUE
    if (winsorize) {
      data[[variable]][data[[variable]] < lower_bound] <- lower_bound
      data[[variable]][data[[variable]] > upper_bound] <- upper_bound
    }

    # Create a copy of data to include anomaly flag for plotting
    anomaly_data <- copy(data)
    anomaly_data[, anomaly := FALSE]
    anomaly_data[outlier_idx, anomaly := TRUE]

    # Generate the plot
    p <- ggplot(data, aes_string(x = time_var, y = variable)) +
      geom_line() +
      geom_point(data = anomaly_data[anomaly == TRUE], aes_string(x = time_var, y = variable, color = "anomaly")) +
      labs(title = paste("Outliers in", variable), x = "Time", y = variable) +
      scale_color_manual(values = c("black", "red")) +
      theme_minimal()

    # Store the plot in the list
    plots[[variable]] <- p
  }

  # Return the list of plots and outlier indices
  return(list(data = data, outlier_dates = outlier_dates, plots = plots))
}
