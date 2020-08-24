#' @section SMB factor:
#'
#' The `SMB` (*Small Minus Big*) factor Stambaugh-Yuan (2017) constructed differs
#' from the homonymous factor constructed by means of the standard Fama-French (1993, 2015)
#' methodology widely adopted.
#'
#' First of all, stocks used to form the size factor in a given month are the
#' stocks not used in forming either of the mispricing factors.
#'
#' Moreover, in Stambaugh-Yuan (2017) the return on the *small-cap leg* is
#' the value-weighted portfolio of stocks present in the intersection of both
#' small-cap middle groups when sorting on the \eqn{P1} and \eqn{P2} mispricing
#' composite measures. The *large-cap leg* is the value-weighted portfolio of stocks
#' in the intersection of the large-cap middle groups in the sorts on the two measures.
#' Thus the value of SMB in a given month is the return on the small-cap leg minus
#' the large-cap return.
#'
#' Computing SMB using stocks only from the middle of their mispricing sorts is
#' meant to reduce the "arbitrage asymmetry bias" while neutralizing mispricing
#' effects.
