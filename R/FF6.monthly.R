#' @title Fama-French 6 Factors Data Set
#'
#' @docType data
#'
#' @description
#' `FF6.monthly` is the Fama-French six-factor monthly data series on U.S. stock
#' market from 1963-07 to 2020-04. The data set also includes the risk-free rate
#' on 1-month U.S. T-Bill during the same period.
#'
#' @usage
#' data("FF6.monthly")
#'
#' @format
#' An `xts` object containing observations of Fama-French Factors on U.S. Stock
#' Market.
#'
#' * __Frequency__: Monthly.
#' * __Date Range__: 1963-07 to 2020-04.
#' * __Data updated__: 2020-08-19 22:32:59 CEST.
#' * __RF__: A numeric. The risk-free rate on 1-month U.S. T-Bill. See 'RF variable' section below.
#' * __MKT.RF__: A numeric. The market portfolio proxy return net of risk-free rate factor. See 'MKT.RF factor' section below.
#' * __SMB__: A numeric. The "Small Minus Big" factor. See 'SMB factor' section below.
#' * __HML__: A numeric. The "High Minus Low" factor. See 'HML factor' section below.
#' * __RMW__: A numeric. The "Robust Minus Weak" factor. See 'RMW factor' section below.
#' * __CMA__: A numeric. The "Conservative Minus Aggressive" factor. See 'CMA factor' section below.
#' * __MOM__: A numeric. The "Momentum" (or Up Minus Down, UMD) factor. See 'MOM factor' section below.
#'
#' The object consists of 682 rows and 7 columns.
#'
#' @details
#' In addition to column definitions, this section contains a glimpse into factors
#' construction and their underlying variables.
#'
#' @template construction-factor-ff5
#' @template variable-me
#' @template variable-be
#' @template variable-bm
#' @template portfolios-6-size-bm
#' @template variable-op
#' @template portfolios-6-size-op
#' @template variable-inv
#' @template portfolios-6-size-inv
#' @template variable-rf
#' @template factor-mktrf
#' @template factor-smb
#' @template factor-hml
#' @template factor-rmw
#' @template factor-cma
#' @template factor-mom
#'
#' @template general-missing-data
#' @template general-data-providers
#' @template general-french-copyright
#'
#' @references
#' Fama, E. F. and French, K. R. (2018). *Choosing factors*. Journal of Financial Economics.
#'
#' @source
#' [Kenneth R. French's data library](http://mba.tuck.dartmouth.edu/pages/faculty/ken.french/data_library.html)
#' [K. R. French's Variables Definitions](http://mba.tuck.dartmouth.edu/pages/faculty/ken.french/Data_Library/variable_definitions.html)
#'
#' @seealso
#' The series was generated with [ExpectedReturns::GetFactors()].
#'
#' @examples
#' data(FF6.monthly)
#'
#' head(FF6.monthly)
#'
"FF6.monthly"
