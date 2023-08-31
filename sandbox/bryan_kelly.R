# Replication crisis paper

# Load fundamental_data from eod
load_fundamental_data = function(tickers) {
  fund_files = list.files()
  fund_files = fund_files[grep('fund',fund_files)]
  fund_files = fund_files[fund_files %in% tickers]
  fund_data = NULL
  for(fund in fund_files) { #FIXME
    # fund = fund_files[2]
    print(fund)
    tmp_fund_data = fread(fund)
    if(ncol(tmp_fund_data) == 2 | "General" %in% colnames(tmp_fund_data)) next()
    # Set shares
    for(i in c('commonStockSharesOutstanding')) tmp_fund_data[,ratio:=abs(get(i))/shift(abs(get(i)),1,type='lag') -1]
    tmp_fund_data[,commonStockSharesOutstanding:=fifelse(ratio > 1e3, abs(commonStockSharesOutstanding)/1e9,
                                                         abs(commonStockSharesOutstanding))]
    tmp_fund_data[,date:=as.IDate(V1)]
    # Shift date by 3months
    tmp_fund_data[,date:=as.IDate(offset(date,63,'QuantLib/UnitedStates'))]
    tmp_fund = tryCatch(rbind(fund_data, tmp_fund_data,fill=T), error = function(e) e)
    if(is(tmp_fund,'error')) next()
    fund_data = tmp_fund
  }
  fwrite(fund_data, '/home/cyril/TRADING/EOD/tmp_fund_data.csv')
  return(fund_data)
}

CorwinSchultz = function (x, width = nrow(x), method = "CS", na.rm = FALSE, trim = 0) {
  C1 <- lag(x[,3], 1)
  H1 <- lag(x[,1], 1)
  L1 <- lag(x[,2], 1)
  H2 <- x[,1]
  L2 <- x[,2]
  Gap <- pmax(0, C1 - H2) + pmin(0, C1 - L2)
  AH2 <- H2 + Gap
  AL2 <- L2 + Gap
  B <- bidask:::rsum(log(H2/L2)^2, width = 2, na.rm = na.rm)
  B[B < 0] <- 0
  G <- log(pmax(AH2, H1)/pmin(AL2, L1))^2
  k1 <- 4 * log(2)
  k2 <- sqrt(8/pi)
  A <- (sqrt(2 * B) - sqrt(B))/(3 - 2 * sqrt(2)) - sqrt(G/(3 - 2 * sqrt(2)))
  S <- 2 * (exp(A) - 1)/(1 + exp(A))
  cs <- cs2 <- NULL
  if ("CS" %in% method) {
    cs <- bidask:::rmean(S, width = width - 1, na.rm = na.rm, trim = trim)
    cs[cs < 0] <- 0
    cs = mean(cs)
  }
  return(cs)
}

daily_factors = function(tmp_ticker, lookbacks=c(21, 126, 252, 1260)) {
  tmp_ticker[,ret:=c(0,diff(log(abs(adjusted_close)))),by=ticker]
  tmp_ticker[,ret_exc:=ret - r]
  tmp_ticker[,mktref:=mktref - r]
  for(lookback in lookbacks) {
    #lookback = lookbacks[1]
    tmp_ticker[,paste0('mktvol_zd',lookback):=roll_sd(mktref,lookback,min_obs = 1),by=ticker]
    tmp_ticker[,paste0('rvol_zd',lookback):=roll_sd(ret,lookback,min_obs = 1),by=ticker]
    tmp_ticker[,paste0('rmax1_zd',lookback):=roll_max(ret,lookback,min_obs = 1),by=ticker]
    tmp_ticker[,paste0('rmax5_zd',lookback):=rollapplyr(ret,lookback,
                                                        function(x) mean(tail(sort(x),5),na.rm=T),partial=T),by=ticker]
    tmp_ticker[,paste0('rskew_zd',lookback):=rollapplyr(ret,lookback,skewness,partial=T),by=ticker]
    tmp_ticker[,paste0('prc_highprc_zd',lookback):=abs(adjusted_close) / roll_max(abs(adjusted_close),lookback, min_obs = 1),by=ticker]
    tmp_ticker[,paste0('ami_zd',lookback):=abs(ret) / (volume * abs(adjusted_close)), by=ticker]
    tmp_ticker[,paste0('beta_zd',lookback):=roll_lm(mktref,ret_exc,lookback,min_obs = 1)$coefficients[,2], by=ticker]
    tmp_ticker[,paste0('res',lookback):=ret_exc - get(paste0('beta_zd',lookback)) * mktref,by=ticker]
    tmp_ticker[,paste0('ivol_capm_zd',lookback):=roll_sd(get(paste0('res',lookback)),lookback,min_obs=1), by=ticker]
    tmp_ticker[,paste0('iskew_capm_zd',lookback):=rollapplyr(ret_exc - get(paste0('beta_zd',lookback)) * mktref,lookback,skewness,partial=T), by=ticker]
    tmp_ticker[,paste0('mktrf_dm',lookback):=mktref - roll_mean(mktref,lookback,min_obs=1), by=ticker]
    tmp_ticker[,paste0('coskew_zd',lookback):= mean((roll_mean(get(paste0('res',lookback)),lookback,min_obs=1) * get(paste0('mktrf_dm',lookback)))^2,na.rm=T) /
                 sqrt(roll_mean(get(paste0('res',lookback))^2,lookback,min_obs=1)) * get(paste0('mktrf_dm',lookback))^2,by=ticker]
    tmp_ticker[,paste0('betadown_zd',lookback):=roll_lm(ifelse(mktref < 0,mktref,NA),ifelse(mktref < 0,ret_exc,NA),lookback,min_obs=1)$coefficients[,2], by=ticker]
    tmp_ticker[,paste0('zero_trades_zd',lookback):=roll_sum(fifelse(volume != 0,0,1),lookback,min_obs=1), by=ticker]
    tmp_ticker[,paste0('turnover_zd',lookback):=roll_mean(volume/commonStockSharesOutstanding,lookback,min_obs=1), by=ticker]
    tmp_ticker[,paste0('turnover_var_zd',lookback):=roll_sd(volume/commonStockSharesOutstanding,lookback,min_obs=1)/ get(paste0('turnover_zd',lookback)), by=ticker]
    tmp_ticker[,paste0('dolvol_zd',lookback):=abs(volume * abs(adjusted_close)), by=ticker]
    tmp_ticker[,paste0('dolvol_var_zd',lookback):=roll_sd(get(paste0('dolvol_zd',lookback)),lookback,min_obs = 1) / get(paste0('dolvol_zd',lookback)), by=ticker]
    tmp_ticker[,paste0('corr_zd',lookback):=roll_cor(ret_exc,mktref,lookback,min_obs = 1) / get(paste0('dolvol_zd',lookback)), by=ticker]
  } 
  tmp_ticker[,betabab_1260:=(corr_zd1260*rvol_zd252)/mktvol_zd252, by=ticker]
  tmp_ticker[,rmax5_rvol21d:=(rmax5_zd21)/rvol_zd252, by=ticker]
  tmp_ticker[,bidaskhl21d:=frollapply(data.table(abs(high),abs(low),abs(close)), 21*3, function(x) {
    x = matrix(x,ncol=3,byrow=3)
    CorwinSchultz(x,na.rm = T)
  },align='right'),by=ticker]
  fwrite(tmp_ticker,'/home/cyril/TRADING/EOD/last_no_error_factors.csv')
  tmp_ticker
}

make_portfolios = function(fund_data_daily) {
  # FF3
  #fund_data_daily = fund_data_daily[month != '']
  #fund_data_daily[,date_string2:=seq.POSIXt(anytime(month[1]),by='day',length.out=length(bidaskhl21d)),by=c('ticker','date_string')]
  fund_data_daily[,shrout:=abs(commonStockSharesOutstanding/1e3)]
  fund_data_daily[,prc:=abs(adjusted_close)]
  fund_data_daily[,mve_c:=shrout * prc] 
  fund_data_daily[,size:=fifelse(is.infinite(mve_c) | is.na(mve_c)  | is.nan(mve_c),'Medium',
                                 fifelse(mve_c >= quantile(mve_c,0.7,na.rm=T),'Big',
                                         fifelse(mve_c <= quantile(mve_c,0.3,na.rm=T),'Small','Medium')))
                  ,by=date]
  fund_data_daily[,value_hml:=fifelse(is.infinite(be/mve_c) | is.na(be/mve_c) | is.nan(be/mve_c),'Neutral',
                                      fifelse((be/mve_c) >= quantile(be/mve_c,0.7,na.rm=T),'High',
                                              fifelse((be/mve_c) <= quantile(be/mve_c,0.3,na.rm=T),'Low','Neutral')))
                  ,by=date]
  
  fund_data_daily[,port.weights:=mve_c]
  fund_data_daily[,ff3:=paste0(size,value_hml)]
  ff3 = fund_data_daily[,list(Small=weighted.mean(ret[which(ff3 %in% c('SmallHigh','SmallNeutral','SmallLow'))],
                                                  w=port.weights[which(ff3 %in% c('SmallHigh','SmallNeutral','SmallLow'))],na.rm=T),
                              Big=weighted.mean(ret[which(ff3 %in% c('BigHigh','BigNeutral','BigLow'))],
                                                w=port.weights[which(ff3 %in% c('BigHigh','BigNeutral','BigLow'))],na.rm=T),
                              High=weighted.mean(ret[which(ff3 %in%  c('SmallHigh','BigHigh'))],
                                                 w=port.weights[which(ff3 %in%  c('SmallHigh','BigHigh'))],na.rm=T),
                              Low=weighted.mean(ret[which(ff3 %in%  c('SmallLow','BigLow'))],
                                                w=port.weights[which(ff3 %in%  c('SmallLow','BigLow'))],na.rm=T))
                        ,by=date]
  ff3[,SMB:=fifelse(is.na(Small)| is.infinite(Small),0,Small) - fifelse(is.na(Big)| is.infinite(Big),0,Big)]
  ff3[,HML:=fifelse(is.na(High)| is.infinite(High),0,High) - fifelse(is.na(Low)| is.infinite(Low),0,Low)]
  
  fund_data_daily = merge(fund_data_daily,ff3,by='date')
  
  # HXZ
  fund_data_daily[,size:=fifelse(is.infinite(mve_c) | is.na(mve_c)  | is.nan(mve_c),'Big',
                                 fifelse(mve_c >= quantile(mve_c,0.5,na.rm=T),'Big','Small'))
                  ,by=date]
  # INV
  fund_data_daily[,inv_factor:=fifelse(is.infinite(inv) | is.na(inv) | is.nan(inv),'NeutralInv',
                                       fifelse(inv >= quantile(inv,0.7,na.rm=T),'HighInv',
                                               fifelse(inv <= quantile(inv,0.3,na.rm=T),'LowInv','NeutralInv')))
                  ,by=date]
  
  # ROE
  fund_data_daily[,roe_factor:=fifelse(is.infinite(roe) | is.na(roe) | is.nan(roe),'NeutralRoe',
                                       fifelse(roe >= quantile(roe,0.7,na.rm=T),'HighRoe',
                                               fifelse(roe <= quantile(roe,0.3,na.rm=T),'LowRoe','NeutralRoe')))
                  ,by=date]
  fund_data_daily[,port.weights:=mve_c]
  fund_data_daily[,ff3:=paste0(size,inv_factor,roe_factor)]
  smalls = unique(fund_data_daily$ff3)[grep('Small',unique(fund_data_daily$ff3))]
  bigs = unique(fund_data_daily$ff3)[grep('Big',unique(fund_data_daily$ff3))]
  highinv = unique(fund_data_daily$ff3)[grep('HighInv',unique(fund_data_daily$ff3))]
  lowinv = unique(fund_data_daily$ff3)[grep('LowInv',unique(fund_data_daily$ff3))]
  highroe = unique(fund_data_daily$ff3)[grep('HighRoe',unique(fund_data_daily$ff3))]
  lowroe = unique(fund_data_daily$ff3)[grep('LowRoe',unique(fund_data_daily$ff3))]
  
  hxz = fund_data_daily[,list(Small=weighted.mean(ret[which(ff3 %in% smalls)],
                                                  w=port.weights[which(ff3 %in% smalls)],na.rm=T),
                              Big=weighted.mean(ret[which(ff3 %in% bigs)],
                                                w=port.weights[which(ff3 %in% bigs)],na.rm=T),
                              HighInv=weighted.mean(ret[which(ff3 %in% highinv)],
                                                    w=port.weights[which(ff3 %in% highinv)],na.rm=T),
                              LowInv=weighted.mean(ret[which(ff3 %in%  lowinv)],
                                                   w=port.weights[which(ff3 %in%  lowinv)],na.rm=T),
                              HighRoe=weighted.mean(ret[which(ff3 %in%  highroe)],
                                                    w=port.weights[which(ff3 %in%  highroe)],na.rm=T),
                              LowRoe=weighted.mean(ret[which(ff3 %in%  lowroe)],
                                                   w=port.weights[which(ff3 %in%  lowroe)],na.rm=T))
                        ,by=date]
  hxz[,SB:=fifelse(is.na(Small)| is.infinite(Small),0,Small) - fifelse(is.na(Big)| is.infinite(Big),0,Big)]
  hxz[,INV:=fifelse(is.na(HighInv)| is.infinite(HighInv),0,HighInv) - fifelse(is.na(LowInv)| is.infinite(LowInv),0,LowInv)]
  hxz[,ROE:=fifelse(is.na(HighRoe)| is.infinite(HighRoe),0,HighRoe) - fifelse(is.na(LowRoe)| is.infinite(LowRoe),0,LowRoe)]
  fund_data_daily = merge(fund_data_daily,hxz,by='date')
  
  return(fund_data_daily)
}

