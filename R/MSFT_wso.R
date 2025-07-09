#' @title Microsoft Weighted Shares Outstanding Data Set
#'
#' @docType data
#'
#' @description
#' 'MSFT_wso' is data on weighted shares outstanding of Microsoft going back to 2011-07-28,
#' up to 2025-04-30*
#'
#' *Can run MSFT_wso.R parser to obtain present day data. Needs library quantkiosk and API
#' key (free non-institutional version available online).
#'
#' @usage
#' data("MSFT_wso")
#'
#' @format
#' A `data.frame` object containing observations on return data for Microsoft.
#'
#' * __fq__: Amount of weighted shares outstanding at that point. In scientific notation.
#' * __filed__: Quarterly frequency from 2011-07028 to 2025-04-30.
#'
#' The object consists of 61 rows and 2 columns.
#'
#' @source
#' quantkiosk
#'
#' @examples
#' data(MSFT_wso)
#'
#' head(MSFT_wso)
#'
"MSFT_wso"
