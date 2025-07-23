# Microsoft Price to Earnings Ratio

# attach price data
load("data/MSFT.RData")

# attach eps data
load("data/MSFT_epsRes.RData")

# merged price and pe for date matching
MSFT_pe_px <- merge(MSFT$MSFT.Adjusted, MSFT_epsRes)
names(MSFT_pe_px) <- c("MSFT.Adjusted","epsRes")
MSFT_pe_px <- na.locf(MSFT_pe_px)
MSFT_pe_px <- na.trim(MSFT_pe_px)

# Calculate PE ratio function
pe_ratio <- function(price, pe){
  return(price/pe)
}

msft_pe_res <- pe_ratio(price = MSFT_pe_px$MSFT.Adjusted,
                        pe = MSFT_pe_px$epsRes)

colnames(msft_pe_res) <- "PEratioRes"

save(msft_pe_res, file = "data/MSFT_peRes.RData")

# Optional visualizations
# plot(msft_mcap)
# head(prettyNum(coredata(msft_mcap),big.mark=","))
# tail(prettyNum(coredata(msft_mcap),big.mark=","))

