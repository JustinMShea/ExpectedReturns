# load libraries
library(quantmod)
library(xts)
library(zoo)

# load price data
load("data/MSFT.RData")

# extract price data
prices <- MSFT[,6]

# get return data
returns <- dailyReturn(prices)

# compute 1 month rolling volatility using zoo rollaplly
volatility <- rollapply(returns, 21, sd, fill = NA, align = "right")
colnames(volatility) <- "MSFT_volatility"

# save factor
save(volatility, file = "data/MSFT_volatility.RData")
