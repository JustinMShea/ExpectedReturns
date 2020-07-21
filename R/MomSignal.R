#' @title Momentum Trading Signal
#'
#' @description
#' Function to compute several momentum trading signals.
#'
#' @param X A list of `xts` objects, storing assets data. See 'Details'.
#' @param lookback A numeric, indicating the lookback period in the same frequency of `X` series.
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
#' @importFrom lmtest coeftest
#' @importFrom sandwich NeweyWest
#' @importFrom xts endpoints is.xts xts
#' @importFrom zoo rollmeanr rollsumr
#'
#' @export
#'
MomSignal <- function(X
                      , lookback
                      , signal
                      # , speed
                      )
{
  cl <- match.call()
  # xts conversion
  xts.check <- all(vapply(X, is.xts, FUN.VALUE=logical(1L)))
  if (!xts.check) {
    X <- lapply(X, function(x) {
      # Drop 'character' data type
      x <- x[, !vapply(x, is.character, FUN.VALUE=logical(1L))]
      xts(x[, -1], order.by=x[, 1])
    })
  }
  # Signals calcs
  if (missing(signal)) {
    signal <- 'SIGN'
  } else if (signal == 'TREND' | signal == 'SMT') {
    signal <- 'TREND.SMT'
  }
  # TODO: 'EEMD'
  signals.avail <- c('SIGN', 'MA', 'TREND.SMT')
  signal <- match.arg(signal, signals.avail)
  switch (signal,
    SIGN = {
      mom.signal <- lapply(X, function(x) {
        # [t - j, t], j = 0, ..., lookback, for a fixed t
        y <- rollsumr(x$Comp.Return, lookback, na.rm=TRUE)
        s <- sign(y)
        s[s == 0] <- (-1L)
        colnames(s) <- signal
        return(s)
      })
    },
    MA = {
      mom.signal <- lapply(X, function(x) {
        # [t - j, t], j = 0, ..., lookback, for a fixed t
        y <- rollmeanr(x$Comp.Return, lookback, na.rm=TRUE)
        z <- rollmeanr(x$Comp.Return, round(lookback/12), na.rm=TRUE)
        s <- (-1L) * sign(y - z)
        s[s == 0] <- (-1L)
        colnames(s) <- signal
        return(s)
      })
    },
    TREND.SMT = {
      mom.signal <- lapply(X, function(x) {
        x <- x$Close
        obs.lag <- lookback:1
        lind <- lookback:(nrow(x) - 1)
        nw.tstats <- rsq <- matrix(NA, length(lind))
        s <- matrix(NA, length(lind), dimnames=list(NULL, cl$signal))
        for (i in 1:(nrow(x) - lookback)) {
          # Normalize prices
          w <- x[i:(i + lookback - 1)] / as.numeric(x[i])
          # Regressions
          data <- cbind(w, obs.lag)
          colnames(data) <- c('Close.Norm', 'Obs.Lag')
          mfit <- lm(Close.Norm ~ Obs.Lag, data=data)
          rsq[i, ] <- summary(mfit)$r.squared
          # Newey-West t-stats
          nw.ts <- coeftest(mfit, vcov=NeweyWest(mfit, prewhite=FALSE))
          nw.tstats[i, ] <- nw.ts[2, 't value']
        }
        if (cl$signal == 'TREND') {
          s[1:length(lind), ] <- nw.tstats
          s[-2 <= s & s <= 2] <- 0L
          s[s < (-2)] <- (-1L)
          s[s > 2] <- 1L
        } else if (cl$signal == 'SMT') {
          tmp <- data.frame(s=s, nwts=nw.tstats, rsq=rsq)
          tmp <- within(tmp, {
            SMT[(-2 <= nwts & nwts <= 2) | (0 <= rsq & rsq <= 1)] <- 0L
            SMT[nwts < (-2) & rsq >= 0.65] <- (-1L)
            SMT[nwts > 2 & rsq >= 0.65] <- 1L
          })
          s <- tmp[, 'SMT', drop=FALSE]
        }
        return(xts(s, order.by=index(x)[lind]))
      })
    }
  )
  # TODO
  # if (speed) {
  #
  # }
  return(mom.signal)
}
