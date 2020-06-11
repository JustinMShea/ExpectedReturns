#
# Fundamental Factor Models in factorAnalytics
# By R. Douglas Martin
# R-Finance Conference, Chicago, May 19th, 2017
#
# Install factorAnalytics from Github
# library(devtools)
# install_github("avinashacharya/factorAnalytics", force =T)

# require(methods)
library(factorAnalytics)
library(lattice)

# require(methods)
# rm(list=ls())

# SECIION 2 FUNDAMENTAL FACTOR MODEL FITTING

# DJIA Data 22 Stocks
help(factorDataSetDjia5Yrs)
data("factorDataSetDjia5Yrs")
dataDjia5Yr = factorDataSetDjia5Yrs
names(dataDjia5Yr)
unique(dataDjia5Yr$TICKER)
unique(dataDjia5Yr$SECTOR)

# Time Series Plots of Exposures
# tickers = c("AA", "BAC", "IBM")
tickers = "BAC"
exposuresTseries(factorDataSetDjia5Yrs,tickers = tickers,plot.returns = T,
                 axis.cex = 0.8,plot.type="b")

# Fit FFM with Style Exposures Only
# fitDjia5Yr=fitFfm(dataDjia5Yr,addIntercept=T,asset.var="TICKER", ret.var="RETURN",
#                  date.var="DATE",exposure.vars= c("SIZE","P2B","EV2S"),z.score=T)

# Fit FFM with Style Exposures plus Sectors
fitDjia5Yr=fitFfm(dataDjia5Yr,addIntercept=T,asset.var="TICKER", ret.var="RETURN",
                  date.var="DATE",exposure.vars= c("SECTOR","SIZE","P2B","EV2S"),
                  z.score="crossSection")

cov2cor(fitDjia5Yr$g.cov)
names(summary(fitDjia5Yr))
length(summary(fitDjia5Yr)$sum.list)
summary(fitDjia5Yr)$sum.list[59]


fmRsq(fitDjia5Yr, rsqAdj = T, plt.type = 2, isPrint = F,lwd = .7,
		stripText.cex = .8,axis.cex=.8)

vif(fitDjia5Yr, isPlot = T, isPrint = F, lwd = .7,stripText.cex = .8,axis.cex=.8)

fmTstats(fitDjia5Yr,whichPlot="tStats",color="blue",lwd=.7,layout=c(3,4),
			stripText.cex = .8,axis.cex=.8)

fmTstats(fitDjia5Yr,whichPlot = "significantTstatsV", color = "blue",
			stripText.cex = .8,axis.cex=.8,layout=c(3,4))

# SECTION 3 PORTFOLIO EXPOSURES REPORTS

data(wtsDjiaGmvLo)
wtsDjia = wtsDjiaGmvLo
round(wtsDjia,2)


repExposures(fitDjia5Yr, wtsDjia, isPlot = FALSE, digits = 1,
			                   stripText.cex = .8, axis.cex=.8)

repExposures(fitDjia5Yr, wtsDjia, isPrint = F,isPlot = T, which = 3,
             add.grid=F, zeroLine=F, color='Cyan')

repExposures(fitDjia5Yr,wtsDjia,isPrint=F,isPlot=T,which=1,add.grid=F,
             zeroLine = T, color = 'Blue',stripText.cex = .8,axis.cex=.8)

repExposures(fitDjia5Yr, wtsDjia, isPrint = FALSE, isPlot = TRUE,
			which = 2,	notch = F, layout = c(3,3), color= "Cyan")


# SECTION 4 PORTFOLIO RETURNS REPORTS


repReturn(fitDjia5Yr, wtsDjia, isPlot = FALSE, digits = 2)

repReturn(fitDjia5Yr, wtsDjia, isPrint = FALSE, isPlot = TRUE, which = 1,
          add.grid = TRUE, scaleType = 'same',color = 'Blue',
			stripText.cex = .8,axis.cex=.8)

repReturn(fitDjia5Yr, wtsDjia, isPrint = FALSE, isPlot = TRUE, which = 2,
          add.grid = TRUE, zeroLine = T, color = "Blue",scaleType = 'same',
			stripText.cex = .8,axis.cex=.8)

repReturn(fitDjia5Yr, wtsDjia, isPrint = FALSE, isPlot = TRUE, which = 3,
          add.grid = TRUE, zeroLine = T, color = "Blue", scaleType = 'same',
			stripText.cex = .8,axis.cex=.8)

repReturn(fitDjia5Yr, wtsDjia, isPrint = FALSE, isPlot = TRUE, which = 4)


# SECTION 5 PORTFOLIO RISK REPORTS


# Fit FFM with Style Factors Only
fitDjia5YrIntStyle = fitFfm(data = dataDjia5Yr,
          exposure.vars = c("SIZE","P2B","EV2S"),
          date.var = "DATE",ret.var = "RETURN",asset.var = "TICKER",
          fit.method="WLS", z.score = "crossSection", addIntercept = T)

repRisk(fitDjia5YrIntStyle, wtsDjia, risk = "Sd", decomp = "FPCR",
		nrowPrint = 10,sliceby = "factor", isPrint = T, isPlot = T,
		layout = c(5,1),stripText.cex = .8,axis.cex=.8)

repRisk(fitDjia5YrIntStyle, wtsDjia, risk = "ES", decomp = "FPCR",
		nrowPrint = 10,sliceby = "factor", isPrint = F, isPlot = T,
		layout = c(5,1),stripText.cex = .8,axis.cex=.8)

repRisk(fitDjia5YrIntStyle, wtsDjia, risk = "ES", decomp = "FCR",
		nrowPrint = 10,sliceby = "factor", isPrint = F, isPlot = T,
		layout = c(5,1),stripText.cex = .8,axis.cex=.8)

