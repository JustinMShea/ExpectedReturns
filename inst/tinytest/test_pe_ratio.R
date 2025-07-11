# Microsoft Market Cap Unit Tests

data("MSFT") # load data

data("MSFT_pePIT") # load data

### FOR NEXT TIME ###

# Need to get to msft adjusted and pePIT and change variables below this line

MSFT_pePIT <- pe_ratio(price = MSFT_wso_px$MSFT.Adjusted,
                        shares = MSFT_wso_px$WSO)

expect_identical(typeof(msft_mcap), "double")

# plot(msft_mcap)


# ticker_mkt_cap <- ticker_wso_px$ticker.Adjusted * ticker_wso_px$WSO

# # Visual displays
# plot(ticker_mkt_cap)
# head(prettyNum(coredata(msft_mcap),big.mark=","))
# tail(prettyNum(coredata(msft_mcap),big.mark=","))

