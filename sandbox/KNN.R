library(kknn)
mlr_KNN <- function(training_data,
                    y,
                    ...) {
  KNN <- TaskClassif$new(id = "KNN", backend = training_data, target = y)
  lrn_KNN <- lrn("classif.kknn", ...)
  lrn_KNN$train(KNN)
  return(lrn_KNN)
}

test_KNN <- function(training_data,
                     testing_data,
                     y,
                     ...) {
  mlr_model <- mlr_KNN(training_data, y, ...)
  mlr_model_fitted <- mlr_model$model
  mlr_model_predict <- mlr_model$predict_newdata(testing_data)[["response"]]

  formula <- as.formula(paste(y, "~", paste(colnames(training_data[, !..y]), collapse = " + ")))
  KNN_model <- kknn::kknn(formula, training_data, testing_data, ...)
  KNN_predict <- unname(predict(KNN_model))

  if (identical(mlr_model_predict, KNN_predict)) {
    print("KNN test passed.")
  } else {
    stop("Warning: KNN test failed.")
  }
}
