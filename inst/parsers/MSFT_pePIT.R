# Microsoft Price to Earnings Ratio

# attach price data
load("data/MSFT.RData")

# attach eps data
load("data/MSFT_eps.RData")

# merged price and pe for date matching
MSFT_pe_px <- merge(MSFT$MSFT.Adjusted, MSFT_eps)
names(MSFT_pe_px) <- c("MSFT.Adjusted","EPS")
MSFT_pe_px <- na.locf(MSFT_pe_px)
MSFT_pe_px <- na.trim(MSFT_pe_px)

# Calculate PE ratio function
pe_ratio <- function(price, pe){
  return(price/pe)
}

msft_pe <- pe_ratio(price = MSFT_pe_px$MSFT.Adjusted,
                        pe = MSFT_pe_px$EPS)

colnames(msft_pe) <- "PEratio"

save(msft_pe, file = "data/MSFT_pe.RData")

# KNOWN ISSUES - qk data has multiple fq measurements for certain singular dates, this causes the data to look
# fine when plotted but in actuality theres some sort of issue.

# Optional visualizations
# plot(msft_mcap)
# head(prettyNum(coredata(msft_mcap),big.mark=","))
# tail(prettyNum(coredata(msft_mcap),big.mark=","))

