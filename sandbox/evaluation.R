TSML$set("public", "mae", function() {
  if (is.null(self$test_data) || is.null(self$prediction)) {
    stop("Error: test data or prediction is missing.")
  }

  true_values <- self$test_data[[self$y]]
  predicted_values <- self$prediction

  mae <- mean(abs(true_values - predicted_values), na.rm = TRUE)
  self$evals[["mae"]] <- mae
})

TSML$set("public", "mse", function() {
  if (is.null(self$test_data) || is.null(self$prediction)) {
    stop("Error: test data or prediction is missing.")
  }

  true_values <- self$test_data[[self$y]]
  predicted_values <- self$prediction

  mse <- mean((true_values - predicted_values)^2, na.rm = TRUE)
  self$evals[["mse"]] <- mse
})

TSML$set("public", "rsq", function(benchmark = "prevailing means") {
  if (is.null(self$test_data) || is.null(self$prediction)) {
    stop("Error: test data or prediction is missing.")
  }

  true_values <- self$test_data[[self$y]]
  predicted_values <- self$prediction

  ss_res <- sum((true_values - predicted_values)^2, na.rm = TRUE)
  if (!benchmark %in% names(self$benchmark)) {
    stop("Error: benchmark not defined.")
  }
  ss_total <- sum((true_values - self$benchmark[[benchmark]])^2, na.rm = TRUE)


  rsq <- 1 - (ss_res / ss_total)
  self$evals[["rsq"]] <- rsq
})
