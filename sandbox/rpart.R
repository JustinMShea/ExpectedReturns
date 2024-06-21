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
  mlr_rpart <- mlr_rpart(training_data, y, ...)
  mlr_rpart_fitted <- mlr_rpart$model
  mlr_rpart_predict <- mlr_rpart$predict_newdata(testing_data)[["response"]]

  formula <- paste(y, "~", paste(colnames(training_data[, !..y]), collapse = " + "))
  rpart_rpart <- rpart::rpart(formula, training_data, ...)
  rpart_predict <- unname(predict(rpart_rpart, testing_data))

  if (identical(mlr_rpart_predict, rpart_predict)) {
    print("rpart test passed.")
  } else {
    stop("Warning: rpart test failed.")
  }
}


