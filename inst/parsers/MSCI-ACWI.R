
# MSCI Barra All Countries World Index (MSCI ACWI)
#
# From MSCI documentation:
# "The MSCI ACWI captures large and mid cap representation across 23 Developed Markets
# (DM) and 26 Emerging Markets (EM) countries. With 3,040 constituents, the index
# covers approximately 85% of the global investable equity opportunity set."
#
# Currency: USD
#
# Period: 1987-12-31 to 2020-05-29
#
# Source: https://www.msci.com/end-of-day-history?chart=regional&priceLevel=0&scope=R&style=C&asOf=Jun%2019,%202020&currency=15&size=36&indexId=106
#
# Copyright holder: (c) MSCI Inc.

# NOTE: Download the file from 'Source'
# WARNING: rio::import(), as other direct download methods, failed

path <- "your.path.here"
MSCI.ACWI.raw <- xlsx::read.xlsx(path, sheetIndex=1, startRow=7, endRow=397, header=TRUE)
colnames(MSCI.ACWI.raw) <- c('DATE', 'PRICE')
# NOTE: returns in decimal unit
MSCI.ACWI.raw$RET <- PerformanceAnalytics::Return.calculate(MSCI.ACWI.raw$PRICE, 'discrete')
MSCI.ACWI.raw$COMP.RET <- PerformanceAnalytics::Return.calculate(MSCI.ACWI.raw$PRICE, 'log')
MSCI.ACWI <- as.xts(MSCI.ACWI.raw[, 2:4], order.by=MSCI.ACWI.raw$DATE)

