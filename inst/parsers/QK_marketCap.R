# Microsoft Market Cap

library(quantmod)

# get price data
getSymbols("MSFT")


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


# Calculate Market Cap function
market_cap <- function(price, shares){
  return(price*shares)
}

msft_mcap <- market_cap(price = MSFT_wso_px$MSFT.Adjusted,
                        shares = MSFT_wso_px$WSO)


# Visual exploration
plot(msft_mcap)
head(prettyNum(coredata(msft_mcap),big.mark=","))
tail(prettyNum(coredata(msft_mcap),big.mark=","))

