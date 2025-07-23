#' @title Microsoft Market Lquidity Data Set
#'
#' @docType data
#'
#' @description
#' 'MSFT_liquidity' is data on Microsoft market liquidity from 2007-07-28 to 2025-06-25*.
#'
#' *Can run MSFT_Liquidity.R parser to obtain present day data. 
#' 
#' @usage
#' data("MSFT_liquidity")
#'
#' @format
#' An `xts` object containing observations on return data for Microsoft.
#'
#' * __Frequency__: Daily from 2007 to last parsed date.
#' * __Liquidity__: Liquidity of Microsoft on that day.
#'
#' The object consists of 4667 rows and 1 columns.
#'
#' @source
#' quantmod
#'
#' @examples
#' data(MSFT_liquidity)
#'
#' head(MSFT_liquidity)
#'
"MSFT_liquidity"