get_ff_and_hxz_factors = function(ticker_data_daily,lookbacks=c(21, 126, 252, 1260/3)) {
  ticker_data_daily = make_portfolios(ticker_data_daily)
  for(lookback in lookbacks) {
    #lookback = lookbacks[1]
    f = function(x,y,lookback) {
      lm = roll_lm(x,y,lookback,min_obs=1)$coefficients
      preds = lm[,1] + lm[,2] * x[,1] + lm[,3] * x[,2] + lm[,4] * x[,3]
      res = y - preds
      list(roll_sd(res,lookback,min_obs=1),rollapplyr(res,lookback,skewness,partial=T))
    }
    ticker_data_daily[,c(paste0('ivol_ff3_zd',lookback),paste0('iskew_ff3_zd',lookback)):=f(cbind(mktref,SMB,HML),ret_exc,lookback),by=ticker]
    f = function(x,y,lookback) {
      lm = roll_lm(x,y,lookback,min_obs=1)$coefficients
      preds = lm[,1] + lm[,2] * x[,1] + lm[,3] * x[,2] + lm[,4] * x[,3] + lm[,5] * x[,4]
      res = y - preds
      list(roll_sd(res,lookback,min_obs=1),rollapplyr(res,lookback,skewness,partial=T))
    }
    ticker_data_daily[,c(paste0('ivol_hxz_zd',lookback),paste0('iskew_hxz_zd',lookback)):=f(cbind(mktref,SB,INV,ROE),ret_exc,lookback),by=ticker]
  }
  fwrite(ticker_data_daily, '/home/cyril/TRADING/EOD/tmp_data_daily.csv')
  return(ticker_data_daily)
}

repeat.before = function(x) {   # repeats the last non NA value. Keeps leading NA
  ind = which(x != 0)      # get positions of nonmissing values
  if(x[1] == 0 | is.na(x))             # if it begins with a missing, add the 
    ind = c(1,ind)        # first position to the indices
  rep(x[ind], times = diff(   # repeat the values at these indices
    c(ind, length(x) + 1) )) # diffing the indices + length yields how often 
}                               # they need to be repeated

repeat.last = function(x, forward = TRUE, maxgap = Inf, na.rm = FALSE) {
  if (!forward) x = rev(x)           # reverse x twice if carrying backward
  ind = which(!is.na(x))             # get positions of nonmissing values
  if (is.na(x[1]) && !na.rm)         # if it begins with NA
    ind = c(1,ind)                 # add first pos
  rep_times = diff(                  # diffing the indices + length yields how often
    c(ind, length(x) + 1) )          # they need to be repeated
  if (maxgap < Inf) {
    exceed = rep_times - 1 > maxgap  # exceeding maxgap
    if (any(exceed)) {               # any exceed?
      ind = sort(c(ind[exceed] + 1, ind))      # add NA in gaps
      rep_times = diff(c(ind, length(x) + 1) ) # diff again
    }
  }
  x = rep(x[ind], times = rep_times) # repeat the values at these indices
  if (!forward) x = rev(x)           # second reversion
  x
}
# Takes 1hour with 20 threads
load_daily_data_fast = function(fund_data) {
  # FACTORS NECESSARY FOR HXZ
  # FIXME
  fund_data[,commonStockSharesOutstanding:=abs(repeat.before(commonStockSharesOutstanding)),by=ticker]
  fund_data[,commonStockSharesOutstanding:=abs(repeat.last(commonStockSharesOutstanding)),by=ticker]
  fund_data[,inv:=inventory]
  fund_data[,nix:=netIncome]
  fund_data[,at:=totalAssets]
  fund_data[,roe:=(nix)/at,by=ticker]
  fund_data[,txditc:=abs(fifelse(!is.finite(deferredLongTermLiab),0,deferredLongTermLiab))]
  fund_data[,pstk:=abs(fifelse(is.finite(preferredStockTotalEquity),0,preferredStockTotalEquity))]
  fund_data[,seq:=abs(totalStockholderEquity)]
  fund_data[,be:=abs(seq+txditc-pstk)]
  # CAPM
  sp500 = fread('/home/cyril/TRADING/EOD/data/INDX/GSPC.INDX.csv')
  r <- fread('/home/cyril/TRADING/EOD/data/INDX/US1M.INDX.csv')
  names(r) = tolower(names(r))
  names(sp500) = tolower(names(sp500))
  r = r[,c('date','adjusted_close'),with=F]
  r[,r:=adjusted_close/1000]
  r[,adjusted_close:=NULL]
  sp500[,V1:=NULL]
  colnames(sp500)[2:length(colnames(sp500))] = paste0('sp',colnames(sp500)[2:length(colnames(sp500))])
  market_vars = merge(sp500,r, by='date')
  market_vars[,mktref:=(spadjusted_close/shift(spadjusted_close,1,type='lag',fill=NA) -1)- r]
  
  # Grid daily tickers
  grid.param <- expand.grid(sort(unique(fund_data$ticker)))
  
  fe <- foreach(param = iter(grid.param, by = "row"), 
                .verbose = TRUE, .errorhandling = "pass",  
                .multicombine = TRUE, .maxcombine = max(2, nrow(grid.param)),
                .export=c(""))
  fe$args <- fe$args[1]
  fe$argnames <- fe$argnames[1]
  
  # Collect daily factors   
  results <- fe %dopar% {  
    symbol = as.character(param[1])
    #symbol = sort(unique(fund_data$ticker))[1]
    print(symbol)
    # FIXME: path
    tmp_ticker = fread(paste0('/home/cyril/TRADING/EOD/data/US/',symbol,'.csv'))
    if(ncol(tmp_ticker) == 2) return(NULL)
    tmp_fund_data = fund_data[ticker == symbol]
    if(nrow(tmp_fund_data) < 2) return(NULL)
    tmp_ticker[,V1:=NULL]
    names(tmp_ticker) = tolower(names(tmp_ticker))
    tmp_ticker = merge(tmp_ticker,market_vars,by='date',all=T)
    tmp_ticker[,oracle_lag_date:=as.IDate(offset(date,-1,'QuantLib/UnitedStates'))]
    tmp_ticker[,actual_lag_date:=shift(date,1,type='lag',fill=NA)]
    tmp_ticker = tmp_ticker[actual_lag_date == oracle_lag_date]
    for(i in names(market_vars)[-which(names(market_vars)=='date')]) 
      tmp_ticker[,paste0(i):=na.locf0(get(paste0(i)))]
    
    # tmp_ticker[,month:=format(date, '%Y-%m')]
    # tmp_fund_data[,month:=format(fastPOSIXct(date_string,tz='UTC'), '%Y-%m')]
    tmp_ticker = merge(tmp_ticker,tmp_fund_data[,c('commonStockSharesOutstanding','be','roe','inv','date')],
                       by='date',all=T)
    tmp_ticker = tmp_ticker[order(date)]
    tmp_ticker[,oracle_lag_date:=as.IDate(offset(date,-1,'QuantLib/UnitedStates'))]
    tmp_ticker[,actual_lag_date:=shift(date,1,type='lag',fill=NA)]
    tmp_ticker = tmp_ticker[actual_lag_date == oracle_lag_date]
    for(i in c('commonStockSharesOutstanding','be','roe','inv')) 
      tmp_ticker[,paste0(i):=na.locf0(get(paste0(i)))]
    tmp_ticker = tmp_ticker[complete.cases(open)]
    # Check if it's following month
    # tmp_ticker = tmp_ticker[,diff_time:=c(0,diff(anytime(tmp_ticker$month))/(24*60/3*60/3*30))]
    # whi = which(tmp_ticker$diff_time > 1.5)
    #if(length(whi)) tmp_ticker = tmp_ticker[(whi[length(whi)]+1):nrow(tmp_ticker)]
    # Create daily factors
    tmp_ticker[,ticker:=symbol]
    tmp_ticker = daily_factors(tmp_ticker)
    # Join with monthly endpoints
    tmp_ticker_monthly = copy(tmp_ticker) 
    setcolorder(tmp_ticker_monthly,c(which(names(tmp_ticker_monthly)=='date'),
                                     which(names(tmp_ticker_monthly)=='ticker'), 
                                      (1:ncol(tmp_ticker_monthly))[-which(names(tmp_ticker_monthly)%in%
                                                                          c('date','ticker'))]))
    tmp_ticker_monthly[,month:=format(date, '%Y-%m')]
    tmp_ticker_monthly = tmp_ticker_monthly[order(date)]
    tmp_ticker_monthly = tmp_ticker_monthly[,.SD[date == max(date)],by=month]
    tmp_ticker_monthly = tmp_ticker_monthly[day(date)>= 25]
    # tmp_ticker_monthly = as.xts.data.table(tmp_ticker_monthly)
    # tmp_ticker_monthly = as.data.table(tmp_ticker_monthly)[endpoints(tmp_ticker_monthly)]
    # tmp_ticker_monthly[,ticker:=symbol]
    # tmp_ticker_monthly[,month:=format(round_date(index + days(4),'month') -1, '%Y-%m')]
    #ticker_data_monthly = rbind(ticker_data_monthly,tmp_ticker_monthly)
    #ticker_data_daily = rbind(ticker_data_daily,tmp_ticker)
    return(list(monthly=tmp_ticker_monthly,daily=tmp_ticker))
  }
  saveRDS(results, '/home/cyril/TRADING/EOD/tmp_results.rds')
  # Retrieve results and remove nulls
  whi = which(sapply(results,is.null))
  if(length(whi)) results =results[-whi]
  ticker_data_monthly = do.call(rbind,lapply(results,function(x) x$monthly))
  ticker_data_daily = do.call(rbind,lapply(results,function(x) x$daily))
  
  # Save file
  #fund_data[,month:=format(date, '%Y-%m')]
  fund_data_monthly = merge(fund_data[,-c('commonStockSharesOutstanding','be','roe','inv'),with=F],
                            ticker_data_monthly,by=c('date','ticker'),all=T)
  for(i in names(fund_data)[-which(names(fund_data ) %in% c('date','commonStockSharesOutstanding','be','roe','inv'))]) 
     fund_data_monthly[,paste0(i):=na.locf0(get(i)),by=ticker]
  
  # Get latest date of the month
  fund_data_monthly = fund_data_monthly[date %in% ticker_data_monthly$date]
  # [,month:=format(date, '%Y-%m')]
  # fund_data_monthly = fund_data_monthly[order(date)]
  # fund_data_monthly = fund_data_monthly[,.SD[date == last(date)],by=month]
  # fund_data_monthly = 
  
  # FIXME: from here test Get FF and HXZ daily factors 
  ticker_data_daily = get_ff_and_hxz_factors(ticker_data_daily)
  fwrite(ticker_data_daily, '/home/cyril/TRADING/EOD/ticker_data_daily.csv')
  #ticker_data_daily_xts = as.xts.data.table(ticker_data_dail y)
  #ticker_data_daily = ticker_data_daily[endpoints(ticker_data_daily_xts)]
  for(i in names(ticker_data_daily)[sapply(ticker_data_daily,is.numeric)]) 
    ticker_data_daily[,paste0(i):=na.locf0(get(i)),by=ticker]
  #ticker_data_daily = ticker_data_daily[order(date), .SD[which.max(date)], by = c('month','ticker')] 
  
  cols_to_keep = names(ticker_data_daily)[!names(ticker_data_daily) %in% names(ticker_data_monthly) ]
  all_fund_data = merge(fund_data_monthly,ticker_data_daily[,c('date','ticker', cols_to_keep),with=F],
                        by=c('date','ticker'),all=T)
  all_fund_data = all_fund_data[date %in% ticker_data_monthly$date]
  # all_fund_data[,diff(date),by=ticker]
  fwrite(all_fund_data, '/home/cyril/TRADING/EOD/monthly_data.csv')
  return(all_fund_data)
}

