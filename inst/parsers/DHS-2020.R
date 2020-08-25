#' Short-and long-horizon behavioral factors: Factors, Monthly
#'
#' Period: 1972-07 to 2018-12
#' Frequency: monthly
#'
#' Unit: decimal
#'
#' Reference:
#' Daniel, K. and Hirshleifer, D. and Sun, L. (2020). *Short-and long-horizon behavioral factors*. The Review of Financial Studies.

# Download replication data set
DHS.raw <- rio::import('http://www.kentdaniel.net/data/DHS_factors.xlsx', format='xlsx')

# Month-end dates
yrs <- as.numeric(substr(DHS.raw$date, 1, 4))
mos <- as.numeric(substr(DHS.raw$date, 5, 6))
monthly.dates <- as.Date.character(paste(yrs, mos + 1, '01', sep='-'), '%Y-%m-%d')
dates <- monthly.dates - 1
artificial.thirteenth.idxs <- which(is.na(dates))
dates[artificial.thirteenth.idxs] <- as.Date.character(
  paste(yrs, '12', '31', sep='-'),
  '%Y-%m-%d'
)[artificial.thirteenth.idxs]
DHS.raw$date <- dates

# Convert to xts
DHS2.monthly <- xts::xts(DHS.raw[, -1], dates)
DHS2.monthly <- DHS2.monthly / 100

# Add the market factor, which is part of this 3-factor model but it's currently
# missing from the original data set authors provide.
# The 'MKT.RF' we add is Fama-French's one.
dhs3.vars <- c('MKT.RF', 'PEAD', 'FIN')
data("FF4.monthly") # TODO: data("FF3.monthly"), less redundant
DHS3.monthly <- merge(FF4.monthly$MKT.RF, DHS2.monthly)
DHS3.monthly <- DHS3.monthly[complete.cases(DHS3.monthly), dhs3.vars]

# NOTE: save to sandbox if needed
# save(
#   DHS3.monthly,
#   file = 'data/DHS3.monthly.RData',
#   compress = 'xz', compression_level = 9
# )

# Remove unused variables
rm(
  DHS.raw
  , DHS2.monthly
  , FF4.monthly
  , dhs3.vars
  , yrs
  , mos
  , monthly.dates
  , dates
  , artificial.thirteenth.idxs
)
