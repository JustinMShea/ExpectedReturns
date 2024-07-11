portf_metrics <- function(return_list,
                          weight_list,
                          p = 0.05,
                          names = NULL){
  if (!is.list(return_list)) {
    return_list <- list(return_list)
  }
  if (!is.list(weight_list)) {
    weight_list <- list(weight_list)
  }
  if (length(return_list) != length(weight_list)) {
    stop("Return list and weight list must have equal numbers of objects.")
  }

  metrics <- data.frame()
  for (n in 1:length(return_list)) {
    portf_returns <- return_list[[n]][, 2]
    portf_weights <- weight_list[[n]]
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
