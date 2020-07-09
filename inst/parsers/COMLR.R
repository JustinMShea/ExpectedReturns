
# Commodities for the Long Run: Index Level Data, Monthly
#
# Period: 1877-02-28 to 2020-05-29
#
# Source: https://www.aqr.com/Insights/Datasets/Commodities-for-the-Long-Run-Index-Level-Data-Monthly

## Import data
AQR.COMRL.url <- "https://images.aqr.com/-/media/AQR/Documents/Insights/Data-Sets/Commodities-for-the-Long-Run-Index-Level-Data-Monthly.xlsx"
COMRL.raw <- suppressMessages(
  rio::import(AQR.COMRL.url, format='xlsx')
)

## Clean up
header.row <- 10
data.begin.row <- header.row + 1
COMLR <- COMRL.raw[data.begin.row:nrow(COMRL.raw), ]
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
COMLR[, 2:(ncol(COMLR) - 2)] <- apply(COMLR[, 2:(ncol(COMLR) - 2)], 2, as.numeric)
pfc.d <- c("Backwardation"=1, "Contango"=0)
infl.d <- c("Inflation Up"=1, "Inflation Down"=0)
COMLR$PFC.STATE <- pfc.d[COMLR$PFC.STATE]
COMLR$INFL.STATE <- infl.d[COMLR$INFL.STATE]
COMLR <- xts::xts(COMLR[, -1], order.by=COMLR$DATE)

## Remove unused variables
rm(
  AQR.COMRL.url
  , COMRL.raw
  , header.row
  , data.begin.row
)
