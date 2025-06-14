#' Out-of-sample R square
#'
#' @section Usage
#' TSML$rsq(benchmark = "prevailing means")
#'
#' @section Arguments
#' @param benchmark A character or string for the benchmark used for calculating out of sample R^2. Default value set to "zero"

TSML$set("public", "rsq", function(benchmark = "zero") {
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
