# Microsoft Price to Book Ratio

# attach market cap data
load("data/MSFT_marketCap.RData")

# attach book value data
load("data/MSFT_BookValue.RData")

# merge, fill bookvalue data, and remove NA afterwards
PB <- merge(BookValue, msft_mcap, join="outer")

# fill quarterly bookvalue for daily market cap granularity
PB$BookValue <- na.locf(PB$BookValue)

# get rid of rows where market cap is NA (weekends and where there is more early data for bookvalue)
PB <- PB[!is.na(PB$MarketCap),]

# Calculate PB ratio function
pb_ratio <- function(mcap, bvalue){
  return(mcap/bvalue)
}

msft_pbratio <- pb_ratio(mcap = PB$MarketCap, bvalue = PB$BookValue)

colnames(msft_pbratio) <- "PBratio"

save(msft_pbratio, file = "data/MSFT_pbRatio.RData")

# Optional visualizations
# plot(msft_mcap)
# head(prettyNum(coredata(msft_mcap),big.mark=","))
# tail(prettyNum(coredata(msft_mcap),big.mark=","))

