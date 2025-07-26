# load xts
library(xts)

# load price data
load("data/MSFT.RData")

# extract price data
prices <- MSFT[,6]

# lag data
