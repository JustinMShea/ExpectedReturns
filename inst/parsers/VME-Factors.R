
## Value and Momentum Everywhere: Factors, Monthly
#
# Last Updated by AQR: May 31, 2020
#
# Period: 1972-01-31 to 2020-05-31
#
# Source: https://www.aqr.com/Insights/Datasets/Value-and-Momentum-Everywhere-Factors-Monthly

# Download to (your) sandbox/data/
AQR.VME.Factors.url <- "https://images.aqr.com/-/media/AQR/Documents/Insights/Data-Sets/Value-and-Momentum-Everywhere-Factors-Monthly.xlsx"
path <- "sandbox/data/AQR.VME.Factors.xlsx"
download.file(AQR.VME.Factors.url, path)
# NOTE due to .xlsx formatting, can't read in with column names automatically
VME.Factors <- openxlsx::read.xlsx(path, sheet=1, startRow=23, colNames=FALSE)
# Remove empty cells (not NA)
empty.idxs <- which(apply(VME.Factors == "", 1, all))
incl.idxs <- setdiff(as.numeric(rownames(VME.Factors)), empty.idxs)
VME.Factors <- VME.Factors[incl.idxs, ]
# Column names
variable.names <- openxlsx::read.xlsx(path, sheet=1, startRow=22)
variable.names <- colnames(variable.names[1, ])
variable.names <- gsub('\\^', '.', variable.names)
variable.names <- gsub('_', '.', variable.names)
variable.names <- sub("^VAL$", replacement="VAL.EVR", variable.names)
variable.names <- sub("^MOM$", replacement="MOM.EVR", variable.names)
colnames(VME.Factors) <- variable.names
rm(variable.names)
# Convert to "Date"
VME.Factors$DATE <- as.Date.character(VME.Factors$DATE, '%m/%d/%Y')
