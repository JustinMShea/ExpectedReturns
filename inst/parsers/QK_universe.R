library(qkiosk)

## Universe
universe <- qk_univ("QK1000")
universe_symbol <- to_ticker(universe)

qk1000 <- new.env()
library(quantmod)
getSymbols(Symbols=universe_symbol, env=qk1000)

getSymbols("BRK-B")
getSymbols("UTX-W")

qk_fncodes()
