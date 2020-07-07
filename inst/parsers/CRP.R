
# Credit Risk Premium: Preliminary Paper Data, Monthly
#
# Reported by AQR: February 27, 2018
#
# Period: 1926-01-29 to 2014-12-31
#
# Source: https://www.aqr.com/Insights/Datasets/Credit-Risk-Premium-Preliminary-Paper-Data

## Download data in R environment
AQR.CRP.url <- "https://images.aqr.com/-/media/AQR/Documents/Insights/Data-Sets/Credit-Risk-Premium-Preliminary-Paper-Data.xlsx"
CRP.raw <- suppressMessages(
  rio::import(AQR.CRP.url, format='xlsx')
)

## Clean up
header.row <- 10
data.begin.row <- header.row + 1
CRP <- CRP.raw[data.begin.row:nrow(CRP.raw), ]
rownames(CRP) <- NULL
variable.names <- as.character(CRP.raw[header.row, ])
variable.names <- gsub('_', '.', variable.names)
colnames(CRP) <- toupper(variable.names)

# Convert variables to "numeric" and dates to "Date"
# NOTE: dates get parsed as character, but are numeric relative dates
CRP <- apply(CRP, 2, as.numeric)
dates.rel.days <- diff(CRP[, 'DATE'])
first.date <- as.Date('1926-01-29')
dates <- c(first.date, first.date + cumsum(dates.rel.days))
CRP.vars <- colnames(CRP) != 'DATE'
CRP <- data.frame(DATE=dates, CRP[, CRP.vars])

## Remove unused variables
rm(
  AQR.CRP.url
  , CRP.raw
  , header.row
  , data.begin.row
  , dates.rel.days
  , first.date
  , dates
)
