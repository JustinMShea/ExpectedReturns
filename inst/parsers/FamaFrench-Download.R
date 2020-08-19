# Fama-French Models Factor Data
#
# Source: http://mba.tuck.dartmouth.edu/pages/faculty/ken.french/data_library.html

# Query and arrange data sets
## Fama-French three-factor model data
ff3.vars <- c('MKT.RF', 'SMB', 'HML')
FF3.monthly <- ExpectedReturns::GetFactors('FF3', 'FF', freq='monthly')
FF3.monthly <- FF3.monthly[, c('RF', ff3.vars)]

## Fama-French-Carhart four-factor model data
ff4.vars <- c(ff3.vars, 'MOM')
MOM.monthly <- ExpectedReturns::GetFactors('MOM', 'FF', freq='monthly')
min.tp <- max(xts::first(index(FF3.monthly)), xts::first(index(MOM.monthly)))
max.tp <- min(xts::last(index(FF3.monthly)), xts::last(index(MOM.monthly)))
days.diff <- diff(seq.Date(min.tp, max.tp, by='month'))[-1]
ff.dates <- c(min.tp, min.tp + cumsum(as.numeric(days.diff)))
FF4.monthly <- merge(FF3.monthly[ff.dates, ], MOM.monthly[ff.dates, ])
FF4.monthly <- FF4.monthly[, c('RF', ff4.vars)]

## Fama-French five-factor model data
ff5.vars <- c(ff3.vars, 'RMW', 'CMA')
FF5.monthly <- ExpectedReturns::GetFactors('FF5', 'FF', freq='monthly')
FF5.monthly <- FF5.monthly[, c('RF', ff5.vars)]

# Save data sets
# NOTE: save to sandbox if needed
objs.names <- c('FF3.monthly', 'FF4.monthly', 'FF5.monthly')
for (obj in objs.names) {
  save(
    list = obj,
    file = paste0('data/', obj, '.RData'),
    compress = 'xz', compression_level = 9
  )
}