get_accounting_factors = function(fund_data) {
  #fund_data = copy(ref)
  #all_factors = copy(fund_data)
  num_cols = names(fund_data)[which(sapply(fund_data,is.numeric)==T)]
  for(col in num_cols) set(fund_data,i=which(is.na(fund_data[[col]])),j=col,value=0)
  fund_data[,size_grp:=fifelse(mve_c > quantile(mve_c,0.8,na.rm=T),'MEGA',
                               fifelse(mve_c > quantile(mve_c,0.5,na.rm=T),'LARGE',
                                       fifelse(mve_c > quantile(mve_c,0.2,na.rm=T),'SMALL','MICRO')))
            ,by=date]
  fund_data[,act:=totalCurrentAssets]
  fund_data[,dividendsPaid:=abs(dividendsPaid)]
  fund_data[,commonStockSharesOutstanding:=abs(commonStockSharesOutstanding)]
  fund_data[,dividend_per_share:=dividendsPaid/commonStockSharesOutstanding]
  fund_data[,dividend_paid_preferred:=dividend_per_share*preferredStockTotalEquity]
  fund_data[,change_shortTermDebt:=c(0,diff(shortTermDebt)),by=ticker]
  fund_data[,operatingIncome_bef_dep:=operatingIncome - depreciation]
  fund_data[,eps_not_ei:=ebit/commonStockSharesOutstanding]
  fund_data[,common:=commonStockSharesOutstanding]
  fund_data[,sale:=totalRevenue]
  fund_data[,cogs:=costOfRevenue]
  fund_data[,gp:=grossProfit]
  fund_data[,xsga:=sellingAndMarketingExpenses]
  fund_data[,xad:=0]
  fund_data[,xrd:=researchDevelopment]
  fund_data[,xlr:=0]
  fund_data[,spi:=0]
  fund_data[,dp:=depreciationAndAmortization]
  fund_data[,int:=interestExpense]
  fund_data[,xint:=interestExpense]
  fund_data[,op:=ebitda+xrd]
  fund_data[,ope:=ebitda-xint]
  # Balance Sheet Fundamental to Market Enterprise Value
  fund_data[,me:=abs(commonStockSharesOutstanding)*adjusted_close]
  fund_data[,netdebt:=netDebt]
  fund_data[,mev:=me+netdebt]
  fund_data[,txditc:=deferredLongTermLiab]
  fund_data[,pstk:=preferredStockTotalEquity]
  fund_data[,seq:=totalStockholderEquity]
  fund_data[,be:=abs(seq+txditc-pstk)]
  fund_data[,be_mev:=be / mev]
  fund_data[,opex:=totalOperatingExpenses]
  fund_data[,pi:=ebit-xint+spi]
  fund_data[,tax:=incomeTaxExpense]
  fund_data[,xido:=extraordinaryItems+discontinuedOperations]
  fund_data[,ni:=netIncome + xido]
  fund_data[,nix:=netIncome]
  fund_data[,fi:=ni+xint]
  fund_data[,dvc:=dividendsPaid]
  fund_data[,div:=dividendsPaid]
  fund_data[,ni_qtr:=ni]
  fund_data[,sale_qtr:=sale]
  fund_data[,capx:=capitalExpenditures]
  fund_data[,capx_sale:=capx/sale]
  fund_data[,fcf:=freeCashFlow]
  fund_data[,eqbb:=salePurchaseOfStock] 
  fund_data[,eqis:=salePurchaseOfStock]
  fund_data[,eqnetis:=salePurchaseOfStock]
  fund_data[,eqpo:=div+eqbb] 
  fund_data[,eqnpo:=div-eqnetis]
  fund_data[,dstnetis:=shortTermDebt+shortLongTermDebt] 
  fund_data[,dltnetis:=longTermDebt] 
  fund_data[,dbnetis:=netDebt]
  fund_data[,netis:=eqnetis+dbnetis]
  fund_data[,fincf:=totalCashFromFinancingActivities]
  # Balance Sheet - Assets
  fund_data[,at:=totalAssets]
  fund_data[,ca:=totalCurrentAssets]
  fund_data[,rec:=netReceivables]
  fund_data[,cash:=cash]
  fund_data[,inv:=inventory]
  fund_data[,nca:=nonCurrentAssetsTotal]
  fund_data[,intan:=intangibleAssets]
  fund_data[,ivao:=investments]
  fund_data[,ppeg:=propertyPlantAndEquipmentGross]
  fund_data[,ppen:=propertyPlantEquipment]
  # Balance Sheet - Liabilities
  fund_data[,lt:=totalLiab]
  fund_data[,cl:=totalCurrentLiabilities]
  fund_data[,ap:=accountsPayable]
  fund_data[,debtst:=shortTermDebt]
  fund_data[,txp:=incomeTaxExpense]
  # Balance Sheet - Financing
  fund_data[,debtlt:=longTermDebt]
  fund_data[,debt:=debtlt+debtst]
  fund_data[,ncl:=nonCurrentLiabilitiesTotal]
  fund_data[,bev:=seq+netDebt+temporaryEquityRedeemableNoncontrollingInterests]
  # Balance Sheet - Summary
  fund_data[,nwc:=ca - cl]
  fund_data[,coa:=ca - cash]
  fund_data[,col:=cl - shortTermDebt]
  fund_data[,cowc:=coa - col]
  fund_data[,ncoa:=at-ca-ivao]
  fund_data[,ncol:=lt-cl-longTermDebt]
  fund_data[,nncoa:=ncoa - ncol]
  fund_data[,fna:=shortTermInvestments+ivao]
  fund_data[,fnl:=debt+pstk]
  fund_data[,nfna:=fna-fnl]
  fund_data[,oa:=coa+ncoa]
  fund_data[,ol:=col+ncol]
  fund_data[,noa:=oa-ol]
  fund_data[,lnoa:=propertyPlantEquipment+intangibleAssets+otherAssets+otherLiab+depreciationAndAmortization]
  fund_data[,caliq:=ca-inventory]
  fund_data[,ppeinv:=propertyPlantAndEquipmentGross+inventory]
  fund_data[,aliq:=cash+0.75*coa+0.5*(at-ca-intangibleAssets)]
  # Market Based
  fund_data[,mat:=at+be+mev]
  # Accruals
  fund_data[,oacc:=ni-totalCashFromOperatingActivities]
  # FIXME: double check
  fund_data[,tacc:=oacc + (nfna/shift(nfna,12/3,type='lag') -1),by=ticker]
  fund_data[,gp_gr1a:=(gp - shift(gp,12/3,type = 'lag')) /at,by=ticker]
  fund_data[,ocf:=totalCashFromOperatingActivities]
  fund_data[,ocf_qtr:=totalCashFromOperatingActivities]
  fund_data[,ocf_gr1a:=(ocf - shift(ocf,12/3,type = 'lag')) /at,by=ticker]
  fund_data[,cop:=ebitda+researchDevelopment-oacc]
  # Others
  fund_data[,emp:=FullTimeEmployees]
  
  # Accounting characteristics
  # Growth percentage
  fund_data[,at_gr1:=at / shift(at,12/3,type = 'lag') -1,by=ticker]
  fund_data[,sale_gr1:=sale / shift(sale,12/3,type = 'lag') -1,by=ticker]
  fund_data[,ca_gr1:=ca / shift(ca,12/3,type = 'lag') -1,by=ticker]
  fund_data[,nca_gr1:=nca / shift(nca,12/3,type = 'lag') -1,by=ticker]
  fund_data[,lt_gr1:=lt / shift(lt,12/3,type = 'lag') -1,by=ticker]
  fund_data[,cl_gr1:=cl / shift(cl,12/3,type = 'lag') -1,by=ticker]
  fund_data[,ncl_gr1:=ncl / shift(ncl,12/3,type = 'lag') -1,by=ticker]
  fund_data[,be_gr1:=be / shift(be,12/3,type = 'lag') -1,by=ticker]
  fund_data[,pstk_gr1:=pstk / shift(pstk,12/3,type = 'lag') -1,by=ticker]
  fund_data[,debt_gr1:=debt / shift(debt,12/3,type = 'lag') -1,by=ticker]
  fund_data[,cogs_gr1:=cogs / shift(cogs,12/3,type = 'lag') -1,by=ticker]
  fund_data[,xsga_gr1:=xsga / shift(xsga,12/3,type = 'lag') -1,by=ticker]
  fund_data[,opex_gr1:=opex / shift(opex,12/3,type = 'lag') -1,by=ticker]
  fund_data[,at_gr3:=at / shift(at,36/3,type = 'lag') -1,by=ticker]
  fund_data[,sale_gr3:=sale / shift(sale,36/3,type = 'lag') -1,by=ticker]
  fund_data[,ca_gr3:=ca / shift(ca,36/3,type = 'lag') -1,by=ticker]
  fund_data[,nca_gr3:=nca / shift(nca,36/3,type = 'lag') -1,by=ticker]
  fund_data[,lt_gr3:=lt / shift(lt,36/3,type = 'lag') -1,by=ticker]
  fund_data[,cl_gr3:=cl / shift(cl,36/3,type = 'lag') -1,by=ticker]
  fund_data[,ncl_gr3:=ncl / shift(ncl,36/3,type = 'lag') -1,by=ticker]
  fund_data[,be_gr3:=be / shift(be,36/3,type = 'lag') -1,by=ticker]
  fund_data[,pstk_gr3:=pstk / shift(pstk,36/3,type = 'lag') -1,by=ticker]
  fund_data[,debt_gr3:=debt / shift(debt,36/3,type = 'lag') -1,by=ticker]
  fund_data[,cogs_gr3:=cogs / shift(cogs,36/3,type = 'lag') -1,by=ticker]
  fund_data[,xsga_gr3:=xsga / shift(xsga,36/3,type = 'lag') -1,by=ticker]
  fund_data[,opex_gr3:=opex / shift(opex,36/3,type = 'lag') -1,by=ticker]
  # Growth percentage - Changed Scaled by Total Assets
  fund_data[,gp_gr1a:=(gp - shift(gp,12/3,type = 'lag')) /at,by=ticker]
  fund_data[,ocf_gr1a:=(ocf - shift(ocf,12/3,type = 'lag')) /at,by=ticker]
  fund_data[,cash_gr1a:=(cash - shift(cash,12/3,type = 'lag')) /at,by=ticker]
  fund_data[,inv_gr1a:=(inv - shift(inv,12/3,type = 'lag')) /at,by=ticker]
  fund_data[,rec_gr1a:=(rec - shift(rec,12/3,type = 'lag')) /at,by=ticker]
  fund_data[,ppeg_gr1a:=(ppeg - shift(ppeg,12/3,type = 'lag')) /at,by=ticker]
  fund_data[,lti_gr1a:=(ivao - shift(ivao,12/3,type = 'lag')) /at,by=ticker]
  fund_data[,intan_gr1a:=(intan - shift(intan,12/3,type = 'lag')) /at,by=ticker]
  fund_data[,debtst_gr1a:=(debtst - shift(debtst,12/3,type = 'lag')) /at,by=ticker]
  fund_data[,ap_gr1a:=(ap - shift(ap,12/3,type = 'lag')) /at,by=ticker]
  fund_data[,txp_gr1a:=(txp - shift(txp,12/3,type = 'lag')) /at,by=ticker]
  fund_data[,debtlt_gr1a:=(debtlt - shift(debtlt,12/3,type = 'lag')) /at,by=ticker]
  fund_data[,txditc_gr1a:=(txditc - shift(txditc,12/3,type = 'lag')) /at,by=ticker]
  fund_data[,coa_gr1a:=(coa - shift(coa,12/3,type = 'lag')) /at,by=ticker]
  fund_data[,col_gr1a:=(col - shift(col,12/3,type = 'lag')) /at,by=ticker]
  fund_data[,cowc_gr1a:=(cowc - shift(cowc,12/3,type = 'lag')) /at,by=ticker]
  fund_data[,ncoa_gr1a:=(ncoa - shift(ncoa,12/3,type = 'lag')) /at,by=ticker]
  fund_data[,ncol_gr1a:=(ncol - shift(ncol,12/3,type = 'lag')) /at,by=ticker]
  fund_data[,nncoa_gr1a:=(nncoa - shift(nncoa,12/3,type = 'lag')) /at,by=ticker]
  fund_data[,oa_gr1a:=(oa - shift(oa,12/3,type = 'lag')) /at,by=ticker]
  fund_data[,ol_gr1a:=(ol - shift(ol,12/3,type = 'lag')) /at,by=ticker]
  fund_data[,noa_gr1a:=(noa - shift(noa,12/3,type = 'lag')) /at,by=ticker]
  fund_data[,fna_gr1a:=(fna - shift(fna,12/3,type = 'lag')) /at,by=ticker]
  fund_data[,fnl_gr1a:=(fnl - shift(fnl,12/3,type = 'lag')) /at,by=ticker]
  fund_data[,nfna_gr1a:=(nfna - shift(nfna,12/3,type = 'lag')) /at,by=ticker]
  fund_data[,ebitda_gr1a:=(ebitda - shift(ebitda,12/3,type = 'lag')) /at,by=ticker]
  fund_data[,ebit_gr1a:=(ebit - shift(ebit,12/3,type = 'lag')) /at,by=ticker]
  fund_data[,ope_gr1a:=(ope - shift(ope,12/3,type = 'lag')) /at,by=ticker]
  fund_data[,ni_gr1a:=(ni - shift(ni,12/3,type = 'lag')) /at,by=ticker]
  fund_data[,fna_gr1a:=(fna - shift(ni,12/3,type = 'lag')) /at,by=ticker]
  fund_data[,dp_gr1a:=(dp - shift(dp,12/3,type = 'lag')) /at,by=ticker]
  fund_data[,fcf_gr1a:=(fcf - shift(fcf,12/3,type = 'lag')) /at,by=ticker]
  fund_data[,nwc_gr1a:=(nwc - shift(nwc,12/3,type = 'lag')) /at,by=ticker]
  fund_data[,nix_gr1a:=(nix - shift(nix,12/3,type = 'lag')) /at,by=ticker]
  fund_data[,eqnetis_gr1a:=(eqnetis - shift(eqnetis,12/3,type = 'lag')) /at,by=ticker]
  fund_data[,dltnetis_gr1a:=(dltnetis - shift(dltnetis,12/3,type = 'lag')) /at,by=ticker]
  fund_data[,dstnetis_gr1a:=(dstnetis - shift(dstnetis,12/3,type = 'lag')) /at,by=ticker]
  fund_data[,dbnetis_gr1a:=(dbnetis - shift(dbnetis,12/3,type = 'lag')) /at,by=ticker]
  fund_data[,netis_gr1a:=(netis - shift(netis,12/3,type = 'lag')) /at,by=ticker]
  fund_data[,fincf_gr1a:=(fincf - shift(fincf,12/3,type = 'lag')) /at,by=ticker]
  fund_data[,eqnpo_gr1a:=(eqnpo - shift(eqnpo,12/3,type = 'lag')) /at,by=ticker]
  fund_data[,tax_gr1a:=(tax - shift(tax,12/3,type = 'lag')) /at,by=ticker]
  fund_data[,div_gr1a:=(div - shift(div,12/3,type = 'lag')) /at,by=ticker]
  fund_data[,eqbb_gr1a:=(eqbb - shift(eqbb,12/3,type = 'lag')) /at,by=ticker]
  fund_data[,eqis_gr1a:=(eqis - shift(eqis,12/3,type = 'lag')) /at,by=ticker]
  fund_data[,eqpo_gr1a:=(eqpo - shift(eqpo,12/3,type = 'lag')) /at,by=ticker]
  fund_data[,capx_gr1a:=(capx - shift(capx,12/3,type = 'lag')) /at,by=ticker]
  # 36/3months
  fund_data[,gp_gr3a:=(gp - shift(gp,36/3,type = 'lag')) /at,by=ticker]
  fund_data[,ocf_gr3a:=(ocf - shift(ocf,36/3,type = 'lag')) /at,by=ticker]
  fund_data[,cash_gr3a:=(cash - shift(cash,36/3,type = 'lag')) /at,by=ticker]
  fund_data[,inv_gr3a:=(inv - shift(inv,36/3,type = 'lag')) /at,by=ticker]
  fund_data[,rec_gr3a:=(rec - shift(rec,36/3,type = 'lag')) /at,by=ticker]
  fund_data[,ppeg_gr3a:=(ppeg - shift(ppeg,36/3,type = 'lag')) /at,by=ticker]
  fund_data[,lti_gr3a:=(ivao - shift(ivao,36/3,type = 'lag')) /at,by=ticker]
  fund_data[,intan_gr3a:=(intan - shift(intan,36/3,type = 'lag')) /at,by=ticker]
  fund_data[,debtst_gr3a:=(debtst - shift(debtst,36/3,type = 'lag')) /at,by=ticker]
  fund_data[,ap_gr3a:=(ap - shift(ap,36/3,type = 'lag')) /at,by=ticker]
  fund_data[,txp_gr3a:=(txp - shift(txp,36/3,type = 'lag')) /at,by=ticker]
  fund_data[,debtlt_gr3a:=(debtlt - shift(debtlt,36/3,type = 'lag')) /at,by=ticker]
  fund_data[,txditc_gr3a:=(txditc - shift(txditc,36/3,type = 'lag')) /at,by=ticker]
  fund_data[,coa_gr3a:=(coa - shift(coa,36/3,type = 'lag')) /at,by=ticker]
  fund_data[,col_gr3a:=(col - shift(col,36/3,type = 'lag')) /at,by=ticker]
  fund_data[,cowc_gr3a:=(cowc - shift(cowc,36/3,type = 'lag')) /at,by=ticker]
  fund_data[,ncoa_gr3a:=(ncoa - shift(ncoa,36/3,type = 'lag')) /at,by=ticker]
  fund_data[,ncol_gr3a:=(ncol - shift(ncol,36/3,type = 'lag')) /at,by=ticker]
  fund_data[,nncoa_gr3a:=(nncoa - shift(nncoa,36/3,type = 'lag')) /at,by=ticker]
  fund_data[,oa_gr3a:=(oa - shift(oa,36/3,type = 'lag')) /at,by=ticker]
  fund_data[,ol_gr3a:=(ol - shift(ol,36/3,type = 'lag')) /at,by=ticker]
  fund_data[,noa_gr3a:=(noa - shift(noa,36/3,type = 'lag')) /at,by=ticker]
  fund_data[,fna_gr3a:=(fna - shift(fna,36/3,type = 'lag')) /at,by=ticker]
  fund_data[,fnl_gr3a:=(fnl - shift(fnl,36/3,type = 'lag')) /at,by=ticker]
  fund_data[,nfna_gr3a:=(nfna - shift(nfna,36/3,type = 'lag')) /at,by=ticker]
  fund_data[,ebitda_gr3a:=(ebitda - shift(ebitda,36/3,type = 'lag')) /at,by=ticker]
  fund_data[,ebit_gr3a:=(ebit - shift(ebit,36/3,type = 'lag')) /at,by=ticker]
  fund_data[,ope_gr3a:=(ope - shift(ope,36/3,type = 'lag')) /at,by=ticker]
  fund_data[,ni_gr3a:=(ni - shift(ni,36/3,type = 'lag')) /at,by=ticker]
  fund_data[,fna_gr3a:=(fna - shift(ni,36/3,type = 'lag')) /at,by=ticker]
  fund_data[,dp_gr3a:=(dp - shift(dp,36/3,type = 'lag')) /at,by=ticker]
  fund_data[,fcf_gr3a:=(fcf - shift(fcf,36/3,type = 'lag')) /at,by=ticker]
  fund_data[,nwc_gr3a:=(nwc - shift(nwc,36/3,type = 'lag')) /at,by=ticker]
  fund_data[,nix_gr3a:=(nix - shift(nix,36/3,type = 'lag')) /at,by=ticker]
  fund_data[,eqnetis_gr3a:=(eqnetis - shift(eqnetis,36/3,type = 'lag')) /at,by=ticker]
  fund_data[,dltnetis_gr3a:=(dltnetis - shift(dltnetis,36/3,type = 'lag')) /at,by=ticker]
  fund_data[,dstnetis_gr3a:=(dstnetis - shift(dstnetis,36/3,type = 'lag')) /at,by=ticker]
  fund_data[,dbnetis_gr3a:=(dbnetis - shift(dbnetis,36/3,type = 'lag')) /at,by=ticker]
  fund_data[,netis_gr3a:=(netis - shift(netis,36/3,type = 'lag')) /at,by=ticker]
  fund_data[,fincf_gr3a:=(fincf - shift(fincf,36/3,type = 'lag')) /at,by=ticker]
  fund_data[,eqnpo_gr3a:=(eqnpo - shift(eqnpo,36/3,type = 'lag')) /at,by=ticker]
  fund_data[,tax_gr3a:=(tax - shift(tax,36/3,type = 'lag')) /at,by=ticker]
  fund_data[,div_gr3a:=(div - shift(div,36/3,type = 'lag')) /at,by=ticker]
  fund_data[,eqbb_gr3a:=(eqbb - shift(eqbb,36/3,type = 'lag')) /at,by=ticker]
  fund_data[,eqis_gr3a:=(eqis - shift(eqis,36/3,type = 'lag')) /at,by=ticker]
  fund_data[,eqpo_gr3a:=(eqpo - shift(eqpo,36/3,type = 'lag')) /at,by=ticker]
  fund_data[,capx_gr3a:=(capx - shift(capx,36/3,type = 'lag')) /at,by=ticker]
  # Investment
  fund_data[,capx_at:=capx /at]
  fund_data[,rd_at:=xrd /at]
  # Non recurring items
  fund_data[,spi_at:=spi /at]
  fund_data[,xido_at:=xido /at]
  fund_data[,nri_at:=(spi+xido) /at]
  # Profit Margin
  fund_data[,gp_sale:=gp /sale]
  fund_data[,ebitda_sale:=ebitda /sale]
  fund_data[,ebit_sale:=ebit /sale]
  fund_data[,pi_sale:=pi /sale]
  fund_data[,ni_sale:=ni /sale]
  fund_data[,nix_sale:=nix /sale]
  fund_data[,fcf_sale:=fcf /sale]
  fund_data[,ocf_sale:=ocf /sale]
  # Return on assets
  fund_data[,gp_at:=gp /at]
  fund_data[,ebitda_at:=ebitda /at]
  fund_data[,ebit_at:=ebit /at]
  fund_data[,fi_at:=fi /at]
  fund_data[,cop_at:=cop /at]
  # Return on Book equity
  fund_data[,ope_be:=ope /be]
  fund_data[,ni_be:=ni /be]
  fund_data[,nix_be:=nix /be]
  fund_data[,ocf_be:=ocf /be]
  fund_data[,fcf_be:=fcf /be]
  # Return on Invested Capital
  fund_data[,gp_bev:=gp /bev]
  fund_data[,ebitda_bev:=ebitda /bev]
  fund_data[,ebit_bev:=ebit /bev]
  fund_data[,fi_bev:=fi /bev]
  fund_data[,cop_bev:=cop /bev]
  # Return on Physical Capital
  fund_data[,gp_ppen:=gp /ppen]
  fund_data[,ebitda_ppen:=ebitda /ppen]
  fund_data[,fcf_ppen:=fcf /ppen]
  # Issuance
  fund_data[,fincf_at:=fincf / at]
  fund_data[,netis_at:=netis / at]
  fund_data[,eqnetis_at:=eqnetis / at]
  fund_data[,eqis_at:=eqis / at]
  fund_data[,dbnetis_at:=dbnetis / at]
  fund_data[,dltnetis_at:=dltnetis / at]
  fund_data[,dstnetis_at:=dstnetis / at]
  # Equity Payout
  fund_data[,eqnpo_at:=eqnpo / at]
  fund_data[,eqbb_at:=eqbb / at]
  fund_data[,div_at:=div / at]
  # Accruals
  fund_data[,oaccruals_at:=oacc / at]
  fund_data[,oaccruals_ni:=oacc / abs(nix)]
  fund_data[,taccruals_at:=tacc / at]
  fund_data[,taccruals_ni:=tacc / abs(nix)]
  fund_data[,noa_at:=noa / at]
  # Capitalization / Leverage Ratios
  fund_data[,be_dev:=be / bev]
  fund_data[,debt_dev:=debt / bev]
  fund_data[,cash_dev:=cash / bev]
  fund_data[,pstk_dev:=pstk / bev]
  fund_data[,debtlt_dev:=debtlt / bev]
  fund_data[,debtst_dev:=debtst / bev]
  fund_data[,debt_mev:=debt / mev]
  fund_data[,pstk_mev:=pstk / mev]
  fund_data[,debtlt_mev:=debtlt / mev]
  fund_data[,debtst_mev:=debtst / mev]
  # Financial Soundness Ratio
  fund_data[,int_debt:=int / debt]
  fund_data[,int_debtlt:=int / debtlt]
  fund_data[,ebitda_debt:=ebitda / debt]
  fund_data[,profit_cl:=ebitda / cl]
  fund_data[,ocf_cl:=ocf / cl]
  fund_data[,ocf_debt:=ocf / debt]
  fund_data[,cash_lt:=cash / lt]
  fund_data[,inv_act:=inv / act]
  fund_data[,rec_act:=rec / act]
  fund_data[,debtst_debt:=debtst / debt]
  fund_data[,cl_lt:=cl / lt]
  fund_data[,debtlt_debt:=debtlt / debt]
  fund_data[,opex_at:=opex / at]
  fund_data[,fcf_ocf:=fcf / ocf]
  fund_data[,lt_ppen:=lt / ppen]
  fund_data[,debtlt_be:=debtlt / be]
  fund_data[,nwc_at:=nwc / at]
  # Solvency Ratio
  fund_data[,debt_at:=debt / at]
  fund_data[,debt_be:=debt / be]
  fund_data[,ebit_int:=ebit / int]
  # Liquidity Ratio
  fund_data[,inv_days:=(((inv+shift(inv,12/3,type='lag'))/2)/cogs)*36/35 ,by=ticker]
  fund_data[,rec_days:=(((rec+shift(rec,12/3,type='lag'))/2)/sale)*36/35 ,by=ticker]
  fund_data[,ap_days:=(((ap+shift(ap,12/3,type='lag'))/2)/cogs)*36/35 ,by=ticker]
  fund_data[,cash_conversion:=inv_days + rec_days - ap_days]
  fund_data[,cash_cl:=cash / cl]
  fund_data[,caliq_cl:=caliq / cl]
  fund_data[,ca_cl:=ca / cl]
  # Activity / Efficiency Ratio
  fund_data[,inv_turnover:= cogs / ((inv + shift(inv,12/3,type='lag'))/2) ,by=ticker]
  fund_data[,at_turnover:= sale / ((at + shift(at,12/3,type='lag'))/2) ,by=ticker]
  fund_data[,rec_turnover:= sale / ((rec + shift(rec,12/3,type='lag'))/2) ,by=ticker]
  fund_data[,ap_turnover:= (cogs + inv - shift(inv,12/3,type='lag')) / ((ap + shift(ap,12/3,type='lag'))/2) ,by=ticker]
  # Miscellaneous
  fund_data[,adv_sale:=xad / sale]
  fund_data[,staff_sale:=xlr / sale]
  fund_data[,sale_bev:=sale / bev]
  fund_data[,rd_sale:=xrd / sale]
  fund_data[,sale_be:=sale / be]
  fund_data[,div_ni:=dvc / ni]
  fund_data[,sale_nwc:=sale / nwc]
  fund_data[,tax_pi:=tax / pi]
  # Balance Sheet Fundamental to Market Equity
  fund_data[,be_me:=be / me]
  fund_data[,at_me:=at / me]
  fund_data[,cash_me:=cash / me]
  # Income Fundamental to Market Equity
  fund_data[,gp_me:=gp / me]
  fund_data[,ebitda_me:=ebitda / me]
  fund_data[,ebit_me:=ebit / me]
  fund_data[,ope_me:=ope / me]
  fund_data[,ni_me:=ni / me]
  fund_data[,sale_me:=sale / me]
  fund_data[,ocf_me:=ocf / me]
  fund_data[,fcf_me:=fcf / me]
  fund_data[,nix_me:=nix / me]
  fund_data[,cop_me:=cop / me]
  fund_data[,xrd_me:=xrd / me]
  # Balance Sheet Fundamental to Market Enterprise Value
  fund_data[,be_mev:=be / mev]
  fund_data[,at_mev:=at / mev]
  fund_data[,cash_mev:=cash / mev]
  fund_data[,bev_mev:=bev / mev]
  fund_data[,ppen_mev:=ppen / mev]
  # Equity Payout/Issuance to Market Equity
  fund_data[,div_me:=div / me]
  fund_data[,eqbb_me:=eqbb / me]
  fund_data[,eqis_me:=eqis / me]
  fund_data[,eqpo_me:=eqpo / me]
  fund_data[,eqnpo_me:=eqnpo / me]
  fund_data[,eqnetis_me:=eqnetis / me]
  # Debt Issuance to Market Enterprise Value
  fund_data[,dlnetis_mev:=dltnetis / mev]
  fund_data[,dsnetis_mev:=dstnetis / mev]
  fund_data[,dbnetis_mev:=dbnetis / mev]
  # Firm Payout to Market Enterprise Value
  fund_data[,netis_mev:=netis / mev]
  # Income Fundamental to Market Enterprise Value
  fund_data[,gp_mev:=gp / mev]
  fund_data[,ebitda_mev:=ebitda / mev]
  fund_data[,ebit_mev:=ebit / mev]
  fund_data[,sale_mev:=sale / mev]
  fund_data[,ocf_mev:=ocf / mev]
  fund_data[,fcf_mev:=fcf / mev]
  fund_data[,cop_mev:=cop / mev]
  fund_data[,fincf_mev:=fincf / mev]
  # New variables in HXZ
  fund_data[,niq_saleq_std:=roll_sd(ni_qtr/sale_qtr,24/3,min_obs=1),by=ticker]
  fund_data[,ni_emp:=ni/emp]
  fund_data[,sale_emp:=sale/emp]
  fund_data[,ni_at:=ni / at]
  fund_data[,ocf_at:=ocf / at]
  fund_data[,ocf_at_chg1:=ocf_at - shift(ocf_at,12/3,type='lag'),by=ticker]
  fund_data[,roeq_be_std:=roll_sd(ni_qtr/be,48/3,min_obs=1),by=ticker]
  fund_data[,roe_be_std:=roll_sd(ni/be,60/3,min_obs=1),by=ticker]
  fund_data[,gpoa_ch5:=gp/at - (shift(gp,60/3,type='lag')/ shift(at,60/3,type='lag')),by=ticker]
  fund_data[,roe_ch5:=ni/be - (shift(ni,60/3,type='lag')/ shift(be,60/3,type='lag')),by=ticker]
  fund_data[,roa_ch5:=ni/at - (shift(ni,60/3,type='lag')/ shift(at,60/3,type='lag')),by=ticker]
  fund_data[,cfoa_ch5:=ocf/at - (shift(ocf,60/3,type='lag')/ shift(at,60/3,type='lag')),by=ticker]
  fund_data[,gmar_ch5:=gp/sale - (shift(gp,60/3,type='lag')/ shift(sale,60/3,type='lag')),by=ticker]
  
  # New variables from HXZ
  fund_data[,cash_at:=cash / at]
  fund_data[,ni_inc8q:=roll_sum(fifelse(epsActual/shift(epsActual,3,type='lag')>1,1,0),24/3,min_obs=1),by=ticker]
  fund_data[,ppeinv_grla:=(ppeinv - shift(ppeinv,12/3,type='lag')) / shift(at,12/3,type='lag'),by=ticker]
  fund_data[,lnoa_grla:=(lnoa - shift(lnoa,12/3,type='lag')) / (at - shift(at,12/3,type='lag')),by=ticker]
  fund_data[,capx_gr1:=capx / shift(capx,12/3,type='lag') -1, by=ticker]
  fund_data[,capx_gr2:=capx / shift(capx,24/3,type='lag') -1, by=ticker]
  fund_data[,capx_gr3:=capx / shift(capx,36/3,type='lag') -1, by=ticker]
  fund_data[,ivst:=shortTermInvestments]
  fund_data[,ivao:=investments]
  fund_data[,sti_gr1a:=(ivst - shift(ivst,12/3,type='lag')) / at, by=ticker]
  fund_data[,niq_be:=ni / shift(be,3,type='lag'), by=ticker]
  fund_data[,niq_be_chg1:=niq_be - shift(niq_be,12/3,type='lag'), by=ticker]
  fund_data[,niq_at:=ni / shift(at,3,type='lag'), by=ticker]
  fund_data[,niq_at_chg1:=niq_at - shift(niq_at,12/3,type='lag'), by=ticker]
  fund_data[,sale_gr1:=sale / shift(sale,12/3,type='lag') - 1,by=ticker]
  fund_data[,rd5_at:=0]
  for(n in 0:4) fund_data[,rd5_at:=rd5_at+(1-0.2*n)*shift(xrd,12/3*n,type='lag'),by=ticker]
  fund_data[,age:= year(Sys.Date()) - as.numeric(substr(month,1,4)) + 1]
  fund_data[,dsale_dinv:= sale / ((shift(sale,12/3,type = 'lag') + shift(sale,24/3,type = 'lag')) / 2) 
            -  inv / ((shift(inv,12/3,type = 'lag') + shift(inv,24/3,type = 'lag')) / 2), by=ticker]
  fund_data[,dsale_drec:= sale / ((shift(sale,12/3,type = 'lag') + shift(sale,24/3,type = 'lag')) / 2) 
            -  rec / ((shift(rec,12/3,type = 'lag') + shift(rec,24/3,type = 'lag')) / 2),by=ticker ]
  fund_data[,dgp_dsale:= gp / ((shift(gp,12/3,type = 'lag') + shift(gp,24/3,type = 'lag')) / 2) 
            -  sale / ((shift(sale,12/3,type = 'lag') + shift(sale,24/3,type = 'lag')) / 2),by=ticker ]
  fund_data[,dsale_dsga:= sale / ((shift(sale,12/3,type = 'lag') + shift(sale,24/3,type = 'lag')) / 2) 
            -  xsga / ((shift(xsga,12/3,type = 'lag') + shift(xsga,24/3,type = 'lag')) / 2),by=ticker ]
  fund_data[,saleq_su_lag:=0]
  for(lag in 3:15) fund_data[,saleq_su_lag:=saleq_su_lag + shift(sale,lag,type = 'lag'), by=ticker]
  fund_data[,saleq_su_lag:=saleq_su_lag/(15-3)]
  fund_data[,saleq_su:=(sale - (shift(sale,3,type = 'lag') + saleq_su_lag/4))/
              roll_sd(shift(sale,3,type='lag'), 15-3, min_obs = 1), by=ticker ]
  
  fund_data[,niq_su_lag:=0]
  for(lag in 3:15) fund_data[,niq_su_lag:=niq_su_lag + shift(ni_qtr,lag,type = 'lag'), by=ticker]
  fund_data[,niq_su_lag:=niq_su_lag/(15-3)]
  fund_data[,niq_su:=(ni_qtr - (shift(ni_qtr,3,type = 'lag') + niq_su_lag/4))/
              roll_sd(shift(ni_qtr,3,type='lag'), 15-3, min_obs = 1), by=ticker ]
  
  fund_data[,debt_me:=debt/ me]
  fund_data[,netdebt_me:=netdebt/ me]
  fund_data[,capx_abn:=capx_sale / ((shift(capx_sale,12/3,type='lag')+
                                       shift(capx_sale,24/3,type='lag')+
                                       shift(capx_sale,36/3,type='lag'))/3) -1,
            by=ticker]
  fund_data[,inv_gr1:= inv / shift(inv,12/3,type='lag') -1, by=ticker]
  fund_data[,be_gr1a:= (be - shift(be,12/3,type='lag')) / at, by=ticker]
  fund_data[,op_at:=op / at]
  fund_data[,pi_nix:=pi / nix]
  fund_data[,op_atl1:=op / shift(at,12/3,type='lag'),by=ticker]
  fund_data[,ope_bel1:=ope / shift(be,12/3,type='lag'),by=ticker]
  fund_data[,gp_atl1:=gp / shift(at,12/3,type='lag'),by=ticker]
  fund_data[,cop_atl1:=cop / shift(at,12/3,type='lag'),by=ticker]
  fund_data[,at_be:=at / be]
  fund_data[,ocfq_saleq_std:=roll_sd(ocf_qtr/sale_qtr,48/3,min_obs =1),by=ticker]
  fund_data[,aliq_at:=aliq / shift(at,12/3,type='lag'),by=ticker]
  fund_data[,aliq_mat:=aliq / shift(mat,12/3,type='lag'),by=ticker]
  fund_data[,tangibility:=(cash+0.715*rec+0.547*inv+0.535*ppeg)/ at]
  fund_data[,sale_emp_gr1:=sale_emp / shift(sale_emp,12/3,type='lag') -1,by=ticker]
  fund_data[,earnings_variability:=roll_sd(ni/shift(at,12/3,type='lag'),60/3,min_obs =1) /
              roll_sd(ocf/shift(at,12/3,type='lag'),60/3, min_obs =1)
            ,by=ticker]
  fund_data[,ni_ar1:=shift(ni,12/3,type='lag')/shift(at,12/3,type='lag'),by=ticker]
  # Equity duration
  ma = max(fund_data$age) * 12/3
  f = function(x) {
    if(all(is.na(x)) | all(is.infinite(x))) {
      return(1.)
    }
    if(any(is.na(x)) | any(is.infinite(x))) {
      x = x[-which(is.na(x) | is.infinite(x))]
    } 
    if(length(x) < 2) {
      return(1.)
    } 
    return(acf(x,plot=F)$acf[2,1,1])
  }
  
  fund_data[,roe0:=ni/shift(abs(be), 12/3, type='lag'),by=ticker]
  fund_data[,g0:=sale/ shift(sale,12/3,type='lag') -1 ,by=ticker]
  fund_data[,roe_ar1:=rollapplyr(roe0,length(roe0),f, partial=T),by=ticker]
  fund_data[,g_ar1:=rollapplyr(g0, length(g0),f, partial=T),by=ticker]
  fund_data[,roe_c:=roll_mean(roe0, length(roe0), min_obs = 1) * (1-roe_ar1),by=ticker]
  fund_data[,g_c:= roll_mean(g0, length(g0), min_obs = 1) * (1-g_ar1),by=ticker]
  fund_data[,roe_t:=fifelse(is.infinite(roe_c),0,roe_c) + fifelse(is.infinite(roe_ar1),0,roe_ar1) * shift(roe0,1, type='lag'),by=ticker]
  fund_data[,g_t:=fifelse(is.infinite(g_c),0,g_c) + fifelse(is.infinite(g_ar1),0,g_ar1) * shift(g0,1, type='lag'),by=ticker]
  fund_data[,be_t:=fifelse(is.infinite(g_t),1, 1+g_t) * shift(be,1, type='lag'),by=ticker]
  fund_data[,cd_t:=be_t * (roe_t - g_t),by=ticker]
  
  fund_data[,ed_constant:=1 + (1+r)/r,by=ticker]
  fund_data[,ed_cd:=cd_t/(1+r),by=ticker]
  fund_data[,eq_dur:=ed_cd/mve_c + ed_constant * (mve_c - ed_cd)/ mve_c,by=ticker]
  
  # Piotroski F-score
  fund_data[,dltt:=longTermDebt]
  fund_data[,roa:=ni/shift(at,12/3,type='lag'),by=ticker]
  fund_data[,croa:=ocf/shift(at,12/3,type='lag'),by=ticker]
  fund_data[,droa:= roa - shift(roa,12/3,type='lag'),by=ticker]
  fund_data[,acc:= croa - roa,by=ticker]
  fund_data[,lev:= dltt/at - shift(dltt/at,12/3,type='lag'),by=ticker]
  fund_data[,liq:= ca/cl - shift(ca/cl,12/3,type='lag'),by=ticker]
  fund_data[,gm:= gp/sale - shift(gp/sale,12/3,type='lag'),by=ticker]
  fund_data[,aturn:= sale/shift(at,12/3,type='lag') - shift(sale,12/3,type='lag') / shift(at,24/3,type='lag'),by=ticker]
  fund_data[,score:=fifelse(roa>0,1,0) + fifelse(croa>0,1,0) + fifelse(droa>0,1,0) +fifelse(acc>0,1,0) +
              fifelse(lev<0,1,0) + fifelse(liq>0,1,0) + fifelse(eqis==0,1,0) + fifelse(gm>0,1,0) +fifelse(aturn>0,1,0)]
  fund_data[,f_score:=roll::roll_mean(score, length(score), min_obs = 1),by=ticker]
  
  # Ohlson O-score
  fund_data[,lat:=shift(at,1,type='lag'),by=ticker]
  fund_data[,lev:=debt/at,by=ticker]
  fund_data[,wc:=(abs(ca)-cl)/at,by=ticker]
  fund_data[,roe:=(nix)/at,by=ticker]
  fund_data[,cacl:=(cl)/ca,by=ticker]
  fund_data[,fo:=(pi+dp)/lt,by=ticker]
  fund_data[,neg_eq:=fifelse(lt>at,1,0)]
  fund_data[,neg_earn:=fifelse(nix<0 & shift(nix,12/3,type='lag'),1,0),by=ticker]
  fund_data[,nich:=(nix - shift(nix,12/3,type='lag'))/ (abs(nix) - shift(abs(nix),12/3,type='lag')),by=ticker]
  fund_data[,o_score:=-1.37-0.407*lat+6.03*lev+1.43*wc+0.076*cacl-1.72*neg_eq-2.37*roe-1.83*fo+0.285*neg_earn-0525*nich,by=ticker]
  
  # Altman Z-score
  fund_data[,re:=retainedEarnings]
  fund_data[,wc:=(ca-cl)/at,by=ticker]
  fund_data[,re:=(re)/at,by=ticker]
  fund_data[,eb:=(ebitda)/at,by=ticker]
  fund_data[,sa:=(sale)/at,by=ticker]
  fund_data[,me:=(mve_c)/lt,by=ticker]
  fund_data[,z_score:=1.2*wc+1.4*re+3.3*eb+0.6*me+sa]
  
  # Kaplan Zingales Index
  fund_data[,che:=cashAndShortTermInvestments]
  fund_data[,dv:=depreciationAndAmortization]
  fund_data[,ppen:=propertyPlantEquipment]
  fund_data[,kz_cf:=(ni+dv)/shift(ppen,12/3,type='lag'),by=ticker]
  fund_data[,kz_q:=(at+mve_c-be)/at,by=ticker]
  fund_data[,kz_db:=(debt)/(debt+seq),by=ticker]
  fund_data[,kz_dv:=(div)/shift(ppen,12/3,type='lag'),by=ticker]
  fund_data[,kz_cs:=(che)/shift(ppen,12/3,type='lag'),by=ticker]
  fund_data[,kz_index:=-1.002*kz_cf+0.283*kz_q+3.139*kz_db-39.36/38*kz_dv-1.315*kz_cs,by=ticker]
  
  # Intrinsic ROE from Frankel and Lee
  fund_data[,iv_po:=fifelse(nix <0, div/ (at*0.06),div/nix),by=ticker]
  fund_data[,iv_roe:=nix/ (be + shift(be,12/3,type='lag'))/2,by=ticker]
  fund_data[,iv_be1:=(1+(1-iv_po)*iv_roe)*be,by=ticker]
  fund_data[,intrinsic_value:=be+(iv_roe-r)/(1+r)*be+(iv_roe-r)/((1+r)*r)*iv_be1,by=ticker]
  
  # Earnings variability
  fund_data[,earnings_variability:=roll_sd(ni/shift(at,12/3,type='lag'),60/3,min_obs=1) /
              roll_sd(ocf/shift(at,12/3,type='lag'),60/3,min_obs=1),by=ticker]
  
  # Net Income idiosyncratic volatility
  fund_data[,ni_at:=fifelse(is.infinite(ni/at) | is.na(ni/at),0,ni/at),by=ticker]
  f = function(x,y,ma) {
    reg = roll::roll_lm(x,y,width=ma, min_obs = 1)$coefficient
    ress = NULL
    for(i in 1:length(x)) ress = c(ress,sqrt(sum(y[1:i] - (reg[i,1] + reg[i,2] * x[1:i])^2,na.rm=T)))
    edf = (1:length(x)) - 2
    ni_ivol = sqrt((ress^2*edf)/(1+edf))
    return(ni_ivol)
  }
  fund_data[,ni_ivol:=f(shift(ni_at,12/3,type='lag'),ni_at,length(ni_at)),by=ticker]
  fwrite(fund_data, '/home/cyril/TRADING/EOD/fund_data.csv')
  
  cols_to_retain = c('at','sale','be','ni','mev',
                     names(fund_data)[grep('emp|_gr|_at|_sale|_be|_bev|_ppen|_ni|_mev|_debt|_debtlt|_cl|_lt|_act|_ocf|_int|_days|_conversion|_turnover|_nwc|_pi|_me|_ch1|_ch5|_std|ni_inc|age|_dinv|_drec|_dsga|_su|_abn|_nix|_mat',
                                           names(fund_data))],'tangibility','eq_dur','f_score','o_score','z_score','kz_index',
                     'intrinsic_value','earnings_variability','ni_ar1','ni_ivol'
  )
  all_factors = cbind(all_factors,fund_data[,cols_to_retain,with=F])
  fwrite(all_factors, '/home/cyril/TRADING/EOD/accounting_data.csv')
  all_factors
}

