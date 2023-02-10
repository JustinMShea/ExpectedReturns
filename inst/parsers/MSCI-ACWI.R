
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

# WARNING: all other direct download methods, failed
#
# Parser relies on the following steps on your side:
# 1. Manually download the file from 'Source' link
# 2. Name the file 'MSCI_ACWI' and put it in your sandbox/data
#
# NOTE: DO NOT push the data file to the repository. We are already gitignoring the whole folder.

path.file <- file.path('sandbox', 'data', 'MSCI_ACWI.xls')
MSCI.ACWI.raw <- readxl::read_xls(path.file, sheet=1, skip=6, n_max = 402,
                                  col_names =TRUE)
MSCI.ACWI.raw <- as.data.frame(MSCI.ACWI.raw)
colnames(MSCI.ACWI.raw) <- c("Date", "Price")

# format
MSCI.ACWI.raw$Price <- as.numeric(gsub(",","", MSCI.ACWI.raw$Price))
MSCI.ACWI.raw$Date <- as.Date(MSCI.ACWI.raw$Date, format = "%b %d, %Y")

# NOTE: returns in decimal unit
MSCI.ACWI <- xts::xts(x = MSCI.ACWI.raw$Price, order.by = as.yearmon(MSCI.ACWI.raw$Date))
colnames(MSCI.ACWI) <- c('PRICE')
MSCI.ACWI$RET <- PerformanceAnalytics::Return.calculate(MSCI.ACWI[, 'PRICE'], 'discrete')
MSCI.ACWI$COMP.RET <- PerformanceAnalytics::Return.calculate(MSCI.ACWI[, 'PRICE'], 'log')

rm(MSCI.ACWI.raw, path.file)
