## US Home Prices 1890-Present ##
# From the website:
# "Historical housing market data used in my book, Irrational Exuberance [Princeton
# University Press 2000, Broadway Books 2001, 2nd edition, 2005], showing home prices
# since 1890 are available for download and updated monthly: US Home Prices 1890-Present."
# http://www.econ.yale.edu/~shiller/data.htm
#
# Note: Monthly data from January 1953, annual before then.
# Note: Last 2 columns are annual frequency, Date and CPI_Annual

## Download to Sandbox

Shiller_Home_Prices <- "http://www.econ.yale.edu/~shiller/data/Fig3-1.xls"
path <- "sandbox/Shiller_Home_Prices.xlsx"
download.file(Shiller_Home_Prices, destfile = path)

## Load data from Sandbox
library(xlsx)

## Shiller Alternative TR CAPE data
# 19 columns - 1. Date, 2. Real Home Price Index, 3. Date, 4. Real Building Cost Index,
# 5. US Population Millions, 6. Long Rate, 7. Long Rate Source,
# 8. Date, 9. Nominal Home Price Index, 10. HPI Source, 11. Date,
# 12. Nominal Building Cost Index, 13. Build Cost Source,
# 14. Date, 15. Consumer Price Index, 16. CPI Annual & Quarterly, 17. Date
# 18. CPI Annual
# See website for explanation, the book for a description of the data and the raw .xls
# sheet for any calculations.

Shiller_Home_Prices <- xlsx::read.xlsx(path, sheetIndex = 2, startRow = 7)
colnames(Shiller_Home_Prices) <- c("Date","Real_Home_Price_Index","Date",
                                   "Real_Building_Cost_Index","US_Population_Millions",
                                   "Long_Rate", "Long_Rate_Source", "Date",
                                   "Nominal_Home_Price Index", "HPI_Source", "Date",
                                   "Nominal_Building_Cost_Index", "Build_Cost_Source", "Date",
                                   "Consumer_Price_Index", "CPI_Annual_Quarterly","Date",
                                   "CPI_Annual")

# TODO: Clean up the Date column
# TODO: Clean up the NAs after latest observation
# TODO: Add tests for changes in the data schema, ie. start row, number of columns etc
