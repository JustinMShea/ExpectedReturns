
# TED Spread (TEDRATE)
#
# Units: Percent, Not Seasonally Adjusted
#
# Period: 1986-01-02 to date
#
# Frequency: Daily
#
# Source: https://fred.stlouisfed.org/series/TEDRATE

## Import FRED data
TED.SPREAD.daily <- quantmod::getSymbols.FRED('TEDRATE', env=globalenv(), auto.assign=FALSE)

## TED Spread monthly
ted.monthly.idxs <- xts::endpoints(TED.SPREAD.daily)
TED.SPREAD.monthly <- TED.SPREAD.daily[ted.monthly.idxs, ]

## TED Spread monthly decimal
TED.SPREAD <- TED.SPREAD.monthly/100

## Remove unused variables
rm(
  TED.SPREAD.daily,
  ted.monthly.idxs,
  TED.SPREAD.monthly
)
