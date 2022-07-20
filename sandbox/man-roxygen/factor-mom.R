#' @section MOM factor:
#'
#' The `MOM` (*Momentum*) factor return variable is the average return on the two
#' high prior return portfolios minus the average return on the two low prior return
#' portfolios, that is
#'
#' \deqn{MOM = \frac{1}{2}[(Small High + Big High) - (Small Low + Big Low)]}
#'
#' To construct the \eqn{MOM} factor, Fama-French use six value-weight portfolios
#' formed on size and prior (2-12) returns. The portfolios are formed monthly.
#'
#' For the U.S., the monthly size breakpoint is the median NYSE market equity while
#' the monthly prior (2-12) return breakpoints are the 30th and 70th NYSE percentiles.
#' Stocks included are those traded on NYSE, AMEX, and NASDAQ, for which prior
#' return data is available.
