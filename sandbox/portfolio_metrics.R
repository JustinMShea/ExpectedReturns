portf_metrics <- function(return_lst,
                          weight_lst,
                          p = 0.05,
                          names = NULL){
  if (!is.list(return_lst)) {
    return_lst <- list(return_lst)
  }
  if (!is.list(weight_lst)) {
    weight_lst <- list(weight_lst)
  }
  if (length(return_lst) != length(weight_lst)) {
    stop("Return list and weight list must have equal numbers of objects.")
  }

  metrics <- data.frame()
  for (n in 1:length(return_lst)) {
    portf_returns <- return_lst[n]
    portf_weights <- weight_lst[n]
    avg_ret <- mean(portf_returns, na.rm = T)                     # Arithmetic mean
    vol <- sd(portf_returns, na.rm = T)                           # Volatility
    Sharpe_ratio <- avg_ret / vol                                 # Sharpe ratio
    #Use VaR from PerformanceAnalytics to calculate value at risk
    metrics <- rbind(metrics, c(avg_ret, vol, Sharpe_ratio, VaR))   # Aggregation of all of this
  }
  if (!is.null(names)) {
    row.names(metrics) <- names
  }
  return(metrics)
}
