benchmark_strategy <- function(object,
                               lookback = NULL,
                               w = c("equal", "scaled"),
                               trim = 0) {
  if ((trim < 0) | (trim > 1)) {
    stop("Error: trim must be a number between 0 and 1.")
  }

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

  for (t in 1:test_T) {
    current_test <- data[get(ts_var) == Time[train_T + t], ]
    past_returns <- current_train[, .(gmean = DescTools::Gmean(get(y) + 1, na.rm = TRUE)), by = get(cs_var)]
    names(past_returns) <- c(cs_var, "gmean")
    past_returns <- merge(current_test[, c(cs_var, y), with = FALSE], past_returns, by = cs_var, all.x = TRUE)
    past_returns[is.na(past_returns)] <- 0
    past_returns[, flag := as.numeric(gmean > quantile(past_returns[, gmean], trim))]
    if (w == "equal") {
      n <- sum(past_returns[, flag])
      weights <- past_returns[, flag] * (1 / sum(past_returns[, flag]))
    } else if (w == "scaled") {
      past_returns[, gmean] <- past_returns[, gmean] * past_returns[, flag]
      weights <- past_returns[, gmean] / sum(past_returns[, gmean])
    }
    names <- past_returns[, ..cs_var][[1]]
    idx <- na.omit(match(names, ticks))
    portf_weights[t, idx] <- weights$weights
    portf_returns[t, ] <- c(Time[train_T + t], sum(weights$weights * past_returns[, ..y]))
    train_start <- train_start + 1
    train_end <- train_end + 1
    current_train <- data[get(ts_var) >= Time[train_start] & get(ts_var) <= Time[train_end], ]
  }

  return(list(portf_weights, portf_returns))
}
