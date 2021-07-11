library(tinytest)
library(ExpectedReturns)
library(FactorAnalytics)

# make 'ff3.data.monthly' and 'factorDataSetDjia5Yrs' compatible for testing
data("factorDataSetDjia5Yrs")
data("FF3.monthly")
factorDataSetDjia5Yrs <- factorDataSetDjia5Yrs[, c('DATE', 'TICKER', 'NAME', 'RETURN.OLD', 'RETURN', 'RETURN.DIFF')]
ff3.data.monthly.dates <- index(FF3.monthly)
ff3.data.monthly <- as.data.frame(coredata(FF3.monthly))
ff3.data.monthly <- cbind(ff3.data.monthly.dates, ff3.data.monthly)
colnames(ff3.data.monthly)[1] <- 'DATE'
factorDataSetDjia5Yrs$DATE <- as.Date(factorDataSetDjia5Yrs$DATE)
test.data <- merge(factorDataSetDjia5Yrs, ff3.data.monthly)
test.data$EXC.RETURN <- test.data$RETURN - test.data$RF
test.data$RF <- NULL
test.data.plm <- test.data
periods <- unique(factorDataSetDjia5Yrs$DATE)
periods.id <- 1:length(periods)
periods.id <- data.frame('DATE'=periods, 'PERIOD.ID'=periods.id)
test.data.plm <- merge(test.data.plm, periods.id, by='DATE')
tickers <- unique(factorDataSetDjia5Yrs$TICKER)
assets.id <- 1:length(tickers)
assets.id <- data.frame('TICKER'=tickers, 'ASSET.ID'=assets.id)
test.data.plm <- merge(test.data.plm, assets.id)
test.data.plm <- test.data.plm[order(test.data.plm[, 'ASSET.ID'], test.data.plm[, 'PERIOD.ID']), ]
row.names(test.data.plm) <- NULL
test.data.input <- test.data.plm[, c("ASSET.ID", "PERIOD.ID", "DATE", "EXC.RETURN", "MKT.RF", "SMB", "HML")]



# Time-series regressions using plm package
fm.ts.reg <- plm::pmg(EXC.RETURN ~ MKT.RF + SMB + HML,
                      data=test.data.input, index=c('ASSET.ID', 'PERIOD.ID'))
summary(fm.ts.reg)
betas <- t(fm.ts.reg$indcoef) # all coefficients
rownames(betas) <- tickers
colnames(betas) <- paste('BETA', colnames(betas), sep='.')

# Time-series regressions using FactorAnalysis package
test.data.third <- data.table::dcast(test.data, DATE ~ TICKER,  value.var = "EXC.RETURN")
test.data.third <- merge(test.data.third, ff3.data.monthly[c('DATE', 'MKT.RF','SMB','HML')], by='DATE')
row.names(test.data.third) <- test.data.third$DATE
test.data.third$DATE <- NULL
fit.test <- fitTsfm(asset.names = unique(factorDataSetDjia5Yrs$TICKER), factor.names = c('MKT.RF','SMB','HML'), data = test.data.third)
fit.test.coefs <- cbind(fit.test$alpha, fit.test$beta)

expect_equivalent(fit.test.coefs,as.data.frame(betas))


#Cross-section using plm package
test.data.input.second <- test.data.input[order(test.data.input[, 'DATE']), ]
test.data.input.second <- data.frame(
  test.data.input.second[, c("PERIOD.ID", "ASSET.ID", "DATE", "EXC.RETURN")],
  betas[, 2:4]
)
fm.cs.reg <- plm::pmg(EXC.RETURN ~ BETA.MKT.RF + BETA.SMB + BETA.HML,
                      data=test.data.input.second, index=c('PERIOD.ID', 'ASSET.ID'))
gammas <- t(fm.cs.reg$indcoef) # all coefficients
gammas <- data.frame(periods, gammas)
colnames(gammas) <- c('DATE', '(Intercept)', 'MKT.RF', 'SMB', 'HML')

#Cross-section using factorAnalysis package
test.data.fourth  <-  data.frame(test.data[, c("DATE", "TICKER", "EXC.RETURN")], fit.test.coefs[, 2:4])
exposure.vars <- c('MKT.RF', 'SMB', 'HML')
fit.test.second <- fitFfm(data=test.data.fourth, asset.var="TICKER", ret.var="EXC.RETURN", date.var="DATE", exposure.vars=exposure.vars, addIntercept=TRUE, lagExposures = FALSE)
fit.test.second.coefs <- data.frame(unique(test.data.fourth$DATE), fit.test.second$factor.returns)
colnames(fit.test.second.coefs) <- c('DATE', '(Intercept)', 'MKT.RF', 'SMB', 'HML')
row.names(fit.test.second.coefs) <- NULL
expect_equivalent(fit.test.second.coefs, gammas)

