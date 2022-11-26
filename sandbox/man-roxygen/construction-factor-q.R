#' @section Q-Factors construction:
#'
#' Authors construct their size, investment, and Roe factors from independent,
#' triple \eqn{2x3x3} portfolio sorts on size, investment-to-assets (I/A), and Roe.
#'
#' Taking the intersection of the two size, three I/A, and three Roe groups, they
#' form eighteen portfolios. Monthly value-weighted portfolio returns are calculated
#' for the current month, and the portfolios are rebalanced monthly.
