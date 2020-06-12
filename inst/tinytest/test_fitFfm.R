
data(factorDataSetDjia5Yrs)

## test on full data set
fit.test <- fitFfm(data=factorDataSetDjia5Yrs, asset.var="TICKER", ret.var="RETURN",
                   date.var="DATE", exposure.vars=c("MKTCAP", "ENTVAL", "SIZE"),
                   z.score="crossSection",
                   addIntercept=TRUE)

expect_identical(class(fit.test), "ffm")

## On a single stock
test.data.aa <- test.data[which(test.data[, 'TICKER'] == 'AA'), ]

fit.test.aa <- fitFfm(data=test.data.aa, asset.var="TICKER", ret.var="EXC.RETURN", date.var="DATE",
                      exposure.vars=exposure.vars, lagExposures=TRUE, addIntercept=TRUE)

expect_error(class(fit.test.aa), "object 'fit.test.aa' not found")

#### TEST :: lm on data confirms data is fine. Issue is ####
lm.test.aa <- lm(EXC.RETURN ~ MKT.RF + SMB + HML, data = test.data.aa)

expect_identical(class(lm.test.aa), "lm")
