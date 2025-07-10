#' @title Microsoft Earnings Per Share Data Set
#'
#' @docType data
#'
#' @description
#' 'MSFT_eps' is data on earnings per share of Microsoft going back to 2011-07-28,
#' up to 2025-04-30*
#'
#' *Can run MSFT_wso.R parser to obtain present day data. Needs library quantkiosk and API
#' key (free non-institutional version available online).
#'
#' @usage
#' data("MSFT_eps")
#'
#' @format
#' A `data.frame` object containing observations on return data for Microsoft.
#'
#' * __fq__: Earnings per share at that point.
#' * __filed__: Quarterly frequency from 2011-07028 to 2025-04-30.
#'
#' The object consists of 60 rows and 2 columns.
#'
#' @source
#' quantkiosk
#'
#' @examples
#' data(MSFT_eps)
#'
#' head(MSFT_eps)
#'
"MSFT_eps"
