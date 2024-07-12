benchmark_strategy <- function(object,
                               lookback = NULL,
                               w = c("equal", "scaled")) {
  data <- object$data
  ts_var <- object$ts_var
  cs_var <- object$cs_var
  y <- object$y

  Time <- sort(unique(data[, ..ts_var])[[1]])
  train_T <- nrow(unique(object$train_data[, ..ts_var]))
  test_T <- nrow(unique(object$test_data[, ..ts_var]))

  train_end <- train_T
  if (is.null(lookback)) {
    train_start = 1
  } else {
    train_start = train_T - lookback + 1
  }

  current_train <- data[get(ts_var) >= Time[train_start] & get(ts_var) <= Time[train_end], ]

  ticks <- unique(data[, ..cs_var])[[1]]
  N <- length(ticks)

  portf_weights <- matrix(0, nrow = test_T, ncol = N)
  portf_returns <- matrix(0, nrow = test_T, ncol = 2)

  w = w[1]

  if (w == "equal") {
    for (t in 1:test_T) {
      current_test <- data[get(ts_var) == Time[train_T + t], ]
      n <- nrow(unique(current_test[, ..cs_var]))
      weights$weights <- rep(1/n, n)
      weights$names <- unique(current_test[, ..cs_var])[[1]]
      idx <- na.omit(match(weights$names, ticks))
      portf_weights[t, idx] <- weights$weights
      portf_returns[t, ] <- c(Time[train_T + t], sum(weights$weights * current_test[, ..y]))
    }
  } else if (w == "scaled") {
    for (t in 1:test_T) {
      current_test <- data[get(ts_var) == Time[train_T + t], ]
      past_returns <- current_train[, .(gmean = Gmean(get(y) + 1, na.rm = TRUE)), by = get(cs_var)]
      names(past_returns) <- c(cs_var, "gmean")
      past_returns <- merge(current_test[, c(cs_var, y), with = FALSE], past_returns, by = cs_var, all.x = TRUE)
      past_returns[is.na(past_returns)] <- 0
      # This is probably not the based scale. May want to consider various scaling schemes
      weights$weights <- past_returns[, gmean] / sum(past_returns[, gmean])
      weights$names <- unique(past_returns[, ..cs_var])[[1]]
      idx <- na.omit(match(weights$names, ticks))
      portf_weights[t, idx] <- weights$weights
      portf_returns[t, ] <- c(Time[train_T + t], sum(weights$weights * past_returns[, ..y]))
      train_start <- train_start + 1
      train_end <- train_end + 1
      current_train <- data[get(ts_var) >= Time[train_start] & get(ts_var) <= Time[train_end], ]
    }
  }
  return(list(portf_weights, portf_returns))
}
