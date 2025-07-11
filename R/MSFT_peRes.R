#' @title Microsoft Price to Earnings Ratio.
#' @docType data
#'
#' @description
#' 'MSFT_peRes' is data on Microsoft pe ratio from 2011-07-28 to 2025-06-25*. This data
#' is of very fine granularity, using direct from source SEC filing data. It does not ignores 
#' restated EPS and uses "true" value of EPS that MSFT revised after initial release. For 
#' restated EPS use MSFT_pePIT.
#'
#' *Can run MSFT_peRes.R parser to obtain present day data. Needs to run subsidiary MSFT.R and 
#' MSFT_epsRes.R parsers to run as well as libraries quantmod and quantkiosk with an API key (free 
#' non-institutional version available online). More information available in subsidiary documentations.
#'
#' @usage
#' data("MSFT_peRes")
#'
#' @format
#' An `xts` object containing observations on return data for Microsoft.
#'
#' * __Frequency__: Daily.
#' * __PEratio__: Price to Earnings of Microsoft on that day.
#'
#' The object consists of 3977 rows and 1 columns.
#'
#' @source
#' quantkiosk, quantmod
#'
#' @examples
#' data(MSFT_peRes)
#'
#' head(MSFT_peRes)
#'
"MSFT_peRes"
