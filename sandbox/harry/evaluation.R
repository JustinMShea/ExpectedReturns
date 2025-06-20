

TSML$set("public", "RegressionMetrics", function() {
  if (is.null(self$test_data) || is.null(self$prediction)) {
    stop("Error: test data or prediction is missing.")
  }

  if (self$task != "REGRESSION") {
    stop("Error: regression metrics can only be calculated for a regression task.")
  }

  true_values <- self$test_data[[self$y]]
  predicted_values <- self$prediction

  mae <- mean(abs(true_values - predicted_values), na.rm = TRUE)
  mse <- mean((true_values - predicted_values)^2, na.rm = TRUE)
  mape <- mean(abs((true_values - predicted_values) / true_values), na.rm = TRUE)
  mspe <- mean(((true_values - predicted_values) / true_values)^2, na.rm = TRUE)
  rmsle <- sqrt(mean(log((1 + true_values) / (1 + predicted_values)), na.rm = TRUE))

  self$evals[["mae"]] <- mae
  self$evals[["mse"]] <- mse
  self$evals[["mape"]] <- mape
  self$evals[["mspe"]] <- mspe
  self$evals[["rmsle"]] <- rmsle
})

TSML$set("public", "ClassificationMetrics", function(){
  if (is.null(self$test_data) || is.null(self$prediction)) {
    stop("Error: test data or prediction is missing.")
  }

  if (self$task != "CLASSIFICATION") {
    stop("Error: classification metrics can only be calculated for a classification task.")
  }

  true_values <- self$test_data[[self$y]]
  predicted_values <- selfprediction

  TP <- mean(as.numeric((true_values == 1) && (predicted_values == 1)), na.rm = TRUE)
  TN <- mean(as.numeric((true_values == 0)))
})

TSML$set("public", "rsq", function(benchmark) {
  if (is.null(self$test_data) || is.null(self$prediction)) {
    stop("Error: test data or prediction is missing.")
  }

  true_values <- self$truth
  predicted_values <- self$prediction

  ss_res <- sum((true_values - predicted_values)^2, na.rm = TRUE)
  if (!benchmark %in% names(self$benchmark)) {
    stop("Error: benchmark not defined.")
  }
  ss_total <- sum((true_values - self$benchmark[[benchmark]])^2, na.rm = TRUE)


  rsq <- 1 - (ss_res / ss_total)
  self$evals[["rsq"]] <- rsq
})