# Market characteristics
get_market_factors = function(fund_data) {
  fund_data[,shares:=abs(commonStockSharesOutstanding)/1000]
  fund_data[,prc_adj:=abs(adjusted_close)]
  fund_data[,me:=prc_adj * shares]
  fund_data[,prc_high:=abs(high)]
  fund_data[,prc_low:=abs(low)]
  fund_data[,ret:=c(0,diff(log(prc_adj))),by=ticker]
  fund_data[,ret:=fifelse(is.nan(ret)|is.na(ret)|is.infinite(ret),0,ret)]
  fund_data[,ret_exc:=ret-r,by=ticker]
  fund_data[,ret_exc_lead1m:=shift(ret,1,type='lead'),by=ticker] 
  fund_data[,ri:=ret / shift(ret,1,type='lag') - 1,by=ticker]
  fund_data[,dolvol:=volume*prc_adj,by=ticker]
  fund_data[,divtot:=div/1000/shares,by=ticker]
  
  # Replace with index from SP500 
  #sp500 = fread('../INDX/GSPC.INDX.csv')
  #sp500[,V1:=NULL]
  #sp500 = as.xts.data.table(sp500)
  #sp500 = as.data.table(sp500)[endpoints(sp500)]
  #colnames(sp500) = paste0('sp',colnames(sp500))
  #sp500[,mktref:=c(0,diff(log(spadjusted_close)))]
  #sp500[,date_string:=format(spindex,'%Y-%m')]
  #fund_data = merge(fund_data,sp500,by='date_string')
  
  fund_data[,div1m_me:=(divtot*shares)/me,by=ticker]
  fund_data[,div3m_me:=roll::roll_sum( (divtot*shares)/me,3,min_obs = 1),by=ticker]
  fund_data[,div6m_me:=roll::roll_sum( (divtot*shares)/me,6,min_obs = 1),by=ticker]
  fund_data[,div12m_me:=roll::roll_sum( (divtot*shares)/me,12,min_obs = 1),by=ticker]
  fund_data[,divspc1m_me:=0]
  fund_data[,divspc12m_me:=0]
  fund_data[,chcsho_1m:=shares / shift(shares,1,type='lag') -1,by=ticker]
  fund_data[,chcsho_3m:=shares / shift(shares,3,type='lag') -1,by=ticker]
  fund_data[,chcsho_6m:=shares / shift(shares,6,type='lag') -1,by=ticker]
  fund_data[,chcsho_12m:=shares / shift(shares,12,type='lag') -1,by=ticker]
  
  fund_data[,eqnpo_1m:=log(ri/shift(ri,1,type='lag')) - log(me/shift(me,1,type='lag')),by=ticker]
  fund_data[,eqnpo_3m:=log(ri/shift(ri,3,type='lag')) - log(me/shift(me,3,type='lag')),by=ticker]
  fund_data[,eqnpo_6m:=log(ri/shift(ri,6,type='lag')) - log(me/shift(me,6,type='lag')),by=ticker]
  fund_data[,eqnpo_12m:=log(ri/shift(ri,12,type='lag')) - log(me/shift(me,12,type='lag')),by=ticker]
  
  fund_data[,ret_1_0:=ri/shift(ri,1,type='lag') -1,by=ticker]
  fund_data[,ret_2_0:=ri/shift(ri,2,type='lag') -1,by=ticker]
  fund_data[,ret_3_0:=ri/shift(ri,3,type='lag') -1,by=ticker]
  fund_data[,ret_3_1:=shift(ri,1,type='lag')/shift(ri,3,type='lag') -1,by=ticker]
  fund_data[,ret_6_0:=ri/shift(ri,6,type='lag') -1,by=ticker]
  fund_data[,ret_6_1:=shift(ri,1,type='lag')/shift(ri,6,type='lag') -1,by=ticker]
  fund_data[,ret_9_0:=ri/shift(ri,9,type='lag') -1,by=ticker]
  fund_data[,ret_9_1:=shift(ri,1,type='lag')/shift(ri,9,type='lag') -1,by=ticker]
  
  fund_data[,ret_12_0:=ri/shift(ri,12,type='lag') -1,by=ticker]
  fund_data[,ret_12_1:=shift(ri,1,type='lag')/shift(ri,12,type='lag') -1,by=ticker]
  fund_data[,ret_12_7:=shift(ri,7,type='lag')/shift(ri,12,type='lag') -1,by=ticker]
  fund_data[,ret_18_1:=shift(ri,1,type='lag')/shift(ri,18,type='lag') -1,by=ticker]
  fund_data[,ret_24_1:=shift(ri,1,type='lag')/shift(ri,24,type='lag') -1,by=ticker]
  fund_data[,ret_24_12:=shift(ri,12,type='lag') /shift(ri,24,type='lag') -1,by=ticker]
  fund_data[,ret_36_1:=shift(ri,1,type='lag')/shift(ri,36,type='lag') -1,by=ticker]
  fund_data[,ret_36_12:=shift(ri,12,type='lag')/shift(ri,36,type='lag') -1,by=ticker]
  fund_data[,ret_48_1:=shift(ri,1,type='lag')/shift(ri,48,type='lag') -1,by=ticker]
  fund_data[,ret_48_12:=shift(ri,12,type='lag')/shift(ri,48,type='lag') -1,by=ticker]
  fund_data[,ret_60_1:=shift(ri,1,type='lag')/shift(ri,60/3,type='lag') -1,by=ticker]
  fund_data[,ret_60_12:=shift(ri,12,type='lag')/shift(ri,60/3,type='lag') -1,by=ticker]
  fund_data[,ret_60_36:=shift(ri,36,type='lag')/shift(ri,60/3,type='lag') -1,by=ticker]
  # Seasonality
  fund_data[,seas_1_1an:=shift(ret,12,type='lag'),by=ticker]
  fund_data[,seas_2_5an:=0]
  for(i in 24:60/3) fund_data[,seas_2_5an:=seas_2_5an + ifelse(i %% 12==0,shift(ret,i,type='lag'),0),by=ticker]
  fund_data[,seas_2_5an:=seas_2_5an/ 4]
  fund_data[,seas_6_10an:=0]
  for(i in 72:120) fund_data[,seas_6_10an:=seas_6_10an + ifelse(i %% 12==0,shift(ret,i,type='lag'),0),by=ticker]
  fund_data[,seas_6_10an:=seas_6_10an/ 5]
  fund_data[,seas_11_15an:=0]
  for(i in 132:180) fund_data[,seas_11_15an:=seas_11_15an + ifelse(i %% 12==0,shift(ret,i,type='lag'),0),by=ticker]
  fund_data[,seas_11_15an:=seas_11_15an/ 5]
  fund_data[,seas_16_20an:=0]
  for(i in 192:240) fund_data[,seas_16_20an:=seas_16_20an + ifelse(i %% 12==0,shift(ret,i,type='lag'),0),by=ticker]
  fund_data[,seas_16_20an:=seas_16_20an/ 5]
  fund_data[,seas_1_1na:=0]
  for(i in 1:11) fund_data[,seas_1_1na:=seas_1_1na + shift(ret,i,type='lag'),by=ticker]
  fund_data[,seas_1_1na:=seas_1_1na/ 11]
  
  fund_data[,seas_2_5na:=0]
  for(i in 24:60/3) fund_data[,seas_2_5na:=seas_2_5na + ifelse(i %% 12!=0,shift(ret,i,type='lag'),0),by=ticker]
  fund_data[,seas_2_5na:=seas_2_5na/ (11*3)]
  fund_data[,seas_6_10na:=0]
  for(i in 72:120) fund_data[,seas_6_10na:=seas_6_10na + ifelse(i %% 12!=0,shift(ret,i,type='lag'),0),by=ticker]
  fund_data[,seas_6_10na:=seas_6_10na/ (11*4)]
  fund_data[,seas_11_15na:=0]
  for(i in 132:180) fund_data[,seas_11_15na:=seas_11_15na + ifelse(i %% 12!=0,shift(ret,i,type='lag'),0),by=ticker]
  fund_data[,seas_11_15na:=seas_11_15na/ (11*4)]
  fund_data[,seas_16_20na:=0]
  for(i in 192:240) fund_data[,seas_16_20na:=seas_16_20na + ifelse(i %% 12!=0,shift(ret,i,type='lag'),0),by=ticker]
  fund_data[,seas_16_20na:=seas_16_20na/ (11*4)]
  
  
  fund_data[,beta_60m:=roll::roll_lm(mktref - r,ret, 60/3, min_obs = 1)$coefficients[,2],by=ticker]
  fund_data[,rank_oscore:=frankv(-o_score),by=month]
  fund_data[,rank_ret:=frankv(-ret_12_1),by=month]
  fund_data[,rank_gp_at:=frankv(-gp_at),by=month]
  fund_data[,rank_niq_at:=frankv(-niq_at),by=month]
  fund_data[,mispricing_perf:=1/4*(rank_oscore+rank_ret+rank_gp_at+rank_niq_at)]
  fund_data[,rank_chcsho_1m:=frankv(-chcsho_1m),by=month]
  fund_data[,rank_eqnpo_12m:=frankv(-eqnpo_12m),by=month]
  fund_data[,rank_oaccruals_at:=frankv(oaccruals_at),by=month]
  fund_data[,rank_noa_at:=frankv(-noa_at),by=month]
  fund_data[,rank_at_gr1:=frankv(-at_gr1),by=month]
  fund_data[,rank_ppeinv_grla:=frankv(-ppeinv_grla),by=month]
  fund_data[,mispricing_mgmt:=1/6*(rank_chcsho_1m+rank_eqnpo_12m+rank_oaccruals_at+
                                     rank_noa_at+rank_at_gr1+rank_ppeinv_grla)]
  
  # FIXME
  # f = function(x,y,ma) {
  #   reg = roll::roll_lm(x,y,width=ma, min_obs = 1)$coefficients
  #   ress = NULL
  #   for(i in 1:nrow(x)) {
  #     residuals= y[max(i-5,1):i] - (reg[i,1] + reg[i,2] * x[max(i-5,1):i,1] +
  #                                     reg[i,3] * x[max(i-5,1):i,2] +
  #                                     reg[i,4] * x[max(i-5,1):i,3])
  #     ress = c(ress,-1 + prod( 1 + residuals,na.rm=T))
  #   }
  #   return(ress)
  # }
  # lag = 1
  # fund_data[,resff3_6_1:=f(cbind(shift(mktref,lag,type='lag'),shift(SMB,lag,type='lag'),
  #                                shift(HML,lag,type='lag')),
  #                          ret,6),by=ticker]
  # fund_data[,resff3_12_1:=f(cbind(shift(mktref,lag,type='lag'),shift(SMB,lag,type='lag'),
  #                                 shift(HML,lag,type='lag')),
  #                           ret,12),by=ticker]
  fwrite(fund_data, '/home/cyril/TRADING/EOD/market_data.csv')
  fund_data
}

