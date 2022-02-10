# The Devil in HML's Details: Factors, Monthly
## https://www.aqr.com/Insights/Datasets/The-Devil-in-HMLs-Details-Factors-Monthly

###--------------------------------------------------------------------------------#
## WARNING: Some countries factor returns parsed as char vectors. Needs formating ##
#--------------------------------------------------------------------------------###

#Define Import Function
# importRemoteAQRxlsxFile <- function(path, sheet = 1, startRow = 17, removeBlankRow = TRUE, dateFormat = "%Y-%m-%d"){
importRemoteAQRxlsxFile <- function(path, sheet = 1, startRow = 17, removeBlankRow = TRUE, dateFormat = "%m/%d/%Y"){

  #download.file(url = path, destfile = tmp, mode="wb")
  #import data
  rawImportData <- openxlsx::read.xlsx(xlsxFile = path, sheet = 1, startRow = 17, colNames = FALSE, detectDates=TRUE)

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

  return(rawImportData)

}

## Load Libraries
library(openxlsx)

## Download to Sandbox

AQR_HML_Devil_file <- "https://images.aqr.com/-/media/AQR/Documents/Insights/Data-Sets/The-Devil-in-HMLs-Details-Factors-Monthly.xlsx"

## Load data from Sandbox
### 1. Long/short High Minus Low Devil (HML Devil) factors

# NOTE (Vito): Switched 'HML_Devil.ExcessReturns' to 'HML_Devil.HML.DEV' as other factors.
#              If you already have your own code in place run:
#              HML_Devil.ExcessReturns <- HML_Devil.HML.DEV
HML_Devil.HML.DEV <- importRemoteAQRxlsxFile(path = AQR_HML_Devil_file, sheet = "HML Devil")

### 2. Fama-French Factors
# NOTE (Vito): Switched 'HML_Devil.Mkt' to 'HML_Devil.MKT' for consistency with previous code.
#              If you already have your own code in place run:
#              HML_Devil.Mkt <- HML_Devil.MKT
HML_Devil.MKT <- importRemoteAQRxlsxFile(path = AQR_HML_Devil_file, sheet = "MKT")

HML_Devil.SMB <- importRemoteAQRxlsxFile(path = AQR_HML_Devil_file, sheet = "SMB")

HML_Devil.HML_FF <- importRemoteAQRxlsxFile(path = AQR_HML_Devil_file, sheet = "HML FF")

### 3. Up Minus Down (UMD) factors
HML_Devil.UMD <- importRemoteAQRxlsxFile(path = AQR_HML_Devil_file, sheet = "UMD")

### 4. Total Market Value of Equity (ME) factors, lagged 1 month (Billion USD)
HML_Devil.ME_1 <- importRemoteAQRxlsxFile(path = AQR_HML_Devil_file, sheet = "ME(t-1)")

### 5. RF: U.S. Treasury bill rates
HML_Devil.RF <- importRemoteAQRxlsxFile(path = AQR_HML_Devil_file, sheet = "RF", removeBlankRow = TRUE)

## Add script to merge factor data by country below ##

## Remove Import Function
rm(importRemoteAQRxlsxFile)

## Check
# lapply(
# ls()[sapply(sapply(ls(),function(x){gregexpr("HML_",x)}),`[`,1) == 1]
# , function(variable){
#   variable <- get(variable,envir = .GlobalEnv)
#   sumVars <-
#   switch(class(variable[,-1])
#          , data.frame = apply(variable[,-1],2,sum,na.rm=TRUE)
#          , sum(variable[,-1])
#   )
#   sumVars <- sum(sumVars)
# })
