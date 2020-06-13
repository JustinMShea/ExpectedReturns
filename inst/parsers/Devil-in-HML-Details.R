
## The Devil in HML's Details: Factors, Monthly ##
# https://www.aqr.com/Insights/Datasets/The-Devil-in-HMLs-Details-Factors-Monthly

## Download to Sandbox

AQR_HML_Devil_file <- "https://images.aqr.com/-/media/AQR/Documents/Insights/Data-Sets/The-Devil-in-HMLs-Details-Factors-Monthly.xlsx"
path <- "sandbox/AQR_HML_Devil.xlsx"
download.file(AQR_HML_Devil_file, destfile = path)

## Load data from Sandbox
library(openxlsx)

 ## Excess returns of long/short High Minus Low Devil (HML Devil) factors
HML_Devil.ExcessReturns <- read.xlsx(path, sheet = 1, startRow = 18, colNames = FALSE)
  # NOTE: Due to .xlsx formatting, can't read in with column names automatically
variable.names <- read.xlsx(path, sheet = 1, startRow = 17)
colnames(HML_Devil) <- variable.names[1,]
rm(variable.names)
  # Format
HML_Devil$DATE <- as.Date(HML_Devil$DATE, format = "%m/%d/%Y")

 ## Up Minus Down (UMD) factors
HML_Devil.UMD <- read.xlsx(path, sheet = 8, startRow = 18, colNames = TRUE)
  # NOTE: Due to .xlsx formatting, can't read in with column names automatically
variable.names <- read.xlsx(path, sheet = 8, startRow = 17)
colnames(HML_Devil.UMD) <- variable.names[1,]
rm(variable.names)
  # Format
HML_Devil.UMD$DATE <- as.Date(HML_Devil.UMD$DATE, format = "%m/%d/%Y")


# Save to .RData file if we decide/get permissions.
# save(HML_Devil, file = paste0("data/AQR_HML_Devil.RData"), compress = "xz", compression_level = 9)

