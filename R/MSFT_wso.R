#' @title Microsoft Weighted Shares Outstanding Data Set
#'
#' @docType data
#'
#' @description
#' 'MSFT' is open, high, low, close, volume, and adjusted data for Microsoft stock dating from
#' the start of 2007 to 2025-06-25*
#'
#' *Can run MSFT.R parser to obtain present day data. Needs library quantmod.
#'
#' @usage
#' data("MSFT")
#'
#' @format
#' An `xts` object containing observations on return data for Microsoft.
#'
#' * __Frequency__: Daily.
#' * __Date Range__: 2007-01-03 to 2025-06-25.
#' * __Data updated__: 2025-06-25 14:58 CDT.
#' * __MSFT.Open__: A numeric. Opening Daily Price for MSFT.
#' * __MSFT.High__: A numeric. High daily price for MSFT.
#' * __MSFT.Low__: A numeric. Low daily price for MSFT.
#' * __MSFT.Close__: A numeric. The daily close of MSFT.
#' * __MSFT.Volume__: A numeric. The daily volume of MSFT stock traded.
#' * __MSFT.Adjusted__: A numeric. Contains adjusted closing prices.
#'
#' The object consists of 4649 rows and 6 columns.
#'
#' @source
#' quantmod & Yahoo Finance
#'
#' @examples
#' data(MSFT)
#'
#' head(MSFT)
#'
"MSFT"
