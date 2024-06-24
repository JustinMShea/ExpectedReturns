library(e1071)
mlr_naiveBayes <- function(training_data,
                    y,
                    ...) {
  naiveBayes <- TaskClassif$new(id = "naiveBayes", backend = training_data, target = y)
  lrn_naiveBayes <- lrn("classif.naive_bayes", ...)
  lrn_naiveBayes$train(naiveBayes)
  return(lrn_naiveBayes)
}

test_naiveBayes <- function(training_data,
                            testing_data,
                            y,
                            ...) {
  mlr_model <- mlr_naiveBayes(training_data, y, ...)
  mlr_model_fitted <- mlr_model$model
  mlr_model_predict <- mlr_model$predict_newdata(testing_data)[["response"]]

  formula <- as.formula(paste(y, "~", paste(colnames(training_data[, !..y]), collapse = " + ")))
  naiveBayes_model <- e1071::naiveBayes(formula, training_data, ...)
  naiveBayes_predict <- unname(predict(naiveBayes_model, test_x, type = "class"))

  if (identical(mlr_model_predict, naiveBayes_predict)) {
    print("naiveBayes test passed.")
  } else {
    stop("Warning: naiveBayes test failed.")
  }
}
