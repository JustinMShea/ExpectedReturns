# Value momentum everywhere, monthly factors from original source used on paper

# Last updated by AQR on February 27th, 2018

# Period 1972-01-31/2011-07-31

# Source: https://images.aqr.com/Insights/Datasets/Value-and-Momentum-Everywhere-Factors-Monthly

##Download data to R
AQR.VME.Factors.orig.url <- "https://images.aqr.com/-/media/AQR/Documents/Insights/Data-Sets/Value-and-Momentum-Everywhere-Original-Paper-Data.xlsx"
VME.Factors.orig <- openxlsx::read.xlsx(AQR.VME.Factors.orig.url, sheet = 2, startRow = 15, colNames = TRUE, detectDates =  TRUE)

## Clean up
variable.names <- colnames((VME.Factors.orig))
variable.names <- gsub('\\^', 'Factor', variable.names)
variable.names <- sub("^VAL$", replacement = "VAL.EVR", variable.names)
variable.names <- sub("^MOM$", replacement = "MOM.EVR", variable.names)
colnames(VME.Factors.orig) <- variable.names

## Remove NA's
# VME.Factors.orig <- zoo::na.trim(VME.Factors.orig)

## Convert to xts
VME.Factors.orig <- xts::xts(VME.Factors.orig[,-1], order.by = as.yearmon(VME.Factors.orig$DATE))

## Remove unused variables
rm(AQR.VME.Factors.orig.url,
   variable.names
)
