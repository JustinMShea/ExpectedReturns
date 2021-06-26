
# Credit Risk Premium: Preliminary Paper Data, Monthly
#
# Reported by AQR: February 27, 2018
#
# Period: 1926-01-29 to 2014-12-31
#
# Source: https://www.aqr.com/Insights/Datasets/Credit-Risk-Premium-Preliminary-Paper-Data

## Download data in R environment
AQR.CRP.url <- "https://images.aqr.com/-/media/AQR/Documents/Insights/Data-Sets/Credit-Risk-Premium-Preliminary-Paper-Data.xlsx"
CRP <- openxlsx::read.xlsx(AQR.CRP.url, sheet=1, startRow=10,
                                         colNames=TRUE, detectDates = TRUE)
## Clean up
variable.names <- colnames(CRP)
variable.names <- gsub('_', '.', variable.names)
colnames(CRP) <- toupper(variable.names)

# Convert variables to "numeric" and dates to "Date"
# NOTE: dates get parsed as character, but are numeric relative dates

## Remove unused variables
rm(AQR.CRP.url, variable.names)
