#' Market Cap
#'
#'
#' @param price type double. Vector of share prices
#' @param sharesOutstanding type double. Vector of shares outstanding.
#'
#' @returns
#'
#' @examples
#' data(MSFT)
#' data(MSFT_wso)
#'
#' msft_mcap <- market_cap(price = MSFT_wso_px$MSFT.Adjusted,
#'                          shares_outstanding = MSFT_wso_px$WSO)
#'
#' str(msft_mcap)
#' plot(msft_mcap)
#'
#' head(prettyNum(coredata(msft_mcap),big.mark=","))
#' tail(prettyNum(coredata(msft_mcap),big.mark=","))
#'
#' @export
market_cap <- function(price, shares_outstanding){

  return(price*shares_outstanding)

  }
