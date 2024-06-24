library(MASS)
mlr_lda <- function(training_data,
                    y,
                    ...) {
  lda <- TaskClassif$new(id = "lda", backend = training_data, target = y)
  lrn_lda <- lrn("classif.lda", ...)
  lrn_lda$train(lda)
  return(lrn_lda)
}

test_lda <- function(training_data,
                     testing_data,
                     y,
                     ...) {
  mlr_model <- mlr_lda(training_data, y, ...)
  mlr_model_fitted <- mlr_model$model
  mlr_model_predict <- mlr_model$predict_newdata(testing_data)[["response"]]

  formula <- as.formula(paste(y, "~", paste(colnames(training_data[, !..y]), collapse = " + ")))
  lda_model <- MASS::lda(formula, training_data, ...)
  lda_predict <- unname(predict(lda_model, test_x, type = "response"))[[1]]

  if (identical(mlr_model_predict, lda_predict)) {
    print("lda test passed.")
  } else {
    stop("Warning: lda test failed.")
  }
}
