
# NBER based Recession Indicators for the United States from the Period following the Peak through the Trough
#
# Units: +1 (recession) or 0 (expansion), Not Seasonally Adjusted
#
# Frequency: monthly
#
# Source: https://fred.stlouisfed.org/series/USREC

library(zoo)
USREC <- quantmod::getSymbols.FRED('USREC', env=globalenv(), auto.assign=FALSE)
USREC <- xts::xts(
  zoo::coredata(USREC), order.by=zoo::as.Date(zoo::as.yearmon(zoo::index(USREC)), frac=1)
)
