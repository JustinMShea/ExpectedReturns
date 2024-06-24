library(e1071)
mlr_svm <- function(training_data, y, ...) {
  svm <- TaskRegr$new(id = "svm",
                      backend = training_data,
                      target = y)
  lrn_svm <- lrn("regr.svm", ...)
  lrn_svm$train(svm)
  return(lrn_svm)
}

test_svm <- function(training_data, testing_data, y, ...) {
  mlr_model <- mlr_svm(training_data, y, ...)
  mlr_model_fitted <- mlr_model$model
  mlr_model_predict <- mlr_model$predict_newdata(testing_data)[["response"]]

  train_x <- training_data[, !..y]
  train_y <- training_data[, ..y]
  test_x <- testing_data[, !..y]
  svm_model <- e1071::svm(train_x, train_y, ...)
  svm_predict <- unname(predict(svm_model, test_x, type = "response"))

  if (identical(mlr_model_predict, svm_predict)) {
    print("svm test passed.")
  } else {
    stop("Warning: svm test failed.")
  }
}
