# load required libraries
library(qkiosk)

# load market cap
load("data/MSFT_marketCap.RData")

# fetch fcf component data
df <- qk_fn(qk_ticker("MSFT"), c("CF_COA", "CF_PPEPMT"))

# calculate free cash flow

