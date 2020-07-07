
# How Do Factor Premia Vary Over Time? A Century of Evidence, Factor Data Monthly
#
# Last Updated by AQR (reported): March 31, 2020
#
# Period: 1920-01-30 to 2020-05-29
#
# Source: https://www.aqr.com/Insights/Datasets/Century-of-Factor-Premia-Monthly

## Download in R environment
AQR.CFP.url <- "https://images.aqr.com/-/media/AQR/Documents/Insights/Data-Sets/Century-of-Factor-Premia-Monthly.xlsx"
AQR.CFP.raw <- suppressMessages(
  rio::import(AQR.CFP.url, format='xlsx')
)

## Clean up
header.row <- 18
data.begin.row <- header.row + 1
CFP <- AQR.CFP.raw[data.begin.row:nrow(AQR.CFP.raw), ]
rownames(CFP) <- NULL
colnames(CFP) <- as.character(AQR.CFP.raw[header.row, ])
data.end.row <- max(which(!is.na(CFP$Date)))
CFP <- CFP[1:data.end.row, ]
# Convert variables
CFP[, -1] <- apply(CFP[, -1], 2, as.numeric)
CFP$Date <- as.Date.character(CFP$Date, '%m/%d/%Y')
CFP <- xts::xts(CFP[, -1], order.by=CFP$Date)

## Rename variables
tmp <- gsub('-', '', colnames(CFP))
# Rename asset classes
tmp <- gsub('Equity indices', 'EQ', tmp)
tmp <- gsub('Fixed income', 'FI', tmp)
tmp <- gsub('Commodities', 'CM', tmp)
tmp <- gsub('Currencies', 'FX', tmp)
tmp <- gsub('All asset classes', 'ALL', tmp)
tmp <- gsub('All Macro', 'AM', tmp)
# Rename countries/regions
tmp <- gsub('US Stock Selection', 'US', tmp)
tmp <- gsub('Intl Stock Selection', 'INTL', tmp)
tmp <- gsub('All Stock Selection', 'GLOBAL', tmp)
# Rename Factors/Styles
tmp <- gsub('Value', 'VAL', tmp)
tmp <- gsub('Momentum', 'MOM', tmp)
tmp <- gsub('Carry', 'CARRY', tmp)
tmp <- gsub('Multistyle', 'MULTI', tmp)
# Remove spaces and capitalize
tmp <- gsub(' ', '.', tmp)
tmp <- toupper(tmp)
# Give sort of names schema <style.(country | ...)>
variables.split <- strsplit(tmp[1:40], '\\.') # all except '*.MARKET'
variables.swapped <- sapply(variables.split, function(x) {
  paste(rev(x), collapse = '.')
})
variable.names <- c(variables.swapped, tmp[41:44])
variable.names
# Reassign names
colnames(CFP) <- variable.names

## Remove unused variables
rm(
  AQR.CFP.url
  , AQR.CFP.raw
  , header.row
  , data.begin.row
  , data.end.row
  , tmp
  , variable.names
  , variables.split
  , variables.swapped
)
