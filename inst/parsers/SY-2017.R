#' Mispricing Factors: Factors, Monthly
#'
#' Period: 1963-01 to 2016-12
#' Frequency: monthly
#'
#' Reference:
#' Stambaugh, R. F. and Yuan, Y. (2017). *Mispricing Factors*. The Review of Financial Studies.

# Download replication data set
SY.raw <- read.csv('http://finance.wharton.upenn.edu/~stambaug/M4.csv')

# Arrange data set
colnames(SY.raw)[1:2] <- c('Date', 'MKT.RF')
sy.vars <- c('MKT.RF', 'SMB', 'MGMT', 'PERF')
SY.raw <- SY.raw[, c('Date', 'RF', sy.vars)]

# Month-end dates
yrs <- as.numeric(substr(SY.raw$Date, 1, 4))
mos <- as.numeric(substr(SY.raw$Date, 5, 6))
monthly.dates <- as.Date.character(paste(yrs, mos + 1, '01', sep='-'), '%Y-%m-%d')
dates <- monthly.dates - 1
artificial.thirteenth.idxs <- which(is.na(dates))
dates[artificial.thirteenth.idxs] <- as.Date.character(
  paste(yrs, '12', '31', sep='-'),
  '%Y-%m-%d'
)[artificial.thirteenth.idxs]
SY.raw$Date <- dates

# Convert to xts
SY4.monthly <- xts::xts(SY.raw[, -1], dates)

# Save to sandbox if needed
# save(
#   SY4.monthly,
#   file = paste0('data/', 'SY4.monthly', '.RData'),
#   compress = 'xz', compression_level = 9
# )

# Remove unused variables
rm(
  SY.raw
  , sy.vars
  , yrs
  , mos
  , monthly.dates
  , dates
  , artificial.thirteenth.idxs
)
