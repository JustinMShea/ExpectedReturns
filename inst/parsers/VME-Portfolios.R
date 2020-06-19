
## Value and Momentum Everywhere: Portfolios, Monthly
#
# Last Updated by AQR: May 31, 2020
#
# Period: 1967-02-28 to 2020-05-31
#
# Source: https://www.aqr.com/Insights/Datasets/Value-and-Momentum-Everywhere-Portfolios-Monthly

# Dowload file (in R already)
AQR.VME.Portfolios.url <- "https://images.aqr.com/-/media/AQR/Documents/Insights/Data-Sets/Value-and-Momentum-Everywhere-Portfolios-Monthly.xlsx"
VME.Portfolios <- rio::import(AQR.VME.Portfolios.url)
# Clean up
cols.names <- 20
variable.names <- as.character(VME.Portfolios[cols.names, ])
start.data <- 21
VME.Portfolios <- VME.Portfolios[start.data:nrow(VME.Portfolios), ]
# Column names
variable.names <- gsub('_', '.', variable.names)
colnames(VME.Portfolios) <- toupper(variable.names)
rm(variable.names)
# Convert to "Date"
VME.Portfolios$DATE <- as.Date.character(VME.Portfolios$DATE, '%m/%d/%Y')
