# Microsoft Market Cap

# attach price data
load("data/MSFT.RData")

# attach wso data
load("data/MSFT_wso.RData")

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

colnames(msft_mcap) <- "MarketCap"

save(msft_mcap, file = "data/MSFT_marketCap.RData")

# Optional visualizations
# plot(msft_mcap)
# head(prettyNum(coredata(msft_mcap),big.mark=","))
# tail(prettyNum(coredata(msft_mcap),big.mark=","))

