# MSCI Barra World Index (MSCI WI)
#
# From MSCI documentation:
# "The MSCI World Index captures large and mid cap representation across 23 Developed
# Markets (DM) countries. With 1,637 constituents, the index covers approximately
# 85% of the free float-adjusted market capitalization in each country."
#
# Period: 1969-12-31 to 2021-06-29
#
# Currency: USD
#
# Source: https://www.msci.com/end-of-day-history?chart=regional&priceLevel=0&scope=R&style=C&asOf=Jun%2019,%202020&currency=15&size=36&indexId=106
#
# Copyright holder: (c) MSCI Inc.

#
# Parser relies on the following steps on your side:
# 1. Manually download the file from 'Source' link
# 2. Name the file 'MSCI_WI' and put it in your sandbox/data
#
# NOTE: DO NOT push the data file to the repository. We are already gitignoring the whole folder.

path.file <- file.path('sandbox', 'data', 'MSCI_WI.xls')
MSCI.WI.raw <- readxl::read_xls(path.file, sheet=1, skip=6, col_names =TRUE)
colnames(MSCI.WI.raw) <- c("Date", "Price")

# format
MSCI.WI.raw$Price <- as.numeric(gsub(",","", MSCI.WI.raw$Price))
MSCI.WI.raw$Date <- as.Date(MSCI.WI.raw$Date, format = "%b %d, %Y")
MSCI.WI.raw <- na.trim(MSCI.WI.raw)

# NOTE: returns in decimal unit
MSCI.WI <- as.xts(MSCI.WI.raw$Price, order.by=MSCI.WI.raw$Date)
colnames(MSCI.WI) <- 'PRICE'
MSCI.WI$RET <- PerformanceAnalytics::Return.calculate(MSCI.WI[, 'PRICE'], 'discrete')
MSCI.WI$COMP.RET <- PerformanceAnalytics::Return.calculate(MSCI.WI[, 'PRICE'], 'log')


