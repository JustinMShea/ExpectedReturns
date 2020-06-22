# MSCI Barra World Index (MSCI WI)
#
# From MSCI documentation:
# "The MSCI World Index captures large and mid cap representation across 23 Developed
# Markets (DM) countries. With 1,637 constituents, the index covers approximately
# 85% of the free float-adjusted market capitalization in each country."
#
# Period: 1961-12-31 to 2020-05-29
#
# Currency: USD
#
# Source: https://www.msci.com/end-of-day-history?chart=regional&priceLevel=0&scope=R&style=C&asOf=Jun%2019,%202020&currency=15&size=36&indexId=106
#
# Copyright holder: (c) MSCI Inc.

# NOTE: Download the file from 'Source'
# WARNING: rio::import(), as other direct download methods, failed

path <- "your.path.here"
MSCI.WI.raw <- xlsx::read.xlsx(path, sheetIndex=1, startRow=7, endRow=613, header=TRUE)
colnames(MSCI.WI.raw) <- c('DATE', 'PRICE')
# NOTE: returns in decimal unit
MSCI.WI.raw$RET <- PerformanceAnalytics::Return.calculate(MSCI.WI.raw$PRICE, 'discrete')
MSCI.WI.raw$COMP.RET <- PerformanceAnalytics::Return.calculate(MSCI.WI.raw$PRICE, 'log')
MSCI.WI <- as.xts(MSCI.WI.raw[, 2:4], order.by=MSCI.WI.raw$DATE)
