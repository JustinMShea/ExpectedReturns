#' Price to Earnings Ratio
#'
#'
#' @param price type double. Vector of share prices
#' @param earnings per share type double. Vector of eps values.
#'
#' @returns
#'
#' @examples
#' # attach price data
#' load("data/MSFT.RData")
#' 
#' # attach eps data
#' load("data/MSFT_epsPIT.RData")
#' 
#' # merged price and pe for date matching
#' MSFT_pe_px <- merge(MSFT$MSFT.Adjusted, MSFT_epsPIT)
#' names(MSFT_pe_px) <- c("MSFT.Adjusted","epsPIT")
#' MSFT_pe_px <- na.locf(MSFT_pe_px)
#' MSFT_pe_px <- na.trim(MSFT_pe_px)
#' 
#' # Calculate PE ratio function
#' pe_ratio <- function(price, pe){
#'   return(price/pe)
#' }
#' 
#' msft_pe <- pe_ratio(price = MSFT_pe_px$MSFT.Adjusted,
#'                         pe = MSFT_pe_px$epsPIT)
#' 
#' colnames(msft_pe) <- "PEratioPIT"
#' 
#' str(msft_pe)
#' plot(msft_pe)
#'
#' head(msft_pe)
#' tail(msft_pe)
#'
#' @export
pe_ratio <- function(price, pe){
  return(price/pe)
}
