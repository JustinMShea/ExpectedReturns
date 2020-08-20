# Q-Factors Models Factor Data
#
# Source: http://global-q.org/factors.html
#
# Credits: http://global-q.org/background.html

# Query and arrange data sets
## Q5 model data
Q5.monthly <- ExpectedReturns::GetFactors('Q5', 'HXZ', freq='monthly')

# Save data sets
# NOTE: save to sandbox if needed
objs.names <- 'Q5.monthly' # c('Q4.monthly', 'Q5.monthly')
for (obj in objs.names) {
  save(
    list = obj,
    file = paste0('data/', obj, '.RData'),
    compress = 'xz', compression_level = 9
  )
}
