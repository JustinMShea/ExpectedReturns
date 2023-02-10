
# The Devil in HML's Details: Factors, Monthly
## https://www.aqr.com/Insights/Datasets/The-Devil-in-HMLs-Details-Factors-Monthly

###--------------------------------------------------------------------------------#
 ## WARNING: Some countries factor returns parsed as char vectors. Needs formating ##
  #--------------------------------------------------------------------------------###

## Download to Sandbox

AQR_HML_Devil_file <- "https://www.aqr.com/-/media/AQR/Documents/Insights/Data-Sets/The-Devil-in-HMLs-Details-Factors-Monthly.xlsx"
download.file(AQR_HML_Devil_file, destfile = "sandbox/data/AQR_HML_Devil.xlsx")

## Load data from Sandbox
library(openxlsx)
path <- "sandbox/data/AQR_HML_Devil.xlsx"

### 1. Long/short High Minus Low Devil (HML Devil) factors

# NOTE (Vito): Switched 'HML_Devil.ExcessReturns' to 'HML_Devil.HML.DEV' as other factors.
#              If you already have your own code in place run:
#              HML_Devil.ExcessReturns <- HML_Devil.HML.DEV
HML_Devil.HML.DEV <- read.xlsx(path, sheet = 1, startRow = 20, colNames = FALSE)
    # NOTE: Due to .xlsx formatting, can't read in with column names automatically
    variable.names <- read.xlsx(path, sheet = 1, startRow = 17)
    colnames(HML_Devil.HML.DEV) <- variable.names[1,]
    rm(variable.names)

    HML_Devil.HML.DEV$DATE <- as.yearmon(HML_Devil.HML.DEV$DATE, format = "%m/%d/%Y")

    HML_Devil.HML.DEV <- xts(HML_Devil.HML.DEV[,-1],
                             order.by = HML_Devil.HML.DEV$DATE)


### 2. Fama-French Factors
# NOTE (Vito): Switched 'HML_Devil.Mkt' to 'HML_Devil.MKT' for consistency with previous code.
#              If you already have your own code in place run:
#              HML_Devil.Mkt <- HML_Devil.MKT
HML_Devil.MKT <- read.xlsx(path, sheet = 5, startRow = 20, colNames = FALSE)
    # NOTE: Due to .xlsx formatting, can't read in with column names automatically
    variable.names <- read.xlsx(path, sheet = 5, startRow = 17)
    colnames(HML_Devil.MKT) <- variable.names[1,]


    HML_Devil_MKT.index <- as.yearmon(HML_Devil.MKT$DATE, format = "%m/%d/%Y")
    HML_Devil_MKT.core <- apply(X = HML_Devil.MKT[,-1], MARGIN = 2, FUN = as.numeric)

    HML_Devil.MKT <- xts(HML_Devil_MKT.core, order.by = HML_Devil_MKT.index)
    rm(variable.names, HML_Devil_MKT.core, HML_Devil_MKT.index)

# SMB
HML_Devil.SMB <- read.xlsx(path, sheet = 6, startRow = 20, colNames = FALSE)
    # NOTE: Due to .xlsx formatting, can't read in with column names automatically
    variable.names <- read.xlsx(path, sheet = 6, startRow = 17)
    colnames(HML_Devil.SMB) <- variable.names[1,]

    HML_Devil.SMB$DATE <- as.yearmon(HML_Devil.SMB$DATE, format = "%m/%d/%Y")
    HML_Devil.SMB$PRT <- as.numeric(HML_Devil.SMB$PRT)

    HML_Devil.SMB <- xts(HML_Devil.SMB[,-1], order.by = HML_Devil.SMB$DATE)

    rm(variable.names)

# HML
HML_Devil.HML_FF <- read.xlsx(path, sheet = 7, startRow = 20, colNames = FALSE)
    # NOTE: Due to .xlsx formatting, can't read in with column names automatically
    variable.names <- read.xlsx(path, sheet = 7, startRow = 17)
    colnames(HML_Devil.HML_FF) <- variable.names[1,]

    HML_Devil.HML_FF.index <- as.Date(HML_Devil.HML_FF$DATE, format = "%m/%d/%Y")
    HML_Devil.HML_FF.core <- apply(HML_Devil.HML_FF[,-1], 2, as.numeric)

    HML_Devil.HML_FF <- xts(HML_Devil.HML_FF.core, order.by = HML_Devil.HML_FF.index)

    rm(variable.names, HML_Devil.HML_FF.index, HML_Devil.HML_FF.core)

### 3. Up Minus Down (UMD) factors
HML_Devil.UMD <- read.xlsx(path, sheet = 8, startRow = 20, colNames = FALSE)
    # NOTE: Due to .xlsx formatting, can't read in with column names automatically
    variable.names <- read.xlsx(path, sheet = 8, startRow = 17)
    colnames(HML_Devil.UMD) <- variable.names[1,]

    HML_Devil.UMD$DATE <- as.Date(HML_Devil.UMD$DATE, format = "%m/%d/%Y")
    HML_Devil.UMD$IRL <- as.numeric(HML_Devil.UMD$IRL)

    HML_Devil.UMD <- xts(HML_Devil.UMD[,-1], order.by = HML_Devil.UMD$DATE)

    rm(variable.names)

### 4. Total Market Value of Equity (ME) factors, lagged 1 month (Billion USD)
HML_Devil.ME_1 <- read.xlsx(path, sheet = 9, startRow = 20, colNames = FALSE)
    # NOTE: Due to .xlsx formatting, can't read in with column names automatically
    variable.names <- read.xlsx(path, sheet = 9, startRow = 18)
    colnames(HML_Devil.ME_1) <- variable.names[1,]

    HML_Devil.ME_1.index <- as.yearmon(HML_Devil.ME_1$DATE, format = "%m/%d/%Y")
    HML_Devil.ME_1.core <- apply(HML_Devil.ME_1[,-1], 2, as.numeric)

    HML_Devil.ME_1 <- xts(HML_Devil.ME_1.core, order.by = HML_Devil.ME_1.index)

    rm(variable.names, HML_Devil.ME_1.index, HML_Devil.ME_1.core)

### 5. RF: U.S. Treasury bill rates
    HML_Devil.RF <- read.xlsx(path, sheet = 10, startRow = 8, colNames = TRUE)

    HML_Devil.RF$DATE <- as.yearmon(HML_Devil.RF$DATE, format = "%m/%d/%Y")

    HML_Devil.RF <- xts(HML_Devil.RF$Risk.Free.Rate, order.by = HML_Devil.RF$DATE)


## Add script to merge factor data by country below ##
