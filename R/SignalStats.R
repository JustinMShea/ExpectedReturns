#' @title Compute Trading Signals Statistics
#'
#' @description
#' Trading signals can be further analyzed with several statistics, across instruments.
#' Signal statistics currently implemented include:
#' * **Activity matrix** (`method="activity"`).
#' Represents the number of long or short positions over the periods considered.
#' It is expressed in percentage units.
#' * **Correlation matrix** (`method="cor"`).
#' The average correlation among signals and across instruments.
#'
#' @note
#' Some signals may result into an inactive position. Such positions are not considered
#' in the activity matrix and thus values do not sum up to unity. Whereas, they
#' are accounted for in the agreement matrix.
#'
#' @param X A list of `xts` objects storing signals series. See 'Details'.
#' @param symbols A character vector providing the names of symbols signals were computed for.
#' @param signals A character vector specifying the names of signals provided in `X`.
#' @param method A string indicating which stats to compute for `X` signals.
#' @param ... Any other pass through parameter.
#'
#' @references
#' Baltas, A. N. and Kosowski, R. (2012). *Improving time-series momentum strategies: The role of trading signals and volatility estimators*.
#' [EDHEC-Risk Institute](https://risk.edhec.edu/publications/improving-time-series-momentum-strategies-role-trading-signals-and-volatility).
#'
#' @author
#' Vito Lestingi
#'
#' @seealso
#' [ExpectedReturns::MomSignal()]
#'
#' @importFrom stats complete.cases cor na.omit
#' @importFrom xts xts
#' @importFrom zoo index
#'
#' @export
#'
SignalStats <- function(X
                        , symbols
                        , signals
                        , method
                        , ...)
{
  methods.avail <- c('activity', 'cor')
  method <- match.arg(method, methods.avail)
  switch (method,
    activity = {
      out <- lapply(X, function(x) {
        x.inst <- Reduce(cbind, x)
        lsp <- apply(x.inst, 2, function(j) {
          nlong <- length(which(j == 1))
          nshort <- length(which(j == (-1)))
          los <- rbind(nlong, nshort)
          y <- los / NROW(na.omit(j)) * 100
          return(y)
        })
        lsp <- t(lsp)
        rownames(lsp) <- symbols
        colnames(lsp) <- c('Long', 'Short')
        return(lsp)
      })
      names(out) <- signals
    },
    cor = {
      sig.avg.inst <- lapply(X, function(x) {
        x.inst <- Reduce(cbind, x)
        x.inst.avg <- xts(rowMeans(x.inst, na.rm=TRUE), index(x.inst))
        return(x.inst.avg)
      })
      sig.avg <- Reduce(cbind, sig.avg.inst)
      sig.avg <- sig.avg[complete.cases(sig.avg), ]
      colnames(sig.avg) <- signals
      out <- cor(sig.avg, ...)
    }
  )
  return(out)
}
