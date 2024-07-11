benchmark_strategy <- function(object,
                               lookback = NULL,
                               w = c("equal", "scaled")) {
  data <- object$data
  ts_var <- object$ts_var
  y <- object$y

  Time <- unique(data[, ..ts_var])
  train_T <- length(unique(object$train_data[, ..ts_var]))
  test_T <- length(unique(object$test_data[, ..ts_var]))

  train_end <- train_T - offset

  N <- length(unique(object[, ..object$cs_var]))

  portf_weights <- matrix(0, nrow = test_T, ncol = N)
  portf_returns <- matrix(0, nrow = test_T, ncol = 2)

  w = w[1]

  if (w == "equal") {

  }
}
