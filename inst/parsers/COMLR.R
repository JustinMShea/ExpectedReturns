
# Commodities for the Long Run: Index Level Data, Monthly
#
# Period: 1877-02-28 to 2020-05-29
#
# Source: https://www.aqr.com/Insights/Datasets/Commodities-for-the-Long-Run-Index-Level-Data-Monthly

## Import data
#AQR.COMLR.url <- "https://images.aqr.com/-/media/AQR/Documents/Insights/Data-Sets/Commodities-for-the-Long-Run-Index-Level-Data-Monthly.xlsx"

AQR.COMLR.url <-"https://images.aqr.com/-/media/AQR/Documents/Insights/Data-Sets/Commodities-for-the-Long-Run-Original-Paper-Data.xlsx"


tmp = tempfile(fileext = ".xlsx")
download.file(url = AQR.COMLR.url, destfile = tmp, mode="wb")

COMLR.raw <- suppressMessages(
  readxl::read_xlsx(tmp, skip = 9, col_names = TRUE,
                    col_types = c("text", "numeric","numeric","numeric","numeric","numeric","numeric",
                                  "numeric","numeric","numeric","text","text")
                    )
)
## Clean up
colnames(COMLR.raw) <- c(
  # XRET = excess return
  # PFC  = price forward curve
  # S    = spot
  # EW   = equal-weighted
  # LS   = long-short
  'DATE',
  paste(c('XRET', 'SXRET', 'CARRY.ADJ', 'SRET', 'CARRY'), 'EW', sep='.'),
  paste(c('XRET', 'SXRET', 'CARRY.ADJ'), 'LS', sep='.'),
  'PFC.AGG',
  paste(c('PFC', 'INFL'), 'STATE', sep='.')
)

COMLR <- COMLR.raw

## Convert variables
## Firstly, Dates are completely messed up in excel with two formats prior to January 1st 1900 and after.
## The below hack fixes this, though be careful, it will surely break again and require more hours to fix.
## If you DO spend more hours on this every changing format, please increase the counter below:
## Hours <- 11

COMLR$DATE <- as.Date(COMLR$DATE, format = "%Y-%m-%d")
COMLR$DATE[is.na(COMLR$DATE)] <- as.Date(as.numeric(COMLR.raw$DATE[first(which(is.na(COMLR$DATE))):NROW(COMLR.raw)]), origin = as.Date("1899-12-30"))
COMLR$DATE <- as.yearmon(COMLR$DATE)

COMLR$PFC.STATE <- ifelse(COMLR$PFC.STATE=="Contango", -1, 1)
COMLR$INFL.STATE <- ifelse(COMLR$INFL.STATE=="Inflation Down", -1, 1)
COMLR[, 2:ncol(COMLR)] <- apply(COMLR[, 2:ncol(COMLR)], 2, as.numeric)

COMLR <- xts::xts(COMLR[, -1], order.by = COMLR$DATE)

## Remove unused variables
rm(AQR.COMLR.url, COMLR.raw, tmp)
