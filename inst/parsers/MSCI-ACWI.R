
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

# WARNING: rio::import(), as other direct download methods, failed
#
# Parser relies on the following steps on your side:
# 1. Manually download the file from 'Source' link
# 2. Name the file 'MSCI_ACWI' and put it in your sandbox/data
#
# NOTE: DO NOT push the data file to the repository. We are already gitignoring the whole folder.

path.file <- file.path('sandbox', 'data', 'MSCI_ACWI.xls')
MSCI.ACWI.raw <- xlsx::read.xlsx(path.file, sheetIndex=1, startRow=7, endRow=397, header=TRUE)
# NOTE: returns in decimal unit
MSCI.ACWI <- as.xts(MSCI.ACWI.raw[, 2], order.by=MSCI.ACWI.raw[, 1])
colnames(MSCI.ACWI) <- c('PRICE')
MSCI.ACWI$RET <- PerformanceAnalytics::Return.calculate(MSCI.ACWI[, 'PRICE'], 'discrete')
MSCI.ACWI$COMP.RET <- PerformanceAnalytics::Return.calculate(MSCI.ACWI[, 'PRICE'], 'log')

