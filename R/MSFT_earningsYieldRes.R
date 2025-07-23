#' @title Microsoft Earnings Yield Restated Data Set
#'
#' @docType data
#'
#' @description
#' 'MSFT_earningsYieldRes.RData' is data on earnings yield of Microsoft going back to 2009-07-28, It
#' based on restated data from Microsoft, which is the "true" value of this data, but it is not the data
#' that Microsoft released initially. For point in time values use MSFT_earningsYieldPIT.RData.
#'
#' @usage
#' data("MSFT_earningsYieldRes")
#'
#' @format
#' A `data.frame` object containing observations on return data for Microsoft.
#'
#' * __fq__: Earnings per share.
#' * __filed__: Quarterly frequency from 2090 to most recent parse.
#'
#' The object consists of 3995 rows and 1 columns.
#'
#' @source
#' quantkiosk
#'
#' @examples
#' data(MSFT_earningsYieldRes")
#'
#' head(MSFT_earningsYieldRes")
#'
"MSFT_earningsYieldRes"
