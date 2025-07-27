#' Cash Flow Yield Function
#'
#'
#' @param cashFlow type double. Vector of cash flow values.
#' @param marketCap type double. Vector of market cap values.
#'
#' @returns
#'
#' @examples
#' # Load required qk library
#' library(qkiosk)
#' library(xts)
#'
#' # May need to add qk API key into environment variables for data to be fetched.
#' # Free keys available online.
#'
#' # Get qk net income data. Convert to dataframe.                           # in the future when qkisok has depreciation data, include it in calcs
#' MSFT_cashFlowPrice <- as.data.frame(qk_fn(qk_ticker("MSFT"), "NI")[])
#'
#' # Check if data isnt empty
#' if (nrow(MSFT_cashFlowPrice) == 0) {
#'   stop("No data returned from qk_fn for MSFT cash flow price.")
#' }
#'
#' MSFT_cashFlowPrice <- na.omit(MSFT_cashFlowPrice[, c("fq", "fpe")])
#' MSFT_cashFlowPrice$fpe <- as.Date(as.character(MSFT_cashFlowPrice$fpe), "%Y%m%d")
#'
#' # convert to xts object
#' MSFT_cashFlowPrice <- xts(MSFT_cashFlowPrice$fq, order.by = MSFT_cashFlowPrice$fpe)
#'
#' # Load market cap data
#' load("data/MSFT_marketCap.RData")
#'
#' # Merge net income and market cap data by data
# 'MSFT_cashFlowPrice <- merge(MSFT_cashFlowPrice, msft_mcap, join = "outer")
#'
#' # Fill NA values of cash flow column using last available value
#' MSFT_cashFlowPrice$MSFT_cashFlowPrice <- na.locf(MSFT_cashFlowPrice$MSFT_cashFlowPrice)
#'
#' # rename columns
#' colnames(MSFT_cashFlowPrice) <- c("CashFlow", "MarketCap")
#'
#' # compute cash flow yield data
#' cashFlowYield <- function(cashFlow, marketCap) {
#'   return(cashFlow / marketCap)
#' }
#'
#' # call function on data
#' MSFT_cashFlowYield <- cashFlowYield(MSFT_cashFlowPrice$CashFlow, MSFT_cashFlowPrice$MarketCap)
#'
#' str(MSFT_cashFlowYield)
#'
#' save(MSFT_cashFlowPrice, file = "data/MSFT_cashFlowYield.RData")
#'
#' @export
cashFlowYield <- function(cashFlow, marketCap) {
  return(cashFlow / marketCap)
}
