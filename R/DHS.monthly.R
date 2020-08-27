#' @title Daniel-Hirshleifer-Sun Three-Factors Data Set
#'
#' @docType data
#'
#' @description
#' `DHS3.monthly` is the Daniel-Hirshleifer-Sun (2020) three-factors monthly data
#' series on U.S. stock market from 1972-07 to 2018-12.
#'
#' @usage
#' data("DHS3.monthly")
#'
#' @format
#' An `xts` object containing observations of Daniel-Hirshleifer-Sun (2020)
#' three-factors data set on the U.S. Stock Market.
#'
#' * __Frequency__: Monthly.
#' * __Date Range__: 1972-07 to 2018-12.
#' * __Data updated__: 2020-08-25 20:48:48 CEST.
#' * __RF__: A numeric. The risk-free rate on 1-month U.S. T-Bill. See 'RF variable' section below.
#' * __MKT.RF__: A numeric. The market portfolio proxy return net of risk-free rate factor. See 'MKT.RF factor' section below.
#' * __PEAD__: A numeric. The _post-earnings announcement drift_ behavioral mispricing factor. See 'PEAD factor' section below.
#' * __FIN__: A numeric. The _financing_ behavioral mispricing factor. See 'FIN factor' section below.
#'
#' The object consists of 558 rows and 2 columns.
#'
#' @details
#' In addition to column definitions, this section contains a glimpse into factors
#' construction and their underlying variables.
#'
#' @template construction-factor-dhs
#' @template variable-rf
#' @template factor-mktrf
#' @template factor-pead
#' @template factor-fin
#'
#' @references
#' Daniel, K. and Hirshleifer, D. and Sun, L. (2020). *Short-and long-horizon behavioral factors*. The Review of Financial Studies.
#'
#' @source
#' <http://www.kentdaniel.net/data/DHS_factors.xlsx>
#'
#' @examples
#' data(DHS3.monthly)
#'
#' head(DHS3.monthly)
#'
"DHS3.monthly"
