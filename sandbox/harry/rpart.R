library(rpart)
mlr_rpart <- function(training_data,
                     y,
                     ...) {
  rpart <- TaskRegr$new(id = "rpart", backend = training_data, target = y)
  lrn_rpart <- lrn("regr.rpart")
  lrn_rpart$train(rpart)
  return(lrn_rpart)
}

test_rpart <- function(training_data,
                       testing_data,
                       y,
                       ...) {
  mlr_tree <- mlr_rpart(training_data, y, ...)
  mlr_tree_fitted <- mlr_tree$model
  mlr_tree_predict <- mlr_tree$predict_newdata(testing_data)[["response"]]

  formula <- as.formula(paste(y, "~", paste(colnames(training_data[, !..y]), collapse = " + ")))
  rpart_tree <- rpart::rpart(formula, training_data, ...)
  rpart_predict <- unname(predict(rpart_tree, testing_data))

  if (identical(mlr_tree_predict, rpart_predict)) {
    print("rpart test passed.")
  } else {
    stop("Warning: rpart test failed.")
  }
}
