#' Momentum Trading Signal
#'
#' Function to compute several momentum trading signals.
#'
#' @param X An `xts` object, storing assets data. See 'Details'.
#' @param lookback A numeric, indicating the number of lookback periods in months.
#' @param signal A character, selecting the momentum signal. One of `SIGN`, `MA`, `EEMD`, `TREND`, or `SMT`.
# #' @param speed A boolean, whether or not to compute the *momentum signal speed*.
#'
#' @return
#'
#' @details
#' Data strictly needed in `X` depends on the `signal` chosen. For `SIGN` only
#' returns are needed. `MA`, `EEMD`, `TREND`, and `SMT` require closing prices.
#'
#' @references
#' Baltas, Akindynos-Nikolaos and Kosowski, Robert (2012). *Improving time-series momentum strategies: The role of trading signals and volatility estimators*.
#' [EDHEC-Risk Institute](https://risk.edhec.edu/publications/improving-time-series-momentum-strategies-role-trading-signals-and-volatility)
#'
#' @author
#' Vito Lestingi
#'
#' @importFrom PerformanceAnalytics apply.rolling
#' @importFrom xts xts
#'
#' @export
#'
MomSignal <- function(X
                      , lookback
                      , signal
                      # , speed
                      )
{
  if (missing(signal)) signal <- 'SIGN'
  signals.avail <- c('SIGN') # c('SIGN', 'MA', 'EEMD', 'TREND', 'SMT')
  signal <- match.arg(signal, signals.avail)
  switch (signal,
    SIGN = {
      mom.signal <- lapply(X, function(x) {
        y <- sign(
          apply.rolling(
            xts(x$Comp.Return, x$Date),
            width=lookback, cumsum, by=1
          )
        )
      })
    }
  )
  # TODO
  # if (speed) {
  #
  # }
  return(mom.signal)
}
