#' @section Stambaugh-Yuan (2017) Factors Construction:
#'
#' Stambaugh-Yuan (2017) consider 11 anomalies. Anomalies form two clusters:
#' * _First cluster_: net stock issues, composite equity issues, accruals,
#' net operating assets, asset growth, and investment to assets.
#' * _Second cluster_: distress, O-score, momentum, gross profitability, and
#' return on assets.
#'
#' Authors construct factors based on equally-weighted averages of stocks' anomaly
#' rankings, in the perspective of having a less noisy mispricing measure for each
#' stock across anomalies. In particular, stock's rankings are averaged with respect
#' to the available anomaly measures within each of the two clusters. Thus, each
#' month a stock has two composite mispricing measures, \eqn{P1} and \eqn{P2}.
#'
#' *Mispricing factors* are then constructed by applying a \eqn{2x3} sorting procedure,
#' similarly to Fama-French (2015):
#' * First, NYSE, AMEX, and NASDAQ stocks (excluding the ones with a price lower
#' than 5$) are sorted and split into two groups based on the NYSE median size breakpoint;
#' * Second, stock's are sorted by both \eqn{P1} and \eqn{P2} independently, and
#' assigned to three groups ("low", "middle", and "high") with the 20th and 80th
#' percentiles of the NYSE/AMEX/NASDAQ as breakpoints (rather than the commonly
#' used 30th and 70th percentiles of the NYSE). The motivation authors provide
#' for this methodological choice on breakpoints is that relative mispricing in
#' the cross-section is considered to be "more a property of the extremes than
#' of the middle".
#' * Finally, value-weighted returns of each of the four portfolios formed by the
#' intersection of the two size categories with high and low categories of either
#' \eqn{P1} or \eqn{P2} sorts are averaged and constitute their two mispricing
#' factors, *MGMT* and *PERF*, respectively.
