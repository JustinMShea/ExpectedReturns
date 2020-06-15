#' @section MKT.RF Factor:
#'
#' With `MKT.RF` we indicate the excess return on the market portfolio return proxy,
#' net of the risk-free rate \eqn{RF} calculated on the same period \eqn{t}, that is
#'
#' \deqn{MKT.RF = MKT - RF}
#'
#' or, as it is also commonly denoted in the literature,
#'
#' \deqn{MKT.RF = R_{m} - R_{f}}
#'
#' \eqn{MKT}, is obtained by Fama-French as the value-weight return of all CRSP
#' firms that are incorporated in the U.S. and listed on the NYSE, AMEX, or NASDAQ
#' securities markets. These firms must have a CRSP share code of 10 or 11, good
#' shares and price data, at the beginning of the period.
