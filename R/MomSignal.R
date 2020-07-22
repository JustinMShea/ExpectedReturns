#' @title Momentum Trading Signal
#'
#' @description
#' Function to generate several momentum trading signals. Signals currently implemented are:
#' * **Return Sign** (SIGN) of Moskowitz-Ooi-Pedersen (2012)
#' * **Moving Average** (MA)
#' * **Time-Trend t-statistic** (TREND)
#' * **Statistically Meaningful Trend** (SMT) of Bryhn-Dimberg (2011)
#'
#' All the signals are as defined in Baltas-Kosowski (2012).
#'
#' Also, to each of signal can be associated a so called *momentum speed*, which is
#' an activity to turnover-ratio used to assess signals trading intensity. Letting
#' \eqn{X} the signal, its speed is defined as
#' \deqn{SPEED_{X} = \sqrt{\frac{E[X^2]}{E[(\DeltaX)^2]}}}
#' The higher the speed, the larger the signal activity and thus the portfolio turnover.
#'
#' @param X A list of `xts` objects, storing assets data. See 'Details'.
#' @param lookback A numeric, indicating the lookback period in the same frequency of `X` series.
#' @param signal A character, specifying the momentum signal. One of `SIGN`, `MA`, `EEMD`, `TREND`, or `SMT`.
#' @param cutoffs A numeric vector, with positional cutoffs for *Newey-West t-statitics* and \eqn{R^2}, see 'Details'.
#' @param speed A boolean, whether or not to compute the chosen momentum `signal` *speed*.
#'
#' @return
#' A list of `xts` objects, consisting of the chosen momentum `signal` for the
#' corresponding assets data `X` provided. Signals are {-1, 0, 1} for short,
#' inactive, and long positions, respectively. `TREND` and `SMT` are the only
#' signals that can result in inactive positions.
#' With `speed`, additionally the chosen *momentum speed* for the given assets.
#'
#' @details
#' Data strictly needed in `X` depends on the `signal` chosen. `SIGN` is based on
#' assets returns. `MA`, `EEMD`, `TREND`, and `SMT` are price-based momentum signals.
#'
#' For the `TREND`, Newey-West t-statitics lower and upper `cutoffs` can be provided.
#' With `SMT`, `cutoffs` can additionally provide the lower \eqn{R^2} cutoff.
#' Defaults are set at \eqn{-2}, \eqn{2} for NW t-statitics and a minimum \eqn{R^2}
#' of \eqn{0.65}.
#'
#' `SMT` over sub-periods is not currently supported.
#'
#' @references
#' Bryhn, A. C and Dimberg, P. H. (2011). *An operational definition of a statistically meaningful trend*. PLoS One.
#'
#' Moskowitz, T. J. and Ooi, Y. H. and Pedersen, L. H. (2012). *Time series momentum*. Journal of Financial Economics.
#'
#' Baltas, A. N. and Kosowski, R. (2012). *Improving time-series momentum strategies: The role of trading signals and volatility estimators*.
#' [EDHEC-Risk Institute](https://risk.edhec.edu/publications/improving-time-series-momentum-strategies-role-trading-signals-and-volatility).
#'
#' @seealso
#' [sandwich::NeweyWest()]
#'
#' @author
#' Vito Lestingi
#'
#' @importFrom lmtest coeftest
#' @importFrom sandwich NeweyWest
#' @importFrom stats lm
#' @importFrom xts is.xts xts
#' @importFrom zoo index rollmeanr rollsumr
#'
#' @export
#'
MomSignal <- function(X
                      , lookback
                      , signal
                      , cutoffs
                      , speed=FALSE)
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
    if (missing(cutoffs)) {
      # lower NW t-stat, upper NW t-stat, lower R^2
      cutoffs <- c(-2, 2, 0.65)
    }
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
      nwl <- cutoffs[1]
      nwu <- cutoffs[2]
      rsl <- cutoffs[3]
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
          nw.ts <- coeftest(mfit, vcov.=NeweyWest(mfit, prewhite=FALSE))
          nw.tstats[i, ] <- nw.ts[2, 't value']
        }
        if (cl$signal == 'TREND') {
          s[1:length(lind), ] <- nw.tstats
          s[nwl <= s & s <= nwu] <- 0L
          s[s < nwl] <- (-1L)
          s[s > nwu] <- 1L
        } else if (cl$signal == 'SMT') {
          tmp <- data.frame(s=s, nwts=nw.tstats, rsq=rsq)
          tmp <- within(tmp, {
            SMT[(nwl <= nwts & nwts <= nwu) | (0 <= rsq & rsq <= 1)] <- 0L
            SMT[nwts < nwl & rsq >= rsl] <- (-1L)
            SMT[nwts > nwu & rsq >= rsl] <- 1L
          })
          s <- tmp[, 'SMT', drop=FALSE]
        }
        return(xts(s, order.by=index(x)[lind]))
      })
    }
  )
  if (speed) {
    mom.speed <- lapply(mom.signal, function(x) {
      t <- (nrow(x) - lookback - 1)/(nrow(x) - lookback)
      # X.sq == 1 for SIGN, MA, EEMD
      X.sq <- sum(x^2)
      DX.sq <- sum(diff(x)^2, na.rm=TRUE)
      x.speed <- sqrt(t * X.sq / DX.sq)
      return(x.speed)
    })
    return(
      list(
        mom.signal=mom.signal,
        mom.speed=mom.speed
      )
    )
  }
  return(mom.signal)
}
