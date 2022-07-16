
# CBOE Volatility Index: VIX (VIXCLS)
#
# Units: Index, Not Seasonally Adjusted
#
# Period: 1990-01-02 to present
# (NOTE: not real-time, usually one day lag vs CBOE)
#
# Frequency: Daily, Close
#
# Source: https://fred.stlouisfed.org/series/VIXCLS

## VIX OHLC via quantmod (from Yahoo) is convenient, but too short series
# VIX.qm <- quantmod::getSymbols('^VIX', env=globalenv(), auto.assign=FALSE) # 2007-01-03 to date

## VIX Monthly Close via quantmod (from FRED)
VIX.cls.daily <- quantmod::getSymbols.FRED('VIXCLS', env=globalenv(), auto.assign=FALSE)
VIX.cls.daily <- zoo::na.fill(VIX.cls.daily, fill=c(NA, 'extend', 'extend'))
vix.monthly.idxs <- xts::endpoints(VIX.cls.daily)
VIX.cls.monthly <- VIX.cls.daily[vix.monthly.idxs, ]
# NOTE: returns in decimal unit
VIX.cls.monthly$VIX.RET <- PerformanceAnalytics::Return.calculate(VIX.cls.monthly$VIXCLS, 'discrete')
VIX.cls.monthly$VIX.COMP.RET <- PerformanceAnalytics::Return.calculate(VIX.cls.monthly$VIXCLS, 'log')

## Remove unused variables
rm(
  # VIX.qm,
  VIX.cls.daily,
  vix.monthly.idxs
)
