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

TSML$set("public", "prevailing_means", function(){

  test_data <- self$test_data
  ts_var <- self$ts_var
  data <- self$data
  y <- self$y

  if (is.null(test_data)) {
    stop("Error: must split training and test data before constructing prevailing means benchmark, see train_test_split().")
  }

  predictions <- numeric(nrow(test_data))

  for (i in 1:nrow(test_data)){
    current_date <- test_data[i, get(ts_var)]

    prevailing_mean <- data[get(ts_var) < current_date, mean(get(y), na.rm = TRUE)]

    predictions[i] <- prevailing_mean
  }

  self$benchmark[["prevailing means"]] <- predictions
})
