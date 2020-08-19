#' @title Fama-French-Carhart 4 Factors Data Set
#'
#' @docType data
#'
#' @description
#' `FF4.monthly` is the Fama-French-Carhart four-factor monthly data series on U.S.
#' stock market from 1927-01 to 2020-04. The data set also includes the risk-free
#' rate on 1-month U.S. T-Bill during the same period.
#'
#' @usage
#' data("FF4.monthly")
#'
#' @format
#' An `xts` object containing observations of Fama-French Factors on U.S. Stock
#' Market.
#'
#' * __Frequency__: Monthly.
#' * __Date Range__: 1927-01 to 2020-04.
#' * __Data updated__: 2020-08-19 20:52:33 CEST.
#' * __RF__: A numeric. The risk-free rate on 1-month U.S. T-Bill. See 'RF variable' section below.
#' * __MKT.RF__: A numeric. The market portfolio proxy return net of risk-free rate factor. See 'MKT.RF factor' section below.
#' * __SMB__: A numeric. The "Small Minus Big" factor. See 'SMB factor' section below.
#' * __HML__: A numeric. The "High Minus Low" factor. See 'HML factor' section below.
#' * __MOM__: A numeric. The "Momentum" (or Up Minus Down, UMD) factor. See 'MOM factor' section below.
#'
#' The object consists of 1120 rows and 5 columns.
#'
#' @details
#' In addition to column definitions, this section contains a glimpse into factors
#' construction and their underlying variables.
#'
#' @template construction-factor-ff3
#' @template variable-me
#' @template variable-be
#' @template variable-bm
#' @template portfolios-6-size-bm
#' @template variable-rf
#' @template factor-mktrf
#' @template factor-smb
#' @template factor-hml
#' @template factor-mom
#'
#' @template general-missing-data
#' @template general-data-providers
#' @template general-french-copyright
#'
#' @source
#' [Kenneth R. French's data library](http://mba.tuck.dartmouth.edu/pages/faculty/ken.french/data_library.html)
#'
#' @seealso
#' The series was generated with [ExpectedReturns::GetFactors()].
#'
#' @examples
#' data(FF4.monthly)
#'
#' head(FF4.monthly)
#'
"FF4.monthly"
