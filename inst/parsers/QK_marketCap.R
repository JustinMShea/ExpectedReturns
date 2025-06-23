# Microsoft Market Cap
require(colorDF)
library(qkiosk)

getSymbols("MSFT")

MSFT_wso <- as.data.frame(qk_fn(qk_ticker("MSFT"), "WSO")[])
MSFT_wso <- na.omit(MSFT_wso[ MSFT_wso$fq > 0, c("fq","filed")])
msft_wso <- xts(MSFT_wso$fq, order.by=as.Date(as.character(MSFT_wso$filed), "%Y%m%d"))

msft_wso_px <- merge(MSFT$MSFT.Adjusted, msft_wso)
names(msft_wso_px) <- c("MSFT.Adjusted","WSO")
msft_wso_px <- na.locf(msft_wso_px)
msft_wso_px <- na.trim(msft_wso_px)

msft_mkt_cap <- msft_wso_px$MSFT.Adjusted * msft_wso_px$WSO

# Visual displays
plot(msft_mkt_cap)
head(prettyNum(coredata(msft_mkt_cap),big.mark=","))


