
data(factorDataSetDjia5Yrs)


## test on full data set
fit.test <- fitFfm(data=factorDataSetDjia5Yrs, asset.var="TICKER", ret.var="RETURN",
                   date.var="DATE", exposure.vars=c("MKTCAP", "ENTVAL", "SIZE"),
                   z.score="crossSection", addIntercept=TRUE)

expect_identical(class(fit.test), "ffm")


## On a single equity AA
test.data.aa <- factorDataSetDjia5Yrs[which(factorDataSetDjia5Yrs[, 'TICKER'] == 'AA'), ]

fit.test.aa <- fitFfm(data=test.data.aa, asset.var="TICKER", ret.var="RETURN",
                      date.var="DATE", exposure.vars=c("MKTCAP", "ENTVAL", "SIZE"),
                      z.score="crossSection", addIntercept=TRUE)

expect_error(class(fit.test.aa), "object 'fit.test.aa' not found")
 # lm on a single equity AA works fine ####
lm.test.aa <- lm(RETURN ~ MKTCAP + ENTVAL + SIZE, data = test.data.aa)

expect_identical(class(lm.test.aa), "lm")


## On two equities AA, BA
index <- factorDataSetDjia5Yrs$TICKER == 'AA' | factorDataSetDjia5Yrs$TICKER == 'BA'
test.data.aa.ba <- factorDataSetDjia5Yrs[index, ]

fit.test.aa.ba <- fitFfm(data=test.data.aa.ba, asset.var="TICKER", ret.var="RETURN",
                         date.var="DATE", exposure.vars=c("MKTCAP", "ENTVAL", "SIZE"),
                         z.score="crossSection", addIntercept=TRUE)

expect_identical(class(fit.test.aa.ba), "ffm")
