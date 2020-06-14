
# The Devil in HML's Details: Factors, Monthly
## https://www.aqr.com/Insights/Datasets/The-Devil-in-HMLs-Details-Factors-Monthly

###--------------------------------------------------------------------------------#
 ## WARNING: Some countries factor returns parsed as char vectors. Needs formating ##
  #--------------------------------------------------------------------------------###

## Download to Sandbox

AQR_HML_Devil_file <- "https://images.aqr.com/-/media/AQR/Documents/Insights/Data-Sets/The-Devil-in-HMLs-Details-Factors-Monthly.xlsx"
download.file(AQR_HML_Devil_file, destfile = "sandbox/data/AQR_HML_Devil.xlsx")

## Load data from Sandbox
library(openxlsx)
path <- "sandbox/data/AQR_HML_Devil.xlsx"

### 1. Long/short High Minus Low Devil (HML Devil) factors

HML_Devil.ExcessReturns <- read.xlsx(path, sheet = 1, startRow = 18, colNames = FALSE)
    # NOTE: Due to .xlsx formatting, can't read in with column names automatically
    variable.names <- read.xlsx(path, sheet = 1, startRow = 17)
    colnames(HML_Devil.ExcessReturns) <- variable.names[1,]
    rm(variable.names)

    HML_Devil.ExcessReturns$DATE <- as.Date(HML_Devil.ExcessReturns$DATE, format = "%m/%d/%Y")


### 2. Fama-French Factors

HML_Devil.Mkt <- read.xlsx(path, sheet = 5, startRow = 18, colNames = FALSE)
    # NOTE: Due to .xlsx formatting, can't read in with column names automatically
    variable.names <- read.xlsx(path, sheet = 5, startRow = 17)
    colnames(HML_Devil.Mkt) <- variable.names[1,]
    rm(variable.names)

    HML_Devil.Mkt$DATE <- as.Date(HML_Devil.Mkt$DATE, format = "%m/%d/%Y")

HML_Devil.SMB <- read.xlsx(path, sheet = 6, startRow = 18, colNames = FALSE)
    # NOTE: Due to .xlsx formatting, can't read in with column names automatically
    variable.names <- read.xlsx(path, sheet = 6, startRow = 17)
    colnames(HML_Devil.SMB) <- variable.names[1,]
    rm(variable.names)

    HML_Devil.SMB$DATE <- as.Date(HML_Devil.SMB$DATE, format = "%m/%d/%Y")

HML_Devil.HML_FF <- read.xlsx(path, sheet = 7, startRow = 18, colNames = FALSE)
    # NOTE: Due to .xlsx formatting, can't read in with column names automatically
    variable.names <- read.xlsx(path, sheet = 7, startRow = 17)
    colnames(HML_Devil.HML_FF) <- variable.names[1,]
    rm(variable.names)

    HML_Devil.HML_FF$DATE <- as.Date(HML_Devil.HML_FF$DATE, format = "%m/%d/%Y")


### 3. Up Minus Down (UMD) factors
HML_Devil.UMD <- read.xlsx(path, sheet = 8, startRow = 18, colNames = FALSE)
    # NOTE: Due to .xlsx formatting, can't read in with column names automatically
    variable.names <- read.xlsx(path, sheet = 8, startRow = 17)
    colnames(HML_Devil.UMD) <- variable.names[1,]
    rm(variable.names)

    HML_Devil.UMD$DATE <- as.Date(HML_Devil.UMD$DATE, format = "%m/%d/%Y")

### 4. Total Market Value of Equity (ME) factors, lagged 1 month (Billion USD)
HML_Devil.ME_1 <- read.xlsx(path, sheet = 9, startRow = 19, colNames = FALSE)
    # NOTE: Due to .xlsx formatting, can't read in with column names automatically
    variable.names <- read.xlsx(path, sheet = 9, startRow = 18)
    colnames(HML_Devil.ME_1) <- variable.names[1,]
    rm(variable.names)

    HML_Devil.ME_1$DATE <- as.Date(HML_Devil.ME_1$DATE, format = "%m/%d/%Y")