quality_minus_junk = function(fund_data) {
  # QMJ Profit
  fund_data[,z_gp_at:=(frankv(gp_at) - mean(frankv(gp_at))) / sd(frankv(gp_at)),by=date_string]
  fund_data[,z_ni_be:=(frankv(ni_be) - mean(frankv(ni_be))) / sd(frankv(ni_be)),by=date_string]
  fund_data[,z_ni_at:=(frankv(ni_at) - mean(frankv(ni_at))) / sd(frankv(ni_at)),by=date_string]
  fund_data[,z_ocf_at:=(frankv(ocf_at) - mean(frankv(ocf_at))) / sd(frankv(ocf_at)),by=date_string]
  fund_data[,z_gp_sale:=(frankv(gp_sale) - mean(frankv(gp_sale))) / sd(frankv(gp_sale)),by=date_string]
  fund_data[,z_oaccruals_at:=(frankv(oaccruals_at) - mean(frankv(oaccruals_at))) / sd(frankv(oaccruals_at)),by=date_string]
  fund_data[,qmj_prof_variable:=z_gp_at+z_ni_be+z_ni_at+z_ocf_at+z_gp_sale+z_oaccruals_at,by=date_string]
  fund_data[,qmj_prof:=(qmj_prof_variable - mean(qmj_prof_variable)) / sd(qmj_prof_variable),by=date_string]
  # QMJ Growth
  fund_data[,z_gpoa_ch5:=(frankv(gpoa_ch5) - mean(frankv(gpoa_ch5))) / sd(frankv(gpoa_ch5)),by=date_string]
  fund_data[,z_roa_ch5:=(frankv(roa_ch5) - mean(frankv(roa_ch5))) / sd(frankv(roa_ch5)),by=date_string]
  fund_data[,z_roe_ch5:=(frankv(roe_ch5) - mean(frankv(roe_ch5))) / sd(frankv(roe_ch5)),by=date_string]
  fund_data[,z_cfoa_ch5:=(frankv(cfoa_ch5) - mean(frankv(cfoa_ch5))) / sd(frankv(cfoa_ch5)),by=date_string]
  fund_data[,z_gmar_ch5:=(frankv(gmar_ch5) - mean(frankv(gmar_ch5))) / sd(frankv(gmar_ch5)),by=date_string]
  fund_data[,qmj_grow_variable:=z_gpoa_ch5+z_roa_ch5+z_roe_ch5+z_cfoa_ch5+z_gmar_ch5,by=date_string]
  fund_data[,qmj_grow:=(qmj_grow_variable - mean(qmj_grow_variable)) / sd(qmj_grow_variable),by=date_string]
  # QMJ Safety
  fund_data[,z_betabab_1260d:=(frankv(betabab_1260d) - mean(frankv(betabab_1260d))) / sd(frankv(betabab_1260d)),by=date_string]
  fund_data[,z_debt_at:=(frankv(debt_at) - mean(frankv(debt_at))) / sd(frankv(debt_at)),by=date_string]
  fund_data[,z_o_score:=(frankv(o_score) - mean(frankv(o_score))) / sd(frankv(o_score)),by=date_string]
  fund_data[,z_z_score:=(frankv(z_score) - mean(frankv(z_score))) / sd(frankv(z_score)),by=date_string]
  fund_data[,evol:=roe_be_std*2,by=date_string]
  fund_data[,z_evol:=(frankv(evol) - mean(frankv(evol))) / sd(frankv(evol)),by=date_string]
  fund_data[,qmj_saf_variable:=z_betabab_1260d+z_debt_at+z_o_score+z_z_score+z_evol,by=date_string]
  fund_data[,qmj_saf:=(qmj_saf_variable - mean(qmj_saf_variable)) / sd(qmj_saf_variable),by=date_string]
  # QMJ
  fund_data[,qmj:=(qmj_prof+qmj_grow+qmj_saf)/3]
  fwrite(fund_data,'/home/cyril/TRADING/EOD/all_fund_data.csv')
  return(fund_data)
}

zScore <- function(i, meanExp, sigmaExp) {
  # FIXME
  if(length(which(is.na(sigmaExp)| sigmaExp == 0))) {
    sigmaExp = 1
  } else {
    sigmaExp = sigmaExp[1]
  }
  #meanExp = mean(i,na.rm=T)
  #sigmaExp = sd(i,na.rm=T)
  sigmaEWMA <- stdExpo <- exposures <- i
  ts <- (i - meanExp)^2
  var_past_2 <- sigmaExp ^ 2
  sigmaEWMA <- sapply(ts, function(x) var_past_2 <<- 0.10 * x + 0.90 * var_past_2)
  sigmaEWMA[which(sigmaEWMA==0)]<- 1
  as.vector((i -  meanExp) / sqrt(sigmaEWMA))
}
