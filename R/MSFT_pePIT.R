#' @title Microsoft Price to Earnings Ratio Point in Time
#'
#' @docType data
#'
#' @description
#' 'MSFT_pePIT' is data on Microsoft pe ratio from 2011-07-28 to 2025-06-25*. This data
#' is of very fine granularity, using direct from source SEC filing data. It uses point in time data,
#' so it ignores restated EPS and uses the first available release of EPS in financial statements. For 
#' restated EPS use MSFT_peRes.
#'
#' *Can run MSFT_pePIT.R parser to obtain present day data. Needs to run subsidiary MSFT.R and 
#' MSFT_eps.R parsers to run as well as libraries quantmod and quantkiosk with an API key (free 
#' non-institutional version available online). More information available in subsidiary documentations.
#'
#' @usage
#' data("MSFT_pePIT")
#'
#' @format
#' An `xts` object containing observations on return data for Microsoft.
#'
#' * __Frequency__: Daily.
#' * __PEratio__: Price to Earnings of Microsoft on that day.
#'
#' The object consists of 3510 rows and 1 columns.
#'
#' @source
#' quantkiosk, quantmod
#'
#' @examples
#' data(MSFT_pePIT)
#'
#' head(MSFT_pePIT)
#'
"MSFT_pePIT"
