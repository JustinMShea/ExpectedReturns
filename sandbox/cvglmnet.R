cvglmnet <- function(training_data,
                     y,
                     alpha = 0.5) {
  enet <- TaskRegr$new(id = "enet", backend = training_data, target = y)
  lrn_enet <- lrn("regr.cv_glmnet", alpha = alpha)
  lrn_enet$train(enet)
  return(lrn_enet)
}

test_cvglmnet <- function(training_data,
                          testing_data,
                          y,
                          alpha = 0.5) {
  x_test <- as.matrix(testing_data[, !y])

  mlr_enet <- cvglmnet(training_data, y, alpha)
  mlr_enet_fitted <- mlr_enet$model
  mlr_enet_lambda_min <- mlr_enet_fitted$lambda.min

  mlr_enet_predict <- predict(fitted_lasso, x_test, mlr_enet_lambda_min)

  x_train <- as.matrix(training_data[, !y])
  y_train <- training_data[[y_var]]

  glm_enet <- cv.glmnet(x_train, y_train, alpha = alpha)
  glm_enet_lambda_min <- mlr_enet$lambda.min

  glm_predict <- predict(glm_enet, s = glm_enet_lambda_min, newx = x_test)

  return(all.equal(mlr_enet_predict, glm_predict))
}