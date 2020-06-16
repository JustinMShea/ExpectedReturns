#' @title Helper Function for Factor Model Data Preprocessing
#'
#' @description
#' In data analyses and data mining, there are procedures regularly carried to
#' prepare the data sets for analyses. These procedures may be simply aimed at
#' carrying basic checks on data sets, or at applying preliminary analyses to
#' "modify" the initial data set (among which *data cleaning* is perhaps the
#' most known one).
#' This helper function aims to prepare factor model data for further analyses.
#'
#' ## Cross-sectional consistency (a.k.a "balanced panel")
#' TODO: crucial checks on cross-section consistency
#'
#' ## Data cleaning procedures
#' The function is implemented to carry several data cleaning procedures.
#' These procedures are often needed in empirical analyses because financial data
#' are tipically subject to outliers. Common statistical analyses tend to suffer
#' the effects of these extreme data points, in the sense that their output may
#' result unreliable.
#' Several methods, mostly in the realm of *robust statistics* are designed to detect
#' and alleviate the undue effects of such biases on the phenomena being analyzed.
#' Engle et al. (2016) illustrates commonly adopted techniques in empirical finance:
#'
#' * __Winsorization__
#' * __Truncation__
#'
#' These methods are summarized below to the extents of our implementation.
#' Additional information is provided to give some background and further guidance.
#'
#' ### Winsorization
#' This technique consists in setting "the values of a given variable that are
#' above or below a certain cutoff to that cutoff". The objective is clearly that
#' of dealing with "moderate" variables, to the extents the phenomena under investigation
#' is not being substancially altered.
#' The cutoff at which winsorization should be performed depends mainly on how
#' noisy is the variable being analyzed, more noisy variables tends to be winsorized
#' at a higher cutoff.
#'
#' ### Truncation
#' Similar to Winsorization, except that the values of a given variable that are
#' above or below a certain cutoff are removed altogether.
#'
#' ### Winsorization/Truncation levels
#' Winsorization and Truncation are usually conducted symmetrically, meaning that
#' both series ends levels are equal. However this needs not to be. It is possible
#' to carry the cleaning procedures at arbitrarily asymmetric levels, depending
#' on how noisy is financial data being analyzed. This a researchers' decision.
#'
#' ### Cross-sectional and time-indexed Winsorization/Truncation
#' There are two ways to perform either cleaning technique:
#'
#' * __Cross-sectionally__. Percentiles are based on all values of the given variables
#' cross-section.
#' * __Time-indexed__. Percentiles are computed based on each time period separately.
#'
#' Which to choose depends on the type of statistical analysis to be carried.
#' Engle et al. (2016) suggest that:
#' * if a single-stage analysis will be performed on the entire panel of data,
#' the first method is most appropriate;
#' * in two-stage analyses the second approach is usually preferable.
#'
#' They also suggest that if any of these choices is assessed to be substantially
#' influence analyses results, the methodology should be seen with suspicion.
#'
#' ### Winsorize or truncate?
#' Whether to use either one is a difficult question to answer in general as some
#' outliers are "legitimate" while others may be data errors.
#' Most empirical asset pricing researchers choose to use Winsorization instead
#' of truncation as it resembles more closely the robust approach to statistic
#' analyses. In other words, Winsorization preserves the number of observations
#' in the panel being analyzed and this is a good reason to prefer it.
#' It remains, however, a researchers' decision.
#'
#' @param data A `data.frame` specifying data on which the selected procedures are to be carried.
#' @param lrhs A character vector specifying the following columns of `data`: dates, all the independent variables, finally the independent variable (position matters).
#' @param clean.method A character string. One of `winsor` (default) or `trunc`.
#' @param clean.bounds A character vector indicating `clean.method` cutoffs.
#' @param across.panel A boolean. Would you like to clean `data` cross-sectionally or in a time-indexed fashion?
#' @param ... Additional pass through parameters.
#' TODO: param lagged A boolean.
#'
#' @return
#' A `data.frame` with values on which the selected procedures have been applied.
#'
#' @details
#'
#' @references
#' Bali, T.G., Engle, R.F., and Murray, S. (2016). *Empirical Asset Pricing. The Cross Section of Stock Returns*. Wiley.
#'
#' @author Vito Lestingi
#'
#' @examples
#'
#' @export
#'
SetFactorModel <- function(data
                           , lrhs
                           , clean.method
                           , clean.bounds
                           , across.panel
                           # , lagged
                           , ...)
{
  clean.methods.available <- c('winsor', 'trunc') # TODO: PerformanceAnalytics::clean.boudt()?
  if(all(clean.method != clean.methods.available)) {
    stop("clean.method = ", sQuote(clean.method), " is not currently implemented.")
  }
  data.names <- colnames(data)

  # TODO: is data data.frame or xts?
  # Assuming a data.frame only at the moment

  # TODO: is data balanced panel?
  # to do so need to introduce indexes, something similar to what I did in vignettes snippets

  # Periods (first col) and Independent variables
  nrhsp <- length(lrhs) - 1
  X <- data[, lrhs[1:nrhsp]]
  # Dependent variable (last col)
  y <- data[, lrhs[nrhsp]]
  # Remaining variables
  R <- data[, setdiff(data.names, lrhs)]

  if(missing(clean.method)) clean.method <- 'winsor'
  if(missing(across.panel)) across.panel <- TRUE
  if(missing(clean.bounds)) clean.bounds <- c('0.5%', '99.5%')
  win.trunc <- function(X, clean.method=clean.method) {
    Xr <- nrow(X)
    Xc <- ncol(X)
    X.perc <- apply(X, 2, quantile, probs=seq(0, 1, 0.005), na.rm=TRUE, ...)
    lp <- X.perc[clean.bounds[1], ]
    hp <- X.perc[clean.bounds[2], ]
    LP <- matrix(rep(lp, Xr), Xr, byrow=TRUE) # TODO: may want to winsorize dependent variable too
    HP <- matrix(rep(hp, Xr), Xr, byrow=TRUE)
    if (clean.method == 'winsor') {
      X[X < LP] <- LP[X < LP]
      X[X > HP] <- HP[X > HP]
    } else if (clean.method == 'trunc') {
      X[X < LP] <- NA
      X[X > HP] <- NA
    }
    X
  }
  if ((clean.method == 'winsor' | clean.method == 'trunc') & across.panel) {
    # Winsorize/Truncate cross-sectionally
    dates <- X[, 1]
    X <- X[, 2:nrhsp]
    X <- win.trunc(X)
    X <- cbind(dates, X)
  } else if ((clean.method == 'winsor' | clean.method == 'trunc') & !across.panel) {
    # Winsorize/Truncate by time period
    # WARNING: would fail when single observation
    utp <- unique(X[, 1])
    for (t in 1:length(utp)) {
      tX <- X[which(X[, 1] == utp[t]), ]
      tX <- win.trunc(tX)
      X[which(X[, 1] == utp[t]), ] <- tX
    }
  } else {
    stop(gettext(
      "clean.method = %s is not currently implemented. Use one of %s.",
      clean.method, clean.methods.available)
    )
  }
  if(missing(lagged)) lagged <- FALSE
  if (!lagged) {
    # TODO
  }
  data <- cbind(X, y, R)
  colnames(data) <- data.names
  data <- data[, data.names]
  return(data)
}
