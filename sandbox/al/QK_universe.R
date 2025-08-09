library(qkiosk)

## Universe
universe <- qk_univ("QK100")
universe_symbol <- to_ticker(universe)

qk100 <- new.env()
library(quantmod)
getSymbols(Symbols=universe_symbol, env=qk100)

getSymbols("BRK-B", env=qk100)
getSymbols("UTX-W", env=qk100)

qk_fncodes()

load("data/MSFT.RData")

factor_framework()
