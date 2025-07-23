#' @title Microsoft Earnings Yield Point in Time Data Set
#'
#' @docType data
#'
#' @description
#' 'MSFT_earningsYieldPIT.RData' is data on earnings yield of Microsoft going back to 2009-07-28, It
#' based on point in time data from Microsoft, which is the data that Microsoft released initially.
#' For restated values use MSFT_earningsYieldRes.RData.
#' 
#' @usage
#' data("MSFT_earningsYieldPIT")
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
#' data("MSFT_earningsYieldPIT")
#'
#' head("MSFT_earningsYieldPIT")
#'
"MSFT_earningsYieldPIT"
