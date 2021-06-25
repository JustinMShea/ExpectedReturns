
# Time Series Momentum: Factors, Monthly (AQR)
#
# Last Updated by AQR (reported): April 30, 2020
#
# Period: 1985-01-31 to 2020-05-29
#
# Source: https://www.aqr.com/Insights/Datasets/Time-Series-Momentum-Factors-Monthly

## Import data in R
AQR.TSM.url <- "https://images.aqr.com/-/media/AQR/Documents/Insights/Data-Sets/Time-Series-Momentum-Factors-Monthly.xlsx"
TSM.raw <- openxlsx::read.xlsx(AQR.TSM.url, startRow = 17, detectDates = TRUE)

## Clean up
TSM <- TSM.raw
variable.names <- colnames(TSM.raw)
variable.names <- gsub('\\^', '.', variable.names)
colnames(TSM) <- toupper(variable.names)

# Convert variables to "numeric" and dates to "Date"
TSM.vars <- colnames(TSM) != 'DATE'
TSM[, TSM.vars] <- apply(TSM[, TSM.vars], 2, as.numeric)
TSM$DATE <- as.Date.character(TSM$DATE, '%Y-%m-%d')

# Remove empty cells
TSM <- na.trim(TSM)

## Remove unused variables
rm(
  AQR.TSM.url
  , TSM.raw
  , header.row
  , data.begin.row
  , variable.names
  , TSM.vars
  , data.end.row
)
