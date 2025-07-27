#' @title Microsoft Simple 12mo Momentum Data Set
#'
#' @docType data
#'
#' @description
#' 'MSFT_momentumSimp' is data on two-point price momentum of Microsoft from 2008 to 2025*.
#'
#' *Can run MSFT_momentumSimp.R parser to obtain present day data. Needs rerun "MSFT.R" parser first to obtain price data,
#' which uses quantmod automatically.
#'
#' Currently, 'ExpectedReturns' contains documentation on a more fleshed out momentum function, but there is no parser for it.
#' For the time being this simple parser and data combination will be used to provide a simple momentum data puzzle piece for a
#' comprehensive package of factors using immediate data.
#'
#' In the future this factor should be fleshed out and combined with 'MomSignal.R' to provide a more comprehensive momentum factor.
#'
#' @usage
#' data("MSFT_momentumSimp")
#'
#' @format
#' An `xts` object containing observations on return data for Microsoft.
#'
#' * momentum12mo: The 12-month price momentum for Microsoft (MSFT), calculated as the return from 12 months ago to 1 month ago. Ordered by date.
#'
#' The object consists of 4415 rows and 1 columns.
#'
#' @source
#' quantmod
#'
#' @examples
#' data(MSFT_momentumSimp)
#'
#' head(MSFT_momentumSimp)
#'
"MSFT_momentumSimp"
