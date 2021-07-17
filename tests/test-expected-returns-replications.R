library(tinytest)
library(ExpectedReturns)
library(FactorAnalytics)
data <- read.csv("data-test-time-series-momentum.csv")

test.data.input <- read.csv("test-expected-returns-replications-testdatainput.csv")
test.data <- read.csv("test-expected-returns-replications-testdata.csv")


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

