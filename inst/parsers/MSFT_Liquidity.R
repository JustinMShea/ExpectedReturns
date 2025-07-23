# load quantmod
library(quantmod)

# fetch data on stock
df <- getSymbols("MSFT", src = "yahoo", auto.assign = FALSE, from = "2007-01-03")

# clean and prepare liquidity data
df <- df[,c(5,6)]
df$Liquidity <- df$MSFT.Volume*df$MSFT.Adjusted
df <- na.omit(df)

# assign
msft_liquidity <- df[,3]

# optional checks

# head(msft_liquidity)
# tail(msft_liquidity)
# plot(msft_liquidity)

save(msft_liquidity, file = "data/MSFT_liquidity.RData")
