#' Create prevailing means benchmark.
#' @section Usage
#' TSML$prevailing_means(
#' window = NULL,
#' weights = NULL,
#' name = "prevailing means"
#' )
#'
#' @section Arguments
#' @param window A number for rolling window length.
#' @param weights A vector of non-negative and finite sample weights, must have the same length as @param window if both are specified
#' @param name A string for benchmark name. Default to "prevailing means"
#' @param ... Additional arguments. Currently ignored
#'
#' @section Returns
#' A vector of prevailing mean predictions with the same length as the test data stored in the public benchmark field.

prevailing_means <- function(full_data, train_data, test_data, y, ts_var,
                             window = NULL, weights = NULL, name = "prevailing means",
                             ...) {
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

TSML$set("public", "prevailing_means", function(window = NULL,
                                                weights = NULL,
                                                name = "prevailing means",
                                                ...){

  if ((!is.null(window)) & (!is.numeric(window))) {
    stop("Error: rolling window must be either 'default' or a number.")
  }

  if ((is.numeric(window)) & (window > nrow(self$train_data))) {
    stop("Error: rolling window cannot be larger than the size of the training data.")
  }

  if (!is.null(weights)) {
    if (window == "default") {
      window <- length(weights)
      if (!self$quiet) {
        message("Rolling window size set to weights size.")
      }
    } else if (window != length(weights)) {
      stop("Error: rolling window size must match the length of the weights vector.")
    }
    if (!is.numeric(weights)) {
      stop("Error: weights must be numbers.")
    } else {
      if(anyNA(weights)) {
        weights[is.na(weights)] <- 0
        warning("Warning: weights vector contains NA, changed to 0.")
      }
      if(sum(weights, na.rm = TRUE) == 0) {
        stop("Error: weights cannot be 0.")
      }
      if(sum(weights, na.rm = TRUE) != 1) {
        weights <- weights / sum(weights)
        message("Weights did not sum to 1. Scaled weights.")
      }
    }
  }

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

    if (is.null(window)) {
      prevailing_mean <- data[get(ts_var) < current_date, mean(get(y), na.rm = TRUE)]
    } else {
      window_data <- data[get(ts_var) < current_date, ]
      window_data <- window_data[(nrow(window_data) - window + 1):nrow(window_data), ]
      if (!is.null(weights)) {
        prevailing_mean <- weighted.mean(window_data[[y]], weights, na.rm = TRUE)
      } else {
        prevailing_mean <- window_data[, mean(get(y), na.rm = TRUE)]
      }
    }

    predictions[i] <- prevailing_mean
  }

  self$benchmark[[name]] <- predictions
})
