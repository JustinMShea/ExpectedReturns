# load libraries
library(PerformanceAnalytics)
library(xts)
library(zoo)

# load price data
load("data/MSFT.RData")

# extract price data
prices <- MSFT[,6]

returns <- dailyReturn(prices)
