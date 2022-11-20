# The Devil in HML's Details: Factors, Monthly
## https://www.aqr.com/Insights/Datasets/The-Devil-in-HMLs-Details-Factors-Monthly

###--------------------------------------------------------------------------------#
## WARNING: Some countries factor returns parsed as char vectors. Needs formating ##
#--------------------------------------------------------------------------------###

#Define Import Function
# importRemoteAQRxlsxFile <- function(path, sheet = 1, startRow = 17, removeBlankRow = TRUE, dateFormat = "%Y-%m-%d"){
importRemoteAQRxlsxFile <- function(path, sheet, startRow = 19, removeBlankRow = TRUE, dateFormat = "%m/%d/%Y"){

  #download.file(url = path, destfile = tmp, mode="wb")
  #import data
  rawImportData <- openxlsx::read.xlsx(xlsxFile = path, sheet = sheet, startRow = startRow, colNames = FALSE, detectDates=TRUE)

  if(removeBlankRow){
      #remove weird first double-celled "bad" row from AQR .xlsx
      rawImportData <- rawImportData[-1,]
  }

  #set column/variable names
  colnames(rawImportData) <- rawImportData[1,]

  #remove column/variable names from dataset
  rawImportData <- rawImportData[-1,]

  rawImportData$DATE <- as.Date(rawImportData$DATE, format = dateFormat)

  #format all other values as numeric
  rawImportData[,-1] <-  switch(
                              class(rawImportData[,-1])
                            , data.frame = {apply(rawImportData[,-1],2,as.numeric)}
                            , {as.numeric(rawImportData[,-1])}
                              )

  #reset rownames
  rownames(rawImportData) <- NULL

  rawImportData <- xts::xts(x = rawImportData[,-1], order.by = rawImportData$DATE)

  return(rawImportData)

}

## Load Libraries
library(openxlsx)

## Download to Sandbox

AQR_HML_Devil_file <- download.file("https://images.aqr.com/-/media/AQR/Documents/Insights/Data-Sets/The-Devil-in-HMLs-Details-Factors-Monthly.xlsx", destfile = tempfile(fileext = ".xlsx"))

## Load data from Sandbox
### 1. Long/short High Minus Low Devil (HML Devil) factors

# NOTE (Vito): Switched 'HML_Devil.ExcessReturns' to 'HML_Devil.HML.DEV' as other factors.
#              If you already have your own code in place run:
#              HML_Devil.ExcessReturns <- HML_Devil.HML.DEV
HML_Devil.HML.DEV <- importRemoteAQRxlsxFile(path = AQR_HML_Devil_file, sheet = "HML Devil", startRow = 17)

##sample line to test - bryan added 11/19
rawImportData <- openxlsx::read.xlsx(xlsxFile = AQR_HML_Devil_file, sheet = "HML Devil", startRow = 17, colNames = FALSE, detectDates=TRUE)


### 2. Fama-French Factors
# NOTE (Vito): Switched 'HML_Devil.Mkt' to 'HML_Devil.MKT' for consistency with previous code.
#              If you already have your own code in place run:
#              HML_Devil.Mkt <- HML_Devil.MKT
HML_Devil.MKT <- importRemoteAQRxlsxFile(path = AQR_HML_Devil_file, sheet = "MKT", startRow = 17)

HML_Devil.SMB <- importRemoteAQRxlsxFile(path = AQR_HML_Devil_file, sheet = "SMB", startRow = 17)

HML_Devil.HML_FF <- importRemoteAQRxlsxFile(path = AQR_HML_Devil_file, sheet = "HML FF", startRow = 17)

### 3. Up Minus Down (UMD) factors
HML_Devil.UMD <- importRemoteAQRxlsxFile(path = AQR_HML_Devil_file, sheet = "UMD", startRow = 17)

### 4. Total Market Value of Equity (ME) factors, lagged 1 month (Billion USD)
HML_Devil.ME_1 <- importRemoteAQRxlsxFile(path = AQR_HML_Devil_file, sheet = "ME(t-1)", startRow = 17)

### 5. RF: U.S. Treasury bill rates
#HML_Devil.RF <- importRemoteAQRxlsxFile(path = AQR_HML_Devil_file, sheet = "RF", startRow = 17)
  #download.file(url = path, destfile = tmp, mode="wb")
  #import data
  rawImportData <- openxlsx::read.xlsx(xlsxFile = AQR_HML_Devil_file, sheet = "RF",
                                       startRow = 18, colNames = TRUE, detectDates=TRUE)

  rawImportData$DATE <- as.Date(rawImportData$DATE, format = "%m/%d/%Y")

  HML_Devil.RF <- xts::xts(x = rawImportData[,-1], order.by = rawImportData$DATE)



  #set column/variable names
  # colnames(rawImportData) <- rawImportData[1,]

  #remove column/variable names from dataset
  # rawImportData <- rawImportData[-1,]



  # # remove %
  # rawImportData$`Risk Free Rate` <- gsub("%", "", rawImportData$`Risk Free Rate`)

  #format all other values as numeric
  # rawImportData[,-1] <-  switch(
  #   class(rawImportData[,-1])
  #   , data.frame = {apply(rawImportData[,-1],2,as.numeric)}
  #   , {as.numeric(rawImportData[,-1])}
  # )
  #
  # #reset rownames
  # rownames(rawImportData) <- NULL



  # return(HML_Devil.RF)

# }

## Add script to merge factor data by country below ##

## Remove Import Function
rm(importRemoteAQRxlsxFile)
