# Microsoft Earnings Yield Point in Time

# attach price to earnings data
load("data/MSFT_peRes.RData")

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

earnings_yield_res <- earnings_yield(msft_pe_res)

colnames(msft_pe_res) <- "earningsYieldRes"

save(msft_pe_res, file = "data/MSFT_earningsYieldRes.RData")

# Optional visualizations
# plot(msft_mcap)
# head(prettyNum(coredata(msft_mcap),big.mark=","))
# tail(prettyNum(coredata(msft_mcap),big.mark=","))

