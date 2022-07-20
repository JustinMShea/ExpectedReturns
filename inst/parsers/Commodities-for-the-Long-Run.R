
## Commodities for the Long Run: Index Level Data, Monthly ##
 # https://www.aqr.com/Insights/Datasets/Commodities-for-the-Long-Run-Index-Level-Data-Monthly

 # Download

AQR_commodity_index_file <- "https://images.aqr.com/-/media/AQR/Documents/Insights/Data-Sets/Commodities-for-the-Long-Run-Index-Level-Data-Monthly.xlsx"

  # complete .xlsx sheet, containing data, and sources
    download.file(AQR_commodity_index_file, destfile = "sandbox/AQR_commodity.xlsx")

library(openxlsx)
AQR_comm_index <- read.xlsx(AQR_commodity_index_file, sheet = 1, startRow = 10)


colnames(AQR_comm_index) <- c("Date", "ExcessReturn.Equal",
               "ExcessSpot.Return.Equal", "InterestCarry.Equal",
               "SpotReturn.Equal", "Carry.Equal", "ExcessReturn.longshort",
               "ExcessSpot.Return.longshort","InterestCarry.longshort",
               "Aggregate.forwardcurve","State.forwardcurve", "State.Inflation")
 # Format
AQR_comm_index$Date <- as.Date(commodity_index_data$Date, format = "%m/%d/%Y")
AQR_comm_index$State.forwardcurve <- as.factor(commodity_index_data$State.forwardcurve)
AQR_comm_index$State.Inflation <- as.factor(commodity_index_data$State.Inflation)

 # Save to sandbox if needed
save(AQR_comm_index, file = paste0("sandbox/AQR_comm_index.RData"), compress = "xz", compression_level = 9)

