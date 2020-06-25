
# Time Series Momentum: Factors, Monthly (AQR)
#
# Last Updated by AQR (reported): April 30, 2020
#
# Period: 1985-01-31 to 2020-05-29
#
# Source: https://www.aqr.com/Insights/Datasets/Time-Series-Momentum-Factors-Monthly

## Import data in R
AQR.TSM.url <- "https://images.aqr.com/-/media/AQR/Documents/Insights/Data-Sets/Time-Series-Momentum-Factors-Monthly.xlsx"
TSM.raw <- rio::import(AQR.TSM.url, format='xlsx')

## Clean up
header.row <- 17
data.begin.row <- header.row + 1
TSM <- TSM.raw[data.begin.row:nrow(TSM.raw), ]
rownames(TSM) <- NULL
variable.names <- as.character(TSM.raw[header.row, ])
variable.names <- variable.names <- gsub('\\^', '.', variable.names)
colnames(TSM) <- toupper(variable.names)

# Convert dates to "Date"
TSM$DATE <- as.Date.character(TSM$DATE, '%m/%d/%Y')

# Remove empty cells
data.end.row <- max(which(!is.na(TSM$DATE)))
TSM <- TSM[1:data.end.row, ]
