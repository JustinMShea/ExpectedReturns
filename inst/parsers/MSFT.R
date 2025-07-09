# Microsoft Price Data
library(quantmod)

# get price data
ticker <- "MSFT"
getSymbols(ticker)

str(MSFT)

save(MSFT, file = "data/MSFT.RData")
