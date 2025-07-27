# load xts
library(xts)

# load price data
load("data/MSFT.RData")

# extract price data
prices <- MSFT[,6]

# lag data
price_lag_21 <- lag(prices, 21)
price_lag_252 <- lag(prices, 252)

# compute. get pct return from 12mo ago to 1mo ago. simple point to point mom. can use to easily develop more advanced data
momentum12mo <- (price_lag_21 / price_lag_252) - 1

# rename column
colnames(momentum12mo) <- "momentum12mo"

# remove NA values
momentum12mo <- na.omit(momentum12mo)

# optional visualization
plot(momentum12mo)

# save to file
save(momentum12mo, file = "data/MSFT_momentumSimp.RData")
