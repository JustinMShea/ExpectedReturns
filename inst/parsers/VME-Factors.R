
## Value and Momentum Everywhere: Factors, Monthly
#
# Last Updated by AQR: May 31, 2020
#
# Period: 1972-01-31 to 2020-05-31
#
# Source: https://www.aqr.com/Insights/Datasets/Value-and-Momentum-Everywhere-Factors-Monthly

## Download in R environment
AQR.VME.Factors.url <- "https://images.aqr.com/-/media/AQR/Documents/Insights/Data-Sets/Value-and-Momentum-Everywhere-Factors-Monthly.xlsx"
# path <- "sandbox/data/AQR.VME.Factors.xlsx"
# download.file(AQR.VME.Factors.url, path)
# VME.Factors <- openxlsx::read.xlsx(path, sheet=1, startRow=23, colNames=FALSE)
VME.Factors.raw <- rio::import(AQR.VME.Factors.url, format='xlsx')

## Clean up
header.row <- 21
data.begin.row <- header.row + 1
VME.Factors <- VME.Factors.raw[data.begin.row:nrow(VME.Factors.raw), ]

variable.names <- as.character(VME.Factors.raw[header.row, ])
variable.names <- gsub('\\^', '.', variable.names)
variable.names <- gsub('_', '.', variable.names)
variable.names <- sub("^VAL$", replacement="VAL.EVR", variable.names)
variable.names <- sub("^MOM$", replacement="MOM.EVR", variable.names)
colnames(VME.Factors) <- variable.names
rm(variable.names)

# Convert variables to "numeric" and dates to "Date"
VME.Factors.vars <- colnames(VME.Factors) != 'DATE'
VME.Factors[, VME.Factors.vars] <- apply(VME.Factors[, VME.Factors.vars], 2, as.numeric)
VME.Factors$DATE <- as.Date.character(VME.Factors$DATE, '%m/%d/%Y')

# Remove empty cells
row.names(VME.Factors) <- NULL
data.end.row <- max(which(!is.na(VME.Factors$DATE)))
VME.Factors <- VME.Factors[1:data.end.row, ]
