TSML$set("public", "train_test_split", function(cutoff) {
  data <- self$data
  ts_var <- self$ts_var

  if (!(is.numeric(cutoff) && cutoff > 0 && cutoff < 1) && !inherits(cutoff, "Date")) {
    stop("Error: cutoff must either be a number between 0 and 1 or a date object")
  }

  if (inherits(cutoff, "Date")) {
    min_date <- min(data[[ts_var]], na.rm = TRUE)
    max_date <- max(data[[ts_var]], na.rm = TRUE)
    if (cutoff < min_date || cutoff > max_date) {
      stop("Error: cutoff date must be between the first and last date of the time series")
    }
    date_cutoff <- cutoff
  } else {
    unique_dates <- unique(data[[ts_var]])
    unique_dates <- unique_dates[order(unique_dates)]
    date_cutoff_index <- ceiling(length(unique_dates) * cutoff)
    date_cutoff <- unique_dates[date_cutoff_index]
  }

  self$train_data <- data[data[[ts_var]] <= date_cutoff]
  self$test_data <- data[data[[ts_var]] > date_cutoff]

  # This may/should be moved somewhere else
  self$benchmark[["zero"]] <- rep(0, nrow(self$test_data))
  self$truth <- self$test_data[[self$y]]
})
