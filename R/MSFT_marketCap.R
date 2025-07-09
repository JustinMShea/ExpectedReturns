#' @title Microsoft Market Capitlization
#'
#' @docType data
#'
#' @description
#' 'MSFT_marketCap' is data on Microsoft market capitlization from 2011-07-28 to 2025-06-25*. This data
#' is of very fine granularity, using direct from source SEC filing data.
#'
#' *Can run MSFT_marketCap.R parser to obtain present day data. Needs to run subsidiary MSFT.R and 
#' MSFT_wso.R parsers to run as well as libraries quantmod and quantkiosk with an API key (free 
#' non-institutional version available online). More information available in subsidiary documentations.
#'
#' @usage
#' data("MSFT_marketCap")
#'
#' @format
#' An `xts` object containing observations on return data for Microsoft.
#'
#' * __Frequency__: Daily.
#' * __MarketCap__: Market Capitlization of Microsoft on that day.
#'
#' The object consists of 3503 rows and 1 columns.
#'
#' @source
#' quantkiosk, quantmod
#'
#' @examples
#' data(MSFT_marketCap)
#'
#' head(MSFT_marketCap)
#'
"MSFT_marketCap"
