#' @title Microsoft Price to Earnings Ratio
#'
#' @docType data
#'
#' @description
#' 'MSFT_pe' is data on Microsoft pe ratio from 2011-07-28 to 2025-06-25*. This data
#' is of very fine granularity, using direct from source SEC filing data.
#'
#' *Can run MSFT_pe.R parser to obtain present day data. Needs to run subsidiary MSFT.R and 
#' MSFT_eps.R parsers to run as well as libraries quantmod and quantkiosk with an API key (free 
#' non-institutional version available online). More information available in subsidiary documentations.
#'
#' @usage
#' data("MSFT_pe")
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
#' data(MSFT_pe)
#'
#' head(MSFT_pe)
#'
"MSFT_pe"
