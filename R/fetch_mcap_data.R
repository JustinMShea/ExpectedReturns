#' Fetch Market Cap Data for a Set of Tickers - helper function to factor_framework
#'
#' Retrieves historical price data for a list of stock tickers using
#' `quantmod::getSymbols`, handles common errors or symbol quirks, and
#' computes period-to-period returns based on the user-specified
#' frequency (daily, weekly, or monthly). Tickers that error/warn are captured.
#'
#' @param tickers type character. Vector of tickers.
#' @param frequency type character string. Set to "daily". Frequency of data to fetch: "daily", "weekly", or "monthly".
#' @param from Date or character "YYYY-MM-DD". Start date (inclusive). Default: NULL (Yahoo’s earliest).
#' @param to Date or character "YYYY-MM-DD". End date (inclusive). Default: Sys.Date().
#'
#' @return list with:
#'   \item{data}{long data.frame: ticker, date, price, return (log).}
#'   \item{failed}{character vector of tickers that failed.}
#'   \item{warned}{character vector of tickers that warned.}
#'
#' @details
#' This function replaces slashes in ticker names (e.g., "BRK/B") with
#' dashes to match Yahoo Finance's format. Return calculation is done using
#' the natural log difference of adjusted close prices. Frequency
#' conversion uses `to.weekly()` and `to.monthly()` from the
#' \code{quantmod} package. First return per series is NA.
#'
#' @examples
#' fetch_price_data(c("MSFT", "AAPL"), freq = "monthly")
#'
#' @export

library(quantmod)
library(zoo)
library(xts)