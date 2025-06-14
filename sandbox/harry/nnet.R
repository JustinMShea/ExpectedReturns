library(nnet)
mlr_nnet <- function(training_data,
                     y,
                     ...) {
  nnet <- TaskClassif$new(id = "nnet", backend = training_data, target = y)
  lrn_nnet <- lrn("classif.nnet", ...)
  lrn_nnet$train(nnet)
  return(lrn_nnet)
}

test_nnet <- function(training_data,
                     testing_data,
                     y,
                     seed = 123,
                     ...) {
  set.seed(seed)
  mlr_model <- mlr_nnet(training_data, y, ...)
  mlr_model_fitted <- mlr_model$model
  mlr_model_predict <- mlr_model$predict_newdata(testing_data)[["response"]]

  set.seed(seed)
  formula <- as.formula(paste(y, "~", paste(colnames(training_data[, !..y]), collapse = " + ")))
  nnet_model <- nnet::nnet(formula, training_data, size = 3, ...)
  nnet_predict <- unname(factor(predict(nnet_model, testing_data, type = "class")))

  if (identical(mlr_model_predict, nnet_predict)) {
    print("nnet test passed.")
  } else {
    stop("Warning: nnet test failed.")
  }
}
