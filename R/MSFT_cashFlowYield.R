#' @title Cash Flow Yield Data Set
#'
#' @docType data
#'
#' @description
#' 'MSFT_cashFlowYield' is data on Microsoft cash flow yield from 2011-07-28 to 2025-06-25*. This data
#' is of very fine granularity, using direct from source SEC filing data.
#'
#' *Can run MSFT_cashFlowYield.R parser to obtain present day data. More information available in subsidiary documentations.
#'
#' @usage
#' data("MSFT_cashFlowYield")
#'
#' @format
#' An `xts` object containing observations on return data for Microsoft.
#'
#' * __Frequency__: Daily.
#' * __CashFlow__: Cash flow to market cap of Microsoft on that day.
#'
#' The object consists of 3503 rows and 1 columns.
#'
#' @source
#' quantkiosk, quantmod
#'
#' @examples
#' data(MSFT_cashFlowYield)
#'
#' head(MSFT_cashFlowYield)
#'
"MSFT_cashFlowYield"
