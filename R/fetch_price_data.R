#' Fetch Price Data for a Set of Tickers - helper function to factor_framework
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

fetch_price_data <- function(tickers, frequency = "daily") {
  if (!frequency %in% c("daily", "weekly", "monthly")) {
    stop("Frequency must be 'daily', 'weekly', or 'monthly'")
  }

  all_data <- list()
  failed_tickers <- c()
  warning_tickers <- c()

  for (ticker in tickers) {
    yahoo_ticker <- gsub("/", "-", ticker)  # for issues with symbol like BRK/B

    try_result <- tryCatch({ # use try catch so if one ticker doesn't work it doesn't mess up the whole loop, try_result will be TRUE when ticker data can be fetched, and FALSE when it cannot - which is put into failed tickers
      data <- quantmod::getSymbols(Symbols = yahoo_ticker,
                         src = "yahoo",
                         auto.assign = FALSE)
      adjusted <- quantmod::Ad(data) # quantmod function to get adjusted close prices

      # adjust frequency
      adjusted <- switch(frequency,
                         "daily" = adjusted,
                         "weekly" = quantmod::to.weekly(adjusted)[, 4],  # end period adjusted closes
                         "monthly" = quantmod::to.monthly(adjusted)[, 4])
      # so, interestingly, the to.weekly and to.monthly functions return OHLCs using only the data it's given, which is only the adj close
      # prices for the ticker, so the OHLC for the weekly/monthly may (will) miss the true opens, highs, and lows within the period,
      # but that isn't a problem for us because we only use the adjusted close price, which is the true one, so we don't care about the
      # OHL, only the C.

      # calc log returns
      adj_vals <- zoo::coredata(adjusted) # coredata to extract numeric values from quantmod xts object
      log_ret <- c(NA, diff(log(adj_vals))) # pads the first value in the series as NA b/c you can't get a return for t = 0.

      df <- data.frame(
        ticker = ticker,
        date = as.Date(index(adjusted)),
        price = as.numeric(adj_vals),
        return = log_ret
      )

      all_data[[ticker]] <- df # tucks the specific ticker's data into the list, keyed by it's ticker
      TRUE # returns TRUE to the tryCatch block to indicate success
    }, warning = function(w) {
      warning_tickers <<- c(warning_tickers, ticker)
      FALSE
    }, error = function(e) {
      failed_tickers <<- c(failed_tickers, ticker)
      FALSE
    })
  }

  combined_data <- do.call(rbind, all_data)
  rownames(combined_data) <- NULL

  return(list(
    data = combined_data,
    failed = failed_tickers,
    warned = warning_tickers
  ))
}
