benchmark_strategy <- function(object,
                               lookback = NULL,
                               w = c("equal", "scaled")) {
  data <- object$data
  ts_var <- object$ts_var
  y <- object$y

  Time <- unique(data[, ..ts_var])
  train_T <- length(unique(object$train_data[, ..ts_var]))
  test_T <- length(unique(object$test_data[, ..ts_var]))

  train_end <- train_T
  if (is.null(lookback)) {
    train_start = 1
  } else {
    train_start = train_T - lookback + 1
  }

  current_train <- data[ts_var >= Time[train_start] | ts_var <= Time[train_end], ]

  N <- length(unique(object[, ..object$cs_var]))

  portf_weights <- matrix(0, nrow = test_T, ncol = N)
  portf_returns <- matrix(0, nrow = test_T, ncol = 2)

  w = w[1]

  if (w == "equal") {
    portf_weights <- matrix(1/N, nrow = test_T, ncol = N)
    for (t in 1:test_T) {
      portf_returns[t, ] <- c(Time[train_T + t], sum(portf_weights[t, ] * current_test[, ..y]))
    }
  } else if (w == "scaled") {
    for (t in 1:test_T) {
      new_test <- current_test[ts_var == Time[train_T + t], ]
      past_returns <- current_train[, lapply(y, DescTools::Gmean), by = object$cs_var]
      portf_weights[t, ] <- past_returns / sum(predictions)
    }
  }
}
