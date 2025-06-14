library(ranger)
mlr_ranger <- function(training_data,
                      y,
                      ...) {
  ranger <- TaskRegr$new(id = "ranger", backend = training_data, target = y)
  lrn_ranger <- lrn("regr.ranger", ...)
  lrn_ranger$train(ranger)
  return(lrn_ranger)
}

test_ranger <- function(training_data,
                       testing_data,
                       y,
                       ...) {
  mlr_forest <- mlr_ranger(training_data, y, ...)
  mlr_forest_fitted <- mlr_forest$model
  mlr_forest_predict <- mlr_forest$predict_newdata(testing_data)[["response"]]

  formula <- as.formula(paste(y, "~", paste(colnames(training_data[, !..y]), collapse = " + ")))
  ranger_forest <- ranger::ranger(formula, training_data, ...)
  ranger_predict <- predict(ranger_forest, testing_data)$predictions

  if (identical(mlr_forest_predict, ranger_predict)) {
    print("ranger test passed.")
  } else {
    stop("Warning: ranger test failed.")
  }
}
