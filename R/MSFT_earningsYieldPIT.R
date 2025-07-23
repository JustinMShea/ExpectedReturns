#' @title Microsoft Earnings Per Share Restated Data Set
#'
#' @docType data
#'
#' @description
#' 'MSFT_epsRes' is data on earnings per share of Microsoft going back to 2011-07-28,
#' up to 2025-04-30*. This is the data that you'd see in fundamental analysis, it includes
#' restatements of financial documents by MSFT - this is the "true" value of this data,
#' but it is not the data that MSFT released initially. For point in time values use MSFT_epsPIT.
#'
#' *Can run MSFT_epsRes.R parser to obtain present day data. Needs library quantkiosk and API
#' key (free non-institutional version available online).
#'
#' @usage
#' data("MSFT_epsRes")
#'
#' @format
#' A `data.frame` object containing observations on return data for Microsoft.
#'
#' * __fq__: Earnings per share.
#' * __filed__: Quarterly frequency from 2011-07028 to 2025-04-30.
#'
#' The object consists of 63 rows and 2 columns.
#'
#' @source
#' quantkiosk
#'
#' @examples
#' data(MSFT_epsRes)
#'
#' head(MSFT_epsRes)
#'
"MSFT_epsRes"
