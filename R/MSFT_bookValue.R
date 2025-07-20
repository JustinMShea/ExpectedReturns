#' @title Microsoft Book Value Data Set
#'
#' @docType data
#'
#' @description
#' 'MSFT_bookValue' is data on reported book value of Microsoft from 2011 to 2025*.
#'
#' *Can run MSFT_bookValue.R parser to obtain present day data. Needs library quantkiosk and API
#' key (free non-institutional version available online).
#'
#' @usage
#' data("MSFT_bookValue")
#'
#' @format
#' An `xts` object containing observations on return data for Microsoft.
#'
#' * BookValue: The book value at that point. In scientific notation. Ordered by date.
#'
#' The object consists of 57 rows and 1 columns.
#'
#' @source
#' quantkiosk
#'
#' @examples
#' data(MSFT_bookValue)
#'
#' head(MSFT_bookValue)
#'
"MSFT_bookValue"
