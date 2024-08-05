train_validate_predict <- function(object,
                                   model,
                                   recursive = TRUE,
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
    if (is.null(window)) {
      stop("Window must be specified when recursive is TRUE.")
    }

    best_loss <- Inf
    best_params <- NULL

    for (params in expand.grid(param_grid)) {
      learner$param_set$values <- as.list(params)

      total_loss <- 0
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
        task <- TaskRegr$new(id = "time_series_task", backend = train_window, target = y)

        # Train the model on the current window
        learner$train(task)

        # Make prediction on the validation point
        prediction <- learner$predict_newdata(valid_point)$response

        # Calculate the error for the validation point
        truth <- train_data[valid_index, ..y]
        loss <- calculate_loss(preiction, truth, cv_loss, weights)
        total_loss <- total_loss + loss
        num_folds <- num_folds + 1
      }

      # Average MSE for the current parameter set
      average_loss <- total_loss / num_folds
      if (average_loss < best_loss) {
        best_loss <- average_loss
        best_params <- as.list(params)
      }
    }
  }
}
