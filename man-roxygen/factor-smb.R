#' @section SMB Factor:
#'
#' The `SMB` (*Small Minus Big*) factor return variable is the average return on
#' three (nine) small portfolios minus the average return on three (nine) big portfolios.
#' Where the number (three or nine) and type (small or big) of portfolios in factors
#' construction depends on whether the model being considered is the *Fama-French's Three-factor model*
#' or the *Fama-French's Five-factor model*, respectively.
#' In formulas, for the Three-factor model we express the SMB factor as
#'
#' \deqn{SMB = \frac{1}{3}[(Small Value + Small Neutral + Small Growth) - (Big Value + Big Neutral + Big Growth)]}
#'
#' For the Five-factor model the process is analogous, except that in this case
#' an SMB factor has to be built for each one of the three sets of portfolios based
#' on specific firms' financial fundamentals. Once that is accomplished, their
#' weighted average is taken. We thus obtain
#'
#' \deqn{SMB = \frac{1}{3}[SMB_{(B/M)} + SMB_{(OP)} + SMB_{(INV)}]}
#'
