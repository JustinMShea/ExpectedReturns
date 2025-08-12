#' Fetch Weighted Shares Outstanding Data for a Set of Tickers - helper function to factor_framework
#'
#' Retrieves weighted shares outstanding data for a list of stock tickers
#' using quantkiosk, and handles common errors or symbol quirks based
#' on the user-specified frequency (daily, weekly, or monthly). Tickers that error/warn are captured
#'
#' @param tickers type character. Vector of tickers.
#' @param frequency type character string. Set to "daily". Frequency of data to fetch: "daily", "weekly", or "monthly".
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