#' Price to Book Ratio
#'
#'
#' @param price type double. Vector of share prices
#' @param earnings per share type double. Vector of book values.
#'
#' @returns
#'
#' @examples
#'# attach market cap data
#'load("data/MSFT_marketCap.RData")
#'
#'# attach book value data
#'load("data/MSFT_BookValue.RData")
#'
#'# merge, fill bookvalue data, and remove NA afterwards
#'PB <- merge(BookValue, msft_mcap, join="outer")
#'
#'# fill quarterly bookvalue for daily market cap granularity
#'PB$BookValue <- na.locf(PB$BookValue)
#'
#'PB <- PB[!is.na(PB$MarketCap),]
#'
#'# Calculate PB ratio function
#'pb_ratio <- function(mcap, bvalue){
#'  return(mcap/bvalue)
#'}
#'
#'msft_pbratio <- pb_ratio(mcap = PB$MarketCap, bvalue = PB$BookValue)
#'
#'colnames(msft_pbratio) <- "PBratio"
#' 
#' str(msft_pbratio
#' plot(msft_pbratio)
#'
#' head(msft_pbratio)
#' tail(msft_pbratio)
#'
#' @export
pb_ratio <- function(mcap, bvalue){
  return(mcap/bvalue)
}