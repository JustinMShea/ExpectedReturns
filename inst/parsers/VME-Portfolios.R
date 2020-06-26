
## Value and Momentum Everywhere: Portfolios, Monthly
#
# Last Updated by AQR: May 31, 2020
#
# Period: 1967-02-28 to 2020-05-31
#
# Source: https://www.aqr.com/Insights/Datasets/Value-and-Momentum-Everywhere-Portfolios-Monthly

## Download in R environment
AQR.VME.Portfolios.url <- "https://images.aqr.com/-/media/AQR/Documents/Insights/Data-Sets/Value-and-Momentum-Everywhere-Portfolios-Monthly.xlsx"
VME.Portfolios.raw <- rio::import(AQR.VME.Portfolios.url, format='xlsx')

## Clean up
header.row <- 20
data.begin.row <- header.row + 1
VME.Portfolios <- VME.Portfolios.raw[data.begin.row:nrow(VME.Portfolios.raw), ]
rownames(VME.Portfolios) <- NULL

variable.names <- as.character(VME.Portfolios.raw[header.row, ])
variable.names <- gsub('_', '.', variable.names)
colnames(VME.Portfolios) <- toupper(variable.names)
rm(variable.names)

# Convert variables to "numeric" and dates to "Date"
VME.Portfolios.vars <- colnames(VME.Portfolios) != 'DATE'
VME.Portfolios[, VME.Portfolios.vars] <- apply(VME.Portfolios[, VME.Portfolios.vars], 2, as.numeric)
VME.Portfolios$DATE <- as.Date.character(VME.Portfolios$DATE, '%m/%d/%Y')
