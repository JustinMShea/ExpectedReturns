#' @title Stambaugh–Yuan Four-Factors Data Set
#'
#' @docType data
#'
#' @description
#' `SY4.monthly` is the Stambaugh–Yuan (2017) four-factors monthly data series on
#' U.S. stock market from 1963-01 to 2016-12. The data set also includes the risk-free
#' rate on 1-month U.S. T-Bill during the same period.
#'
#' @usage
#' data("SY4.monthly")
#'
#' @format
#' An `xts` object containing observations of Stambaugh–Yuan (2017) four-factors
#' data set on U.S. Stock Market, and the risk-free rate on 1-month U.S. T-Bill.
#'
#' * __Frequency__: Monthly.
#' * __Date Range__: 1963-01 to 2016-12.
#' * __Data updated__: 2020-08-24 23:13:55 CEST.
#' * __RF__: A numeric. The risk-free rate on 1-month U.S. T-Bill. See 'RF variable' section below.
#' * __MKT.RF__: A numeric. The market portfolio proxy return net of risk-free rate factor. See 'MKT.RF factor' section below.
#' * __SMB__: A numeric. The "Small Minus Big" size factor. See 'SMB factor' section below.
#' * __MGMT__: A numeric. The investment factor. See 'MGMT factor' section below.
#' * __PERF__: A numeric. The profitability factor. See 'PERF factor' section below.
#'
#' The object consists of 648 rows and 5 columns.
#'
#' @details
#' In addition to column definitions, this section contains a glimpse into factors
#' construction and their underlying variables.
#'
#' @template construction-factor-sy
#' @template variable-rf
#' @template factor-mktrf
#' @template factor-smb-sy
#' @template factor-mgmt
#' @template factor-perf
#'
#' @references
#' Fama, Eugene F and French, Kenneth R (1993). *Common risk factors in the returns on stocks and bonds*. Journal of Financial Economics.
#'
#' Fama, Eugene F and French, Kenneth R (2015). *A five-factor asset pricing model*. Journal of Financial Economics.
#'
#' Stambaugh, R. F. and Yuan, Y. (2017). *Mispricing Factors*. The Review of Financial Studies.
#'
#' @source
#' <http://finance.wharton.upenn.edu/~stambaug/M4.csv>
#'
#' @examples
#' data(SY4.monthly)
#'
#' head(SY4.monthly)
#'
"SY4.monthly"
