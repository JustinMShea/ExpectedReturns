build_strategy <- function(object,
                           model,
                           vars = NULL,
                           offset = 0,
                           buffer = NULL,
                           keep = 1,
                           filter = 0,
                           w = c("equal", "scaled"),
                           ...) {

  data <- object$data
  ts_var <- object$ts_var
  cs_var <- object$cs_var
  y <- object$y
  w = w[1]

  if ((is.null(cs_var)) | (cs_var < 2)) {
    stop("Error: cross-sectional variable must be defined and must be greater than 2.")
  }

  if ((w == "equal") & (keep == 1)) {
    warning("Warning: this is equivalent to a equal-weighted benchmark strategy.")
  }

  Time <- sort(unique(data[, ..ts_var][[1]]))
  train_T <- nrow(unique(object$train_data[, ..ts_var]))
  test_T <- nrow(unique(object$test_data[, ..ts_var]))

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
    vars <- setdiff(colnames(data), c(ts_var, cs_var))
  }

  if ((!is.numeric(filter)) | (filter > 1)) {
    stop("Error: filter must be a numeric between 0 and 1.")
  } else if (filter > 0.5) {
    filter <- 1 - filter
  }

  current_train <- data[get(ts_var) >= Time[train_start] & get(ts_var) <= Time[train_end], ..vars]
  current_test <- object$test_data

  ticks <- unique(data[, ..cs_var])[[1]]
  N <- length(ticks)

  portf_weights <- matrix(0, nrow = test_T, ncol = N)
  portf_returns <- matrix(0, nrow = test_T, ncol = 2)

  task <- as_task_regr(current_train, target = y)
  learner <- lrn(model, ...)

  pb <- txtProgressBar()

  for (t in 1:test_T) {
    new_test <- current_test[get(ts_var) == Time[train_T + t], ]
    if (filter > 0) {
      train_idx <- which(current_train[, ..y] < quantile(current_train[, ..y], filter) |
                           current_train[, ..y] > quantile(current_train[, ..y], 1 - filter))
      task$backend <- current_train[train_idx, ]
    }
    learner$train(task)
    predictions <- learner$predict_newdata(new_test[, ..vars])[["response"]]
    weights <- predictions > quantile(predictions, 1 - keep)
    names <- new_test[, ..cs_var][[1]]
    if (w == "equal") {
      weights <- weights / sum(weights)
    } else if (w == "scaled") {
      weights <- (weights * predictions) / sum(weights * predictions)
    }
    idx <- na.omit(match(names, ticks))
    portf_weights[t, idx] <- weights
    portf_returns[t, ] <- c(Time[train_T + t], sum(weights * new_test[, ..y]))
    train_start <- train_start + 1
    train_end <- train_end + 1
    current_train <- data[get(ts_var) >= Time[train_start] & get(ts_var) <= Time[train_end], ..vars]
    task$backend <- as_data_backend(current_train)
    setTxtProgressBar(pb, t/test_T)
  }
  close(pb)
  portf_returns <- as.data.frame(portf_returns)
  names(portf_returns) <- c("Time", "Return")
  return(list(weights = portf_weights, returns = portf_returns))
}

