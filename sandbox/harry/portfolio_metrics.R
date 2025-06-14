portf_metrics <- function(return_list,
                          weight_list = NULL,
                          p = 0.05,
                          VaR_method = c("gaussian", "historical", "modified"),
                          names = NULL){
  if (!is.list(return_list)) {
    return_list <- list(return_list)
  }

  if (!is.null(weight_list)) {
    if (!is.list(weight_list)) {
      weight_list <- list(weight_list)
    }
    if (length(return_list) != length(weight_list)) {
      stop("Return list and weight list must have equal numbers of objects.")
    }
  }

  VaR_method <- VaR_method[1]

  metrics <- data.frame()
  for (n in 1:length(return_list)) {
    portf_returns <- return_list[[n]][, 2]
    if (!is.null(weight_list)) {
      portf_weights <- weight_list[[n]]
    }
    avg_ret <- DescTools::Gmean(portf_returns + 1, na.rm = TRUE) - 1  # Arithmetic mean
    vol <- sd(portf_returns, na.rm = T)                               # Volatility
    #Use VaR from PerformanceAnalytics to calculate value at risk
    VaR <- VaR(portf_returns, p = 1 - p, method = VaR_method)
    CVaR <- ETL(portf_returns, p = 1 - p, method = VaR_method)
    metrics <- rbind(metrics, c(avg_ret, vol, Sharpe_ratio, VaR, CVaR))# Aggregation of all of this
  }
  colnames(metrics) <- c("Mean Return", "Volatility", "Sharpe Ratio", "VaR", "CVaR")
  if (!is.null(names)) {
    row.names(metrics) <- names
  }
  return(metrics)
}
