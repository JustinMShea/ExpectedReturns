train_validate_predict <- function(object,
                                   model,
                                   vars = NULL,
                                   cv = NULL,
                                   cv_loss = c("mse", "mspe", "mae", "mape",
                                               "huber", "pseudo_huber", "logcosh",
                                               "tweedie", "log_likelihood", "elastic_net",
                                               "smooth_l1"),
                                   param_grid = NULL,
                                   window = NULL,
                                   buffer = 0,
                                   weights = NULL,
                                   ...){
  cv_loss <- match.arg(cv_loss)

  data <- object$data
  train_data <- object$train_data
  test_data <- object$test_data
  ts_var <- object$ts_var
  y <- object$y

  if (is.null(vars)) {
    vars <- setdiff(names(train_data), ts_var)
  }

  learner <- lrn(model)

  predictions <- c()
  true_values <- c()

  if (recursive) {

    best_loss <- Inf
    best_params <- NULL

    for (row in 1:nrow(expand.grid(param_grid))) {
      params <- expand.grid(param_grid)[row, ]
      for (col in 1:length(params)) {
        learner$param_set$values[names(params[col])] <- params[col]
      }

      total_loss <- 0
      num_folds <- 0

      val_start <- nrow(train_data) - cv + 1
      val_end <- nrow(train_data)

      for (i in val_start:val_end) {
        train_start <- ifelse(is.null(window), 1, max(1, i - window - buffer))
        train_end <- i - buffer - 1
        valid_index <- i

        train_window <- train_data[train_start:train_end, ..vars, with = FALSE]
        valid_point <- train_data[valid_index, ..vars, with = FALSE]

        task <- TaskRegr$new(id = "ts_validate", backend = train_window, target = y)

        learner$train(task)

        prediction <- learner$predict_newdata(valid_point)$response

        truth <- train_data[valid_index, ..y]
        loss <- mean(calculate_loss(prediction, truth, cv_loss, weights), na.rm = TRUE)
        total_loss <- total_loss + loss
        num_folds <- num_folds + 1
      }

      average_loss <- total_loss / num_folds
      if (average_loss < best_loss) {
        best_loss <- average_loss
        best_params <- params
      }
    }
    for (col in 1:length(best_params)) {
      learner$param_set$values[names(best_params[col])] <- best_params[col]
    }

    test_start <- nrow(train_data) + 1
    test_end <- nrow(data)
    for (i in test_start:test_end) {
      train_start <- i - window - buffer
      train_end <- i - buffer - 1
      test_index <- i

      train_window <- data[train_start:train_end, ..vars, with = FALSE]
      test_point <- data[test_index, ..vars, with = FALSE]

      task <- TaskRegr$new(id = "ts_predict", backend = train_window, target = y)

      learner$train(task)

      predictions <- c(predictions, learner$predict_newdata(test_point)$response)
    }
    true_values <- data[test_start:test_end, ..y, with = FALSE]
  }
}
