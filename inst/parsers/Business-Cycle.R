## Business Cycle indicator

library(xts)

# US Recessions
Recession_Indicators <- "https://fred.stlouisfed.org/data/USREC.txt"
USREC <- as.xts(read.zoo(Recession_Indicators , sep = "", skip = 69, index.column = 1,
                         header = TRUE, format = "%Y-%m-%d", FUN = as.yearmon))
colnames(USREC) <- "USREC"
