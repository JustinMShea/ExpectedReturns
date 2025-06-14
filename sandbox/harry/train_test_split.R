#' Train Test Split
#'
#' @section Usage
#' TSML$train_test_split(cutoff = 0.8)
#' @section Arguments
#' @param cutoff cutoff index for splitting. Can be a numeric value or a date object
#' @section Example
#' # 80/20 split of training and test data
#' TSML$train_test_split(cutoff = 0.8)
#' # Specify a 12 period buffer set for initial training
#' TSML$train_test_split(cutoff = 12)
#' # Split dataset by date index
#' date_idx <- as.Date("2020-06-22")
#' TSML$train_test_split(cutoff = date_idx)

TSML$set("public", "train_test_split", function(cutoff) {
  data <- self$data
  ts_var <- self$ts_var

  if (is.numeric(cutoff)) {
    if (cutoff < 0) {
      stop("Error: cutoff cannot be a negative number.")
    }
    if (cutoff > nrow(data)) {
      stop("Error: cutoff cannot be larger than the number of row of the dataset.")
    }
    if ((cutoff == nrow(data)) || (cutoff == 0)) {
      stop("Error: length of training and test datasets cannot be 0.")
    }
  } else if (!inherits(cutoff, "Date")) {
    stop("Error: cutoff must either be a number or a date object.")
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
    if (cutoff < 1) {
      date_cutoff_index <- ceiling(length(unique_dates) * cutoff)
    } else {
      date_cutoff_index <- cutoff
    }
    date_cutoff <- unique_dates[date_cutoff_index]
  }

  self$train_data <- data[data[[ts_var]] <= date_cutoff]
  self$test_data <- data[data[[ts_var]] > date_cutoff]

  # This may/should be moved somewhere else
  self$benchmark[["zero"]] <- rep(0, nrow(self$test_data))
  self$truth <- self$test_data[[self$y]]
})
