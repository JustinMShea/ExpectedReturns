# Microsoft Market Cap
library(qkiosk)
library(quantmod)

getMarketCap <- function(ticker){
  getSymbols(ticker)

  ticker_wso <- as.data.frame(qk_fn(qk_ticker(ticker), "WSO")[])
  ticker_wso <- na.omit(ticker_wso[ ticker_wso$fq > 0, c("fq","filed")])
  ticker_wso <- xts(ticker_wso$fq, order.by=as.Date(as.character(ticker_wso$filed), "%Y%m%d"))

  ticker_wso_px <- merge(ticker$ticker.Adjusted, ticker_wso)
  names(ticker_wso_px) <- c("ticker.Adjusted","WSO")
  ticker_wso_px <- na.locf(ticker_wso_px)
  ticker_wso_px <- na.trim(ticker_wso_px)

  ticker_mkt_cap <- ticker_wso_px$ticker.Adjusted * ticker_wso_px$WSO

  return(ticker_mkt_cap)
}



# Visual displays
plot(ticker_mkt_cap)
head(prettyNum(coredata(ticker_mkt_cap),big.mark=","))


