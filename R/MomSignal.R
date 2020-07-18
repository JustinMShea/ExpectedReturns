#' Momentum Trading Signal
#'
#' Function to compute several momentum trading signals.
#'
#' @param X A list of `xts` objects, storing assets data. See 'Details'.
#' @param lookback A numeric, indicating the number of lookback periods in months.
#' @param signal A character, selecting the momentum signal. One of `SIGN`, `MA`, `EEMD`, `TREND`, or `SMT`.
# #' @param speed A boolean, whether or not to compute the *momentum signal speed*.
#'
#' @return
#' A list of `xts` objects, consisting of the chosen momentum `signal` for the corresponding assets data `X` provided.
#'
#' @details
#' Data strictly needed in `X` depends on the `signal` chosen. For `SIGN` only
#' returns are needed. `MA`, `EEMD`, `TREND`, and `SMT` require closing prices.
#'
#' @references
#' Baltas, Akindynos-Nikolaos and Kosowski, Robert (2012). *Improving time-series momentum strategies: The role of trading signals and volatility estimators*.
#' [EDHEC-Risk Institute](https://risk.edhec.edu/publications/improving-time-series-momentum-strategies-role-trading-signals-and-volatility).
#'
#' @author
#' Vito Lestingi
#'
#' @importFrom PerformanceAnalytics apply.rolling
#' @importFrom xts endpoints is.xts period.sum xts
#'
#' @export
#'
MomSignal <- function(X
                      , lookback
                      , signal
                      # , speed
                      )
{
  xts.check <- all(vapply(X, is.xts, FUN.VALUE=logical(1L)))
  if (!xts.check) {
    X <- lapply(X, function(x) {
      # Drop 'character' data type
      x <- x[, !vapply(x, is.character, FUN.VALUE=logical(1L))]
      xts(x[, -1], order.by=x[, 1])
    })
  }
  # Signals calcs
  if (missing(signal)) signal <- 'SIGN'
  # TODO: c('EEMD', 'TREND', 'SMT')
  signals.avail <- c('SIGN', 'MA')
  signal <- match.arg(signal, signals.avail)
  switch (signal,
    SIGN = {
      mom.signal <- lapply(X, function(x) {
        y <- sign(
          apply.rolling(
            x$Comp.Return, width=lookback, cumsum, by=1
          )
        )
        y[y == 0] <- (-1L)
        colnames(y) <- signal
        return(y)
      })
    },
    MA = {
      mom.signal <- lapply(X, function(x) {
        ep <- endpoints(x)
        ma <- 1/diff(ep) * period.sum(x$Close, ep)
        y <- (-1L) * sign(ma - as.numeric(ma[nrow(ma)-1, ]))
        y[y == 0] <- (-1L)
        colnames(y) <- signal
        return(y)
      })
    }
  )
  # TODO
  # if (speed) {
  #
  # }
  return(mom.signal)
}
