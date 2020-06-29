# MSCI Barra World Index (MSCI WI)
#
# From MSCI documentation:
# "The MSCI World Index captures large and mid cap representation across 23 Developed
# Markets (DM) countries. With 1,637 constituents, the index covers approximately
# 85% of the free float-adjusted market capitalization in each country."
#
# Period: 1969-12-31 to 2020-05-29
#
# Currency: USD
#
# Source: https://www.msci.com/end-of-day-history?chart=regional&priceLevel=0&scope=R&style=C&asOf=Jun%2019,%202020&currency=15&size=36&indexId=106
#
# Copyright holder: (c) MSCI Inc.

# WARNING: rio::import(), as other direct download methods, failed
#
# Parser relies on the following steps on your side:
# 1. Manually download the file from 'Source' link
# 2. Name the file 'MSCI_WI' and put it in your sandbox/data
#
# NOTE: DO NOT push the data file to the repository. We are already gitignoring the whole folder.

path.file <- file.path('sandbox', 'data', 'MSCI_WI.xls')
MSCI.WI.raw <- xlsx::read.xlsx(path.file, sheetIndex=1, startRow=7, endRow=613, header=TRUE)
# NOTE: returns in decimal unit
MSCI.WI <- as.xts(MSCI.WI.raw[, 2], order.by=MSCI.WI.raw[, 1])
colnames(MSCI.WI) <- c('PRICE')
MSCI.WI$RET <- PerformanceAnalytics::Return.calculate(MSCI.WI[, 'PRICE'], 'discrete')
MSCI.WI$COMP.RET <- PerformanceAnalytics::Return.calculate(MSCI.WI[, 'PRICE'], 'log')