repRisk(fitDjia5YrIntStyle, wtsDjia, risk = c("Sd","ES","VaR"),
		decomp = "FPCR",sliceby = "factor",isPrint = T,isPlot = TRUE,
		portfolio.only = T,stripText.cex = .8,axis.cex=.8)

repRisk(fitDjia5YrIntStyle, wtsDjia, risk = c("Sd","ES","VaR"),
        decomp = "FPCR",sliceby = "riskType",isPrint = T,isPlot = TRUE,
        portfolio.only = T,stripText.cex = .8,axis.cex=.8)


# SECTION 6 FFM FACTOR MODEL MONTE CARLO PORTFOLIO RISK


args(fmmcSemiParam)


# N = 30
exposure.vars <- c("P2B", "MKTCAP", "SECTOR")
fit.ffm=fitFfm(data=factorDataSetDjia5Yrs,asset.var="TICKER",
			ret.var="RETURN",date.var="DATE", exposure.vars=exposure.vars)

resid.par = fit.ffm$residuals
fmmcDat=fmmcSemiParam(B=1000,factor.ret=fit.ffm$factor.returns, 				beta=fit.ffm$beta,resid.par=resid.par,
				boot.method = "random",resid.dist = "empirical")
names(fmmcDat)

data = factorDataSetDjia5Yrs
djiaDat = tapply(data$RETURN,list(data$DATE,data$TICKER),I)
djiaRet = xts(djiaDat,as.yearmon(rownames(djiaDat)))

round(apply(djiaRet,2,mean)[1:10],3)
round(apply(fmmcDat$sim.fund.ret,2,mean)[1:10],3)

round(apply(djiaRet,2,sd)[1:10],3)
round(apply(fmmcDat$sim.fund.ret,2,sd)[1:10],3)

resid.mean = apply(B=1000, coredata(fit.ffm$residuals), 2, mean, na.rm=T)
resid.sd = matrix(sqrt(fit.ffm$resid.var))
resid.par = cbind(resid.mean, resid.sd)
fmmcDatNormal=fmmcSemiParam(factor.ret=fit.ffm$factor.returns, 			beta=fit.ffm$beta,resid.par=resid.par, boot.method = "random")

round(apply(djiaRet,2,mean)[1:10],3)
round(apply(fmmcDatNormal$sim.fund.ret,2,mean)[1:10],3)
round(apply(djiaRet,2,sd)[1:10],3)
round(apply(fmmcDatNormal$sim.fund.ret,2,sd)[1:10],3)


# SECTION 7 MARKET + INDUSTRY/SECTOR + COUNTRY MODELS


dat = factorDataSetDjia5Yrs
fitSec = fitFfm(dat, asset.var="TICKER", ret.var="RETURN",
              date.var="DATE", exposure.vars="SECTOR")
round(coef(summary(fitSec)$sum.list[[1]])[,1],3)
round(fitSec$factor.returns[1,],3)

fitSecInt = fitFfm(dat, asset.var="TICKER", ret.var="RETURN",
              date.var="DATE", exposure.vars="SECTOR",addIntercept=T)
round(coef(summary(fitSecInt)$sum.list[[1]])[,1],2)
round(fitSecInt$factor.returns[1,],2)
round(sum(fitSecInt$factor.returns[1,-1]),2)

# Country Incremental Components of Asset Returns
set.seed(10000)
Bind = cbind(rep(1,30),c(rep(1,10),rep(0,20)),c(rep(0,10),rep(1,10),rep(0,10)),
             c(rep(0,20),rep(1,10)))
cty1 = matrix(rep(c(0,1), 15))
cty2 =  matrix(rep(c(1,0), 15))
Bmic = cbind(Bind, cty1,cty2)
dimnames(Bmic)[[2]] = c("mkt","sec1","sec2","sec3", "cty1", "cty2")
r.add = rnorm(30,4,.2)
r.cty1 = rep(0,30)
r.cty2 = rep(0,30)
for(i in 1:30) {
  if(Bmic[i,"cty1"]==1)  {r.cty1[i] = r.add[i];r.cty2[i] = 0}
      else {r.cty1[i] = 0;r.cty2[i] = r.add[i] + 1}
}

# Asset Returns for Market+Industry+Country Model
mu = c(1,2,3)
sd = c(.2,.2,.2)
r = list()
r.mic = list()
fitMic = list()
fitMic1 = list()
for(i in 1:5){
set.seed(1099923+(i-1))
r[[i]]= c(rnorm(10,mu[1],sd[1]),rnorm(10,mu[2],sd[2]),
			rnorm(10,mu[3],sd[3]))
r.mic[[i]] = r[[i]] + r.cty1 + r.cty2
}

qqnorm(r.mic[[1]],main = "MIC Model Equity Returns for First Period",
       xlab="NORMAL QQ-PLOT",ylab="RETURNS")

Returns = unlist(r.mic)
COUNTRY = rep(rep(c("US", "India"), 15), 5)
SECTOR = rep(rep(c("SEC1", "SEC2", "SEC3"), each = 10),5)
TICKER = rep(c(LETTERS[1:26], paste0("A",LETTERS[1:4])),5)
DATE = rep(seq(as.Date("2000/1/1"),by = "month",length.out = 5),each = 30)
data.mic = data.frame("DATE"=as.character(DATE), TICKER, Returns,
						SECTOR, COUNTRY)
exposure.vars = c("SECTOR", "COUNTRY")
# There is an error below that I need to fix, Doug
# fit = fitFfm(data=data.mic, asset.var="TICKER", ret.var="Returns",
#              date.var="DATE", exposure.vars=exposure.vars,addIntercept = T)
#fit$factor.returns

