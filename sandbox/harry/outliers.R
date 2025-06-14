interval <- function(data,
                     varnames = NULL,
                     m = 5,
                     ts_var = "DATE",
                     cs_var = NULL,
                     by = "default",
                     filter = FALSE,
                     plot = TRUE) {
  # note to self: add function to make check and convert data to data.table
  if (is.null(varnames)) {
    varnames <- setdiff(colnames(data), c(ts_var, cs_var))
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
    p <- ggplot(data, aes_string(x = ts_var, y = variable)) +
      geom_line() +
      geom_point(data = anomaly_data[anomaly == TRUE], aes_string(x = ts_var, y = variable, color = "anomaly")) +
      labs(title = paste("Anomalies in", variable), x = "Time", y = variable) +
      scale_color_manual(values = c("black", "red")) +
      theme_minimal()
    plots[[variable]] <- p
    outlier_dates[[variable]] <- data[outlier_idx, ..ts_var]
    remove_row <- c(remove_row, outlier_idx)
  }
  remove_row <- unique(remove_row)
  if (filter) {
    data <- data[-remove_row, ]
  }
  return(list(data = data, outlier_dates = outlier_dates, remove_index = remove_row, plots = plots))
  # Add to "ts" and "cs" method for panel data. Allow outlier detection by time-series and cross-sectional variables
}

winsorize <- function(data,
                  varnames = NULL,
                  q = 0.01,
                  ts_var = "DATE",
                  cs_var = NULL,
                  by = "default",
                  winsorize = FALSE,
                  plot = TRUE) {
  # note to self: add function to make check and convert data to data.table
  if (is.null(varnames)) {
    varnames <- setdiff(colnames(data), ts_var)
  }

  plots <- list()
  outlier_dates <- list()

  for (variable in varnames) {
    lower_bound <- quantile(data[[variable]], q, na.rm = TRUE)
    upper_bound <- quantile(data[[variable]], 1 - q, na.rm = TRUE)

    # Identify outliers
    outlier_idx <- which(data[[variable]] < lower_bound | data[[variable]] > upper_bound)

    # Store the indices in the list
    outlier_dates[[variable]] <- data[outlier_idx, ..ts_var]

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
    p <- ggplot(data, aes_string(x = ts_var, y = variable)) +
      geom_line() +
      geom_point(data = anomaly_data[anomaly == TRUE], aes_string(x = ts_var, y = variable, color = "anomaly")) +
      labs(title = paste("Outliers in", variable), x = "Time", y = variable) +
      scale_color_manual(values = c("black", "red")) +
      theme_minimal()

    # Store the plot in the list
    plots[[variable]] <- p
  }

  # Return the list of plots and outlier indices
  return(list(data = data, outlier_dates = outlier_dates, plots = plots))
  # Add to "ts" and "cs" method for panel data. Allow outlier detection by time-series and cross-sectional variables
}


# Pipeline Functions
TSML$set("public", "interval_outlier", function(m = 5,
                                                varnames = NULL,
                                                by = "default",
                                                filter = FALSE,
                                                plot = TRUE) {
  if (is.null(varnames)) {
    varnames <- setdiff(colnames(self$data), c(self$ts_var, self$cs_var))
  }

  remove_row <- c()
  plots <- list()
  outlier_dates <- list()
  data <- self$data

  for (variable in varnames) {
    col_mean <- mean(data[[variable]], na.rm = TRUE)
    col_sd <- sd(data[[variable]], na.rm = TRUE)
    interval <- c(col_mean - m * col_sd, col_mean + m * col_sd)
    outlier_idx <- which(data[[variable]] < interval[1] | data[[variable]] > interval[2])

    if (plot) {
      p <- ggplot(data, aes_string(x = self$ts_var, y = variable)) +
        geom_line() +
        geom_point(data = data[outlier_idx, ], aes_string(x = self$ts_var, y = variable), color = "red") +
        labs(title = paste("Anomalies in", variable), x = "Time", y = variable) +
        theme_minimal()
      plots[[variable]] <- p
    }

    outlier_dates[[variable]] <- data[outlier_idx, ..self$ts_var]
    remove_row <- c(remove_row, outlier_idx)
  }


  remove_row <- unique(remove_row)
  if (filter) {
    self$data <- self$data[-remove_row, ]
  }

  return(list(outlier_dates = outlier_dates, remove_index = remove_row, plots = plots))
})

TSML$set("public", "winsorize", function(q = 0.01,
                                         varnames = NULL,
                                         by = "default",
                                         winsorize = FALSE,
                                         plot = FALSE) {
  if (is.null(varnames)) {
    varnames <- setdiff(colnames(self$data), c(self$ts_var, self$cs_var))
  }

  outlier_dates <- list()
  plots <- list()
  data <- self$data

  for (variable in varnames) {
    lower_bound <- quantile(data[[variable]], q, na.rm = TRUE)
    upper_bound <- quantile(data[[variable]], 1 - q, na.rm = TRUE)

    outlier_idx <- which(data[[variable]] < lower_bound | data[[variable]] > upper_bound)
    outlier_dates[[variable]] <- data[outlier_idx, ..self$ts_var]

    if (plot) {
      p <- ggplot(data, aes_string(x = self$ts_var, y = variable)) +
        geom_line() +
        geom_point(data = data[outlier_idx, ], aes_string(x = self$ts_var, y = variable), color = "red") +
        labs(title = paste("Outliers in", variable), x = "Time", y = variable) +
        theme_minimal()
      plots[[variable]] <- p
    }

    if (winsorize) {
      self$data[[variable]][self$data[[variable]] < lower_bound] <- lower_bound
      self$data[[variable]][self$data[[variable]] > upper_bound] <- upper_bound
    }
  }

  return(list(outlier_dates = outlier_dates, plots = plots))
})
