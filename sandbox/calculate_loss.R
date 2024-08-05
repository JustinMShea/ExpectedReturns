calculate_loss <- function(prediction,
                           truth,
                           loss_function = c("mse", "mspe", "mae", "mape",
                                             "huber", "pseudo_huber", "logcosh",
                                             "tweedie", "log_likelihood", "elastic_net",
                                             "smooth_l1"),
                           weights = NULL,
                           ...) {

  loss_function <- match.arg(loss_function)

  if (is.null(weights)) {
    weights <- rep(1, length(truth))
  }

  weights <- weights / sum(weights)

  if (inherits(prediction, "data.table") | (inherits(prediction, "data.frame"))) {
    prediction <- as.numeric(unlist(prediction))
  }

  if (inherits(truth, "data.table") | (inherits(truth, "data.frame"))) {
    truth <- as.numeric(unlist(truth))
  }

  loss <- switch(
    loss_function,
    mse = mse(prediction, truth, weights),
    mspe = mspe(prediction, truth, weights),
    mae = mae(prediction, truth, weights),
    mape = mape(prediction, truth, weights),
    huber = huber(prediction, truth, weights, list(...)$delta),
    pseudo_huber = pseudo_huber(prediction, truth, weights, list(...)$delta),
    logcosh = logcosh(prediction, truth, weights),
    tweedie = tweedie(prediction, truth, weights, list(...)$power),
    log_likelihood = log_likelihood(prediction, truth, weights, list(...)$sigma),
    elastic_net = elastic_net(prediction, truth, weights, list(...)$alpha, list(...)$lambda),
    smooth_l1 = smooth_l1(prediction, truth, weights, list(...)$beta),
    stop("Unknown loss function.")
  )

  return(loss)
}

mse <- function(prediction, truth, weights = NULL) {
  return(mean(weights * (prediction - truth)^2))
}

mspe <- function(prediction, truth, weights = NULL){
  return(mean(weights * ((prediction - truth) / truth)^2))
}

mae <- function(prediction, truth, weights = NULL) {
  return(mean(weights * abs(prediction - truth)))
}

mape <- function(prediction, truth, weights = NULL) {
  return(mean(weights * abs((prediction - truth) / truth)))
}

huber <- function(prediction, truth, weights = NULL, delta = 1) {
  residual <- prediction - truth
  condition <- abs(residual) <= delta
  loss <- ifelse(condition,
                 0.5 * (residual^2),
                 delta * (abs(residual) - 0.5 * delta))
  return(mean(weights * loss))
}

pseudo_huber <- function(prediction, truth, weights = NULL, delta = 1) {
  residual <- prediction - truth
  loss <- delta^2 * sqrt(1 + (residual/delta)^2 - 1)
  return(mean(weights * loss))
}

logcosh <- function(prediction, truth, weights = NULL) {
  return(weights * log(cosh(prediction - truth)))
}

tweedie <- function(prediction, truth, weights = NULL, power = 1) {
  if (power <= 1) {
    stop("Power parameter must be greater than 1.")
  }
  loss <- truth^2 - 2 * truth * prediction^(2-power) + prediction^(3-power)
  return(mean(weights * loss))
}

log_likelihood <- function(prediction, truth, weights = NULL, sigma = 1) {
  loss <- (1/2) * log(2 * pi * sigma^2) + (1 / (2 * sigma^2)) * (truth - prediction)^2
  return(mean(weights * loss))
}

elastic_net <- function(prediction, truth, weights = NULL, alpha = 0.5, lambda = 0.01) {
  loss_l1 <- sum(abs(prediction))
  loss_l2 <- sum(prediction^2)
  loss <- lambda * ((1 - alpha) * loss_l2 + alpha * loss_l1)
  return(mean(weights * loss))
}

smooth_l1 <- function(prediction, truth, weights = NULL, beta = 1) {
  residual <- prediction - truth
  loss <- ifelse(abs(residual) < beta,
                 0.5 * (residual)^2 / beta,
                 abs(residual) - 0.5 * beta)
  return(mean(weights * loss))
}



