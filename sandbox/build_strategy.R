build_strategy <- function(object,
                           model,
                           vars = NULL,
                           offset = 0,
                           buffer = NULL,
                           keep = 1,
                           filter = 0,
                           w = c("equal", "scaled"),
                           ...) {

  if ((is.null(object$cs_var)) || (object$cs_var < 2)) {
    stop("Error: cross-sectional variable must be defined and must be greater than 2.")
  }

  data <- object$data
  ts_var <- object$ts_var
  y <- object$y

  Time <- unique(data[, ..ts_var])
  train_T <- length(unique(object$train_data[, ..ts_var]))
  test_T <- length(unique(object$test_data[, ..ts_var]))

  train_end <- train_T - offset

  if (!is.null(buffer)) {
    if (buffer + offset > length(object$train_data)) {
      stop("Error: the combined length of offset and buffer must be smaller than the length of the initial training sample.")
    }
    train_start <- train_end - buffer + 1
  } else {
    train_start <- 1
  }

  if (is.null(vars)) {
    vars <- setdiff(colnames(data), c(ts_var, object$cs_var))
  }

  if ((!is.numeric(filter)) | (filter > 1)) {
    stop("Error: filter must be a numeric between 0 and 1.")
  } else if (filter > 0.5) {
    filter <- 1 - filter
  }

  current_train <- object$train_data[ts_var >= Time[train_start] | ts_var <= Time[train_end], ..vars]
  current_test <- object$test_data[ts_var > Time[train_end], ..vars]
  N <- length(unique(object[, ..object$cs_var]))

  portf_weights <- matrix(0, nrow = test_T, ncol = N)
  portf_returns <- matrix(0, nrow = test_T, ncol = 2)

  task <- as_task_regr(current_train, target = object$y)
  learner <- lrn(model, ...)

  for (t in 1:length(current_test)) {
    new_test <- current_test[ts_var == Time[train_end + t], ]
    if (filter > 0) {
      train_idx <- which(current_train[, ..y] < quantile(current_train[, ..y], filter) |
                           current_train[, ..y] > quantile(current_train[, ..y], 1 - filter))
      task$backend <- current_train[train_idx, ]
    }
    learner$train(task)
    predictions <- learner$predict_newdata(new_test)[["response"]]
    weights <- predictions > quantile(predictions, 1 - keep)
    if (w == "equal") {
      portf_weights[t, ] <- weights / sum(weights)
    } else if (w == "scaled") {
      portf_weights[t, ] <- (weights * predictions) / sum(weights * predictions)
    }
    portf_returns[t, ] <- c(Time[train_end + t], sum(portf_weights[t, ] * current_test[, ..y]))
  }
  return(list(portf_weights, portf_returns))
}

