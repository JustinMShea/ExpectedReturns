# Microsoft Book Value Time Series Parser

# Load qk library
library(qkiosk)

# May need to add qk API key into environment variables for data to be fetched.
# Free keys available online.

# Pull line item data on total assets and total liabilities
df <- qk_fn(qk_ticker("MSFT"), c("AT","LT"))

# Total assets
at <- df[[1]]
at <- at[,c("fpe", "rptq")]
colnames(at)[2] <- "AT"

# Total liabilities
lt <- df[[2]]
lt <- lt[,c("fpe","rptq")]
colnames(lt)[2] <- "LT"

# Merge by date
merged <- merge(at, lt, by="fpe")

# Calc book value
merged$BookValue <-merged$AT - merged$LT

# Convert fpe to date for xts conversion
merged$Date <- as.Date(as.character(merged$fpe), format = "%Y%m%d")
merged <- xts(merged$BookValue, order.by=merged$Date)

str(merged)

# Save data
save(merged, file = "data/MSFT_BookValue.RData")
