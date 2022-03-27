
# Commodities for the Long Run: Index Level Data, Monthly
#
# Period: 1877-02-28 to 2020-05-29
#
# Source: https://www.aqr.com/Insights/Datasets/Commodities-for-the-Long-Run-Index-Level-Data-Monthly

## Import data
AQR.COMLR.url <- "https://images.aqr.com/-/media/AQR/Documents/Insights/Data-Sets/Commodities-for-the-Long-Run-Index-Level-Data-Monthly.xlsx"

COMLR.raw <- suppressMessages(
  rio::import(AQR.COMLR.url, format='xlsx')
)

## Clean up
header.row <- 10
data.begin.row <- header.row + 1
COMLR <- COMLR.raw[data.begin.row:nrow(COMLR.raw), ]
row.names(COMLR) <- NULL
colnames(COMLR) <- c(
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

## Convert variables
COMLR$DATE <- as.Date(COMLR$DATE, format = "%m/%d/%Y")
COMLR[, 2:ncol(COMLR)] <- apply(COMLR[, 2:ncol(COMLR)], 2, as.numeric)

#COMLR$PFC.STATE <- ifelse(COMLR$PFC.STATE==0, "Contango", "Backwardation")
#COMLR$INFL.STATE <- ifelse(COMLR$INFL.STATE==0, "Inflation.Down", "Inflation.Up")

COMLR <- xts::xts(COMLR[, -1], order.by = as.yearmon(COMLR$DATE))

## Remove unused variables
rm(
  AQR.COMLR.url
  , COMLR.raw
  , header.row
  , data.begin.row
)
