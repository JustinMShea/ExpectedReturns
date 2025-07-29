#' @title Microsoft 1mo Rolling Volatility Data Set
#'
#' @docType data
#'
#' @description
#' 'MSFT_volatility' is data on 21 day price volatility measure of Microsoft from 2007 to 2025*.
#'
#' *Can run MSFT_volatility.R parser to obtain present day data. Needs rerun "MSFT.R" parser first to obtain price data,
#' which uses quantmod automatically.
#'
#' @usage
#' data("MSFT_volatility")
#'
#' @format
#' An `xts` object containing observations on return data for Microsoft.
#'
#' * MSFT_volatility: The 1-month rolling volatility for Microsoft (MSFT), calculated as the standard deviation of daily returns over a 21-day window. Ordered by date.
#'
#' The object consists of 4667 rows and 1 columns.
#'
#' @source
#' quantmod
#'
#' @examples
#' data(MSFT_volatility)
#'
#' head(MSFT_volatility)
#'
"MSFT_volatility"
