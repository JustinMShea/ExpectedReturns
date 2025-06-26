# Microsoft Market Cap

library(quantmod)

# get price data
ticker <- "MSFT"
getSymbols(ticker)


# get qk weighted shares outstanding and return file date and shares outstanding, returns data frame
library(qkiosk)

MSFT_wso <- as.data.frame(qk_fn(qk_ticker("MSFT"), "WSO")[])
MSFT_wso <- na.omit(MSFT_wso[ MSFT_wso$fq > 0, c("fq","filed")])
MSFT_wso$filed <- as.Date(as.character(MSFT_wso$filed), "%Y%m%d")

# merged price and shares outstanding for date matching
MSFT_wso_px <- merge(MSFT$MSFT.Adjusted, MSFT_wso)
names(MSFT_wso_px) <- c("MSFT.Adjusted","WSO")
MSFT_wso_px <- na.locf(MSFT_wso_px)
MSFT_wso_px <- na.trim(MSFT_wso_px)



market_cap <- function(price, sharesOutstanding){
  return(price*sharesOutstanding)
}

msft_mcap <- market_cap(price = MSFT_wso_px$MSFT.Adjusted, sharesOutstanding = MSFT_wso_px$WSO)

plot(msft_mcap)


# ticker_mkt_cap <- ticker_wso_px$ticker.Adjusted * ticker_wso_px$WSO

# Visual displays
plot(ticker_mkt_cap)
head(prettyNum(coredata(msft_mcap),big.mark=","))
tail(prettyNum(coredata(msft_mcap),big.mark=","))

