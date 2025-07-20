#' @title Microsoft Price to Book Ratio
#'
#' @docType data
#'
#' @description
#' 'MSFT_pbRatio' is data on Microsoft pb ratio from 2011-07-28 to 2025-06-25*. This data
#' is of very fine granularity, using direct from source SEC filing data.
#'
#' *Can run MSFT_pbRatio.R parser to obtain present day data. Needs to run subsidiary MSFT.R and 
#' MSFT_bookValue.R parsers to run as well as libraries quantmod and quantkiosk with an API key (free 
#' non-institutional version available online). More information available in subsidiary documentations.
#'
#' @usage
#' data("MSFT_pbRatio")
#'
#' @format
#' An `xts` object containing observations on return data for Microsoft.
#'
#' * __Frequency__: Daily.
#' * __PBratio__: Market cap to book value of Microsoft on that day.
#'
#' The object consists of 3503 rows and 1 columns.
#'
#' @source
#' quantkiosk, quantmod
#'
#' @examples
#' data(MSFT_pbRatio)
#'
#' head(MSFT_pbRatio)
#'
"MSFT_pbRatio"
