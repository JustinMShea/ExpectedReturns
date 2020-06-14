## Shiller Alternative CAPE ##
# From the website:
# "As of September 2018, I now also include an alternative version of CAPE that
# is somewhat different. As documented in Bunn & Shiller (2014) and Jivraj and
# Shiller (2017), changes in corporate payout policy (i. e. share repurchases
# rather than dividends have now become a dominant approach in the United States
# for cash distribution to shareholders) may affect the level of the CAPE ratio
# through changing the growth rate of earnings per share. This subsequently may
# affect the average of the real earnings per share used in the CAPE ratio. A total
# return CAPE corrects for this bias through reinvesting dividends into the price
# index and appropriately scaling the earnings per share.
# http://www.econ.yale.edu/~shiller/data.htm

## Download to Sandbox

Shiller_CAPE_file <- "http://www.econ.yale.edu/~shiller/data/ie_data_with_TRCAPE.xls"
path <- "sandbox/Shiller_Alternative_TRCAPE.xlsx"
download.file(Shiller_CAPE_file, destfile = path)

## Load data from Sandbox
library(xlsx)

## Shiller CAPE data
# 14 columns - 1. Date, 2. S&P Composite Price (P), 3. Dividend (D), 4. Earnings (E),
# 5. Consumer Price Index (CPI), 6. Date Fraction, 7. Long Interest Rate (GS10),
# 8. Real Price, 9. Real Dividend, 10. Real Total Return Price, 11. Real Earnings,
# 12. Real TR Scaled Earnings, 13. Cyclically Adjusted Price Earnings Ratio P/E10 or CAPE,
# 14. Cyclically Adjusted Total Return Price Earnings Ratio TR P/E10 or TR CAPE.
# See website for explanation of adjustments, and the raw .xls sheet for calculations
# effective Sep 2018.

Shiller_TRCAPE <- xlsx::read.xlsx(path, sheetIndex = 3, startRow = 8)
colnames(Shiller_TRCAPE) <- c("Date","P","D","E","CPI","Date_Fraction","Rate_GS10",
                            "Real_Price","Real_Dividend","Real_Total_Return_Price",
                            "Real_Earnings","Real_TR_Scaled_Earnings","CAPE","TR_CAPE")
# Delete excess column data
Shiller_TRCAPE <- Shiller_TRCAPE[,-(15:ncol(Shiller_TRCAPE))]

# TODO: Clean up the Date column
# TODO: Clean up the NAs after latest observation
# TODO: Add tests for changes in the data schema, ie. start row, number of columns etc
