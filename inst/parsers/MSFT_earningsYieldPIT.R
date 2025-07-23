# Microsoft Earnings Yield Point in Time

# attach price to earnings data
load("data/MSFT_pePIT.RData")

# earnings yield function
earnings_yield <- function(pe_data){
  if (!is.data.frame(pe_data) && !xts::is.xts(pe_data)) {
    stop("Input must be a data frame or an xts object.")
  }
  # Calculate earnings yield
  earnings_yield <- 1 / pe_data

  # Return the earnings yield as a numeric vector
  return(earnings_yield)
}

earnings_yield_pit <- earnings_yield(msft_pe_pit)

colnames(msft_pe_pit) <- "earningsYieldPIT"

save(msft_pe_pit, file = "data/MSFT_earningsYieldPIT.RData")

# Optional visualizations
# plot(msft_mcap)
# head(prettyNum(coredata(msft_mcap),big.mark=","))
# tail(prettyNum(coredata(msft_mcap),big.mark=","))

