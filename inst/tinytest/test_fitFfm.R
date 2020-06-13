
data(factorDataSetDjia5Yrs)


## test on full data set
fit.test <- fitFfm(data=factorDataSetDjia5Yrs, asset.var="TICKER", ret.var="RETURN",
                   date.var="DATE", exposure.vars=c("MKTCAP", "ENTVAL", "SIZE"),
                   z.score="crossSection", addIntercept=TRUE)

expect_identical(class(fit.test), "ffm")


## On two equities AA, BA
index <- factorDataSetDjia5Yrs$TICKER == 'AA' | factorDataSetDjia5Yrs$TICKER == 'BA'
test.data.aa.ba <- factorDataSetDjia5Yrs[index, ]

fit.test.aa.ba <- fitFfm(data=test.data.aa.ba, asset.var="TICKER", ret.var="RETURN",
                         date.var="DATE", exposure.vars=c("MKTCAP", "ENTVAL", "SIZE"),
                         z.score="crossSection", addIntercept=TRUE)

expect_identical(class(fit.test.aa.ba), "ffm")
