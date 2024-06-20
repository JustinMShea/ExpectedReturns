# Regular Version
train_test_split <- function(data,
                             ts_var = NULL,
                             cs_var = NULL,
                             cutoff = 0.8) {
  # Check if data is data.table, if not convert it, if conversion fails throw exact error back
  if (!is.data.table(data)) {
    tryCatch({
      data <- as.data.table(data)
    }, error = function(e) {
      stop(paste("Error: data conversion to data.table failed:", e$message))
    })
  }

  # Check if time series variable is given
  if (is.null(ts_var)) {
    stop("Error: time series variable cannot be empty")
  }

  # Check if ts_var column is a date object, if not convert it, if conversion fails throw exact error back
  if (!inherits(data[[ts_var]], "Date")) {
    tryCatch({
      data[[ts_var]] <- as.Date(data[[ts_var]])
    }, error = function(e) {
      stop(paste("Error: ts_var column conversion to Date object failed:", e$message))
    })
  }

  if (!(is.numeric(cutoff) && cutoff > 0 && cutoff < 1) && !inherits(cutoff, "Date")) {
    stop("Error: cutoff must either be a number between 0 and 1 or a date object")
  }

  # If cutoff is a date, ensure it is between the first and last date of ts_var
  if (inherits(cutoff, "Date")) {
    min_date <- min(data[[ts_var]], na.rm = TRUE)
    max_date <- max(data[[ts_var]], na.rm = TRUE)
    if (cutoff < min_date || cutoff > max_date) {
      stop("Error: cutoff date must be between the first and last date of the time series")
    }
    date_cutoff <- cutoff
  } else {
    # If cutoff is numeric, calculate the date cutoff
    unique_dates <- unique(data[[ts_var]])
    unique_dates <- unique_dates[order(unique_dates)]
    date_cutoff_index <- ceiling(length(unique_dates) * cutoff)
    date_cutoff <- unique_dates[date_cutoff_index]
  }
  # Split the data
  train_data <- data[data[[ts_var]] <= date_cutoff]
  test_data <- data[data[[ts_var]] > date_cutoff]

  return(list(train = train_data, test = test_data))
}

prevailing_means <- function(full_data, train_data, test_data, y, ts_var) {
  # Initialize prediction vector
  predictions <- numeric(nrow(test_data))

  # Loop over each row in the test data
  for (i in 1:nrow(test_data)) {
    # Get the current test date
    current_date <- test_data[i, get(ts_var)]

    # Get the prevailing mean up to the current test date using full data
    prevailing_mean <- full_data[get(ts_var) < current_date, mean(get(y), na.rm = TRUE)]

    # Store the prediction
    predictions[i] <- prevailing_mean
  }

  return(predictions)
}

# Pipeline Version
TSML$set("public", "train_test_split", function(cutoff = 0.8) {
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
})

TSML$set("public", "prevailing_means", function() {
  full_data <- self$data
  test_data <- self$test_data
  y <- self$y
  ts_var <- self$ts_var

  # Initialize prediction vector
  predictions <- numeric(nrow(test_data))

  # Loop over each row in the test data
  for (i in 1:nrow(test_data)) {
    # Get the current test date
    current_date <- test_data[i, get(ts_var)]

    # Get the prevailing mean up to the current test date using full data
    prevailing_mean <- full_data[get(ts_var) < current_date, mean(get(y), na.rm = TRUE)]

    # Store the prediction
    predictions[i] <- prevailing_mean
  }

  return(predictions)
})




