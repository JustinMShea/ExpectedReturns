
# CBOE VIX Index Historical Data, daily
#
# Currency: USD
#
# Period: 1990-01-02 to present
#
# Frequency: daily
#
# Source: http://www.cboe.com/products/vix-index-volatility/vix-options-and-futures/vix-index/vix-historical-data

## VIX 1990-01-02 to 2003-12-31 (old methodology)
VIX1.raw <- rio::import('http://www.cboe.com/publish/scheduledtask/mktdata/datahouse/vixarchive.xls')
# Clean up data
header.row <- 1
data.begin.row <- header.row + 1
VIX1 <- VIX1.raw[data.begin.row:nrow(VIX1.raw), ]
rownames(VIX1) <- NULL
colnames(VIX1) <- as.character(VIX1.raw[header.row, ])
# Convert variables
dates.rel.days <- diff(as.numeric(VIX1$Date))
vix.first.date <- as.Date('1990-01-02')
vix.dates <- c(vix.first.date, vix.first.date + cumsum(dates.rel.days))
VIX1[, -1] <- suppressWarnings(
  # NA coercion intended
  apply(VIX1[, -1], 2, as.numeric)
)
VIX1 <- xts::xts(VIX1[, -1], order.by=vix.dates)

## VIX 2004-01-02 to date
VIX2.raw <- rio::import('http://www.cboe.com/publish/scheduledtask/mktdata/datahouse/vixcurrent.csv')
# Clean up
header.row <- 2
data.begin.row <- header.row + 1
VIX2 <- VIX2.raw[data.begin.row:nrow(VIX2.raw), ]
rownames(VIX2) <- NULL
colnames(VIX2) <- as.character(VIX2.raw[header.row, ])
# Convert variables
VIX2[, -1] <- apply(VIX2[, -1], 2, as.numeric)
VIX2$Date <- as.Date.character(VIX2$Date, '%m/%d/%Y')
VIX2 <- xts::xts(VIX2[, -1], order.by=VIX2$Date)

## VIX 1990-01-02 to date
# VIX monthly
VIX.daily <- rbind(VIX1, VIX2)
vix.monthly.idxs <- xts::endpoints(VIX.daily)
VIX.monthly <- VIX.daily[vix.monthly.idxs, ]
variable.names <- gsub(' ', '.', colnames(VIX.daily))
colnames(VIX.monthly) <- colnames(VIX.daily) <- toupper(variable.names)
# VIX returns, open-to-open and close-to-close
VIX.monthly$VIX.RET.OO <- PerformanceAnalytics::Return.calculate(VIX.monthly$VIX.OPEN, 'discrete')
VIX.monthly$VIX.COMP.RET.OO <- PerformanceAnalytics::Return.calculate(VIX.monthly$VIX.OPEN, 'log')
VIX.monthly$VIX.RET.CC <- PerformanceAnalytics::Return.calculate(VIX.monthly$VIX.CLOSE, 'discrete')
VIX.monthly$VIX.COMP.RET.CC <- PerformanceAnalytics::Return.calculate(VIX.monthly$VIX.CLOSE, 'log')

## Remove unused variables
rm(
  VIX1.raw,
  VIX2.raw,
  header.row,
  data.begin.row,
  VIX1,
  VIX2,
  VIX.daily,
  vix.monthly.idxs,
  variable.names
)
