## Shiller CAPE ##
# Stock market data used in his book, Irrational Exhuberancce. The data represents
# US Stock Markets from 1871 to Present and includes Shiller's Cyclically Adjusted
# PE Ratio (CAPE)
# http://www.econ.yale.edu/~shiller/data.htm

## Download to Sandbox

Shiller_CAPE_file <- "http://www.econ.yale.edu/~shiller/data/ie_data.xls"
path <- "sandbox/Shiller_CAPE.xlsx"
download.file(Shiller_CAPE_file, destfile = path)

## Load data from Sandbox
library(xlsx)

## Shiller CAPE data
# 14 columns - 1. Date, 2. S&P Composite Price (P), 3. Dividend (D), 4. Earnings (E),
# 5. Consumer Price Index (CPI), 6. Date Fraction, 7. Long Interest Rate (GS10),
# 8. Real Price which is derived with P[k] * CPI[current]/CPI[k] - See sheet for detail,
# 9. Real Dividend which is derived with D[k] * D[current]/D[k] - See sheet for detail,
# 10. Real Total Return Price which is derived with
# RTRP[k-1] * ((RealPrice[k] + RealDividend[k]/12) / Real Price[k-1]),
# 11. Real Earnings derived from E[k] * CPI[current]/CPI[k],
# 12. Real TR Scaled Earnings derived from RealEarnings * (Real TR Price / Real Price),
# 13. Cyclically Adjusted Price Earnings Ratio P/E10 or CAPE,
# 14. Cyclically Adjusted Total Return Price Earnings Ratio TR P/E10 or TR CAPE.

Shiller_CAPE <- xlsx::read.xlsx(path, sheetIndex = 4, startRow = 8)
colnames(Shiller_CAPE) <- c("Date","P","D","E","CPI","Date_Fraction","Rate_GS10",
                            "Real_Price","Real_Dividend","Real_Total_Return_Price",
                            "Real_Earnings","Real_TR_Scaled_Earnings","CAPE","TR_CAPE")
# Delete excess column data
Shiller_CAPE <- Shiller_CAPE[,-(15:ncol(Shiller_CAPE))]

# TODO: Clean up the Date column
# TODO: Clean up the NAs after latest observation
