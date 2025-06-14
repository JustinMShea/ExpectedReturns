library(MASS)
mlr_qda <- function(training_data,
                    y,
                    ...) {
  qda <- TaskClassif$new(id = "qda", backend = training_data, target = y)
  lrn_qda <- lrn("classif.qda", ...)
  lrn_qda$train(qda)
  return(lrn_qda)
}

test_qda <- function(training_data,
                     testing_data,
                     y,
                     ...) {
  mlr_model <- mlr_qda(training_data, y, ...)
  mlr_model_fitted <- mlr_model$model
  mlr_model_predict <- mlr_model$predict_newdata(testing_data)[["response"]]

  formula <- as.formula(paste(y, "~", paste(colnames(training_data[, !..y]), collapse = " + ")))
  qda_model <- MASS::qda(formula, training_data, ...)
  qda_predict <- unname(predict(qda_model, test_x, type = "response"))[[1]]

  if (identical(mlr_model_predict, qda_predict)) {
    print("qda test passed.")
  } else {
    stop("Warning: qda test failed.")
  }
}
