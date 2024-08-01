train_validate_predict <- function(object,
                                   model,
                                   recursive = FALSE,
                                   vars = NULL,
                                   cv = NULL,
                                   param_grid = NULL,
                                   window = NULL,
                                   buffer = 0,
                                   ...){
  data <- object$data
  train_data <- object$train_data
  test_data <- object$test_data
  ts_var <- object$ts_var
  target_var <- object$y

  if (is.null(vars)) {
    vars <- setdiff(names(train_data), ts_var)
  }

  learner <- lrn(model)

  predictions <- c()
  true_values <- c()

  if (recursive) {
    if (is.null(window)) {
      stop("Window must be specified when recursive is TRUE.")
    }

    best_mse <- Inf
    best_params <- NULL

    for (params in expand.grid(param_grid)) {
      learner$param_set$values <- as.list(params)

      total_mse <- 0
      num_folds <- 0

      start_index <- nrow(train_data) - cv + 1

      for (i in seq(start_index, nrow(train_data))) {
        # Define the training and validation window
        train_start <- max(1, i - window - buffer)
        train_end <- i - buffer - 1
        valid_index <- i

        # Prepare training and validation data
        train_window <- train_data[train_start:train_end, ..vars, with = FALSE]
        valid_point <- train_data[valid_index, ..vars, with = FALSE]

        # Update task with new training window
        task <- TaskRegr$new(id = "time_series_task", backend = train_window, target = target_var)

        # Train the model on the current window
        learner$train(task)

        # Make prediction on the validation point
        prediction <- learner$predict_newdata(valid_point)

        # Calculate the error for the validation point
        actual_value <- train_data[valid_index, get(target_var)]
        mse <- (actual_value - prediction$response)^2
        total_mse <- total_mse + mse
        num_folds <- num_folds + 1
      }

      # Average MSE for the current parameter set
      average_mse <- total_mse / num_folds
      if (average_mse < best_mse) {
        best_mse <- average_mse
        best_params <- as.list(params)
      }
    }
  }
}
