# Microsoft Price to Book Ratio

#scaffolding currently, needs to all be changed

# attach price data
load("data/MSFT.RData")

# attach eps data
load("data/MSFT_epsPIT.RData")

# merged price and pe for date matching
MSFT_pe_px <- merge(MSFT$MSFT.Adjusted, MSFT_epsPIT)
names(MSFT_pe_px) <- c("MSFT.Adjusted","epsPIT")
MSFT_pe_px <- na.locf(MSFT_pe_px)
MSFT_pe_px <- na.trim(MSFT_pe_px)

# Calculate PE ratio function
pe_ratio <- function(price, pe){
  return(price/pe)
}

msft_pe <- pe_ratio(price = MSFT_pe_px$MSFT.Adjusted,
                        pe = MSFT_pe_px$epsPIT)

colnames(msft_pe) <- "PEratioPIT"

save(msft_pe, file = "data/MSFT_pePIT.RData")

# Optional visualizations
# plot(msft_mcap)
# head(prettyNum(coredata(msft_mcap),big.mark=","))
# tail(prettyNum(coredata(msft_mcap),big.mark=","))

