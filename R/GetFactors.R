#' @title Scrape Academic Financial Data Libraries
#'
#' @description
#' This is a convenience function to provide an easy way to download research
#' financial data sets from several accredited sources.
#' Specifically, it allows to import them in the `R` environment as `xts` objects.
#' Scientific libraries here contemplated are from several researchers as,
#' unfortunately, a wide open source collection is not available at this time.
#' On one hand, these resources - of admirable effort - lack important features
#' (financial) databases guarantee: importantly, there aren't APIs to leverage by
#' systematic connections. On the other hand, these data sets satisfy important
#' characteristics: they are open sourced, free to use for everyone, and collected/maintained
#' by researchers of the field.
#'
# #' TODO: provide a general overview of data made available
#' In the case of the Fama-French's online library, generally stock data is obtained
#' from the *Center for Research in Security Prices, LLC* (CRSP) and the risk-free
#' rate is from *Ibbotson and Associates, Inc.* or *Bloomberg* databases.
#'
#' All credits for collecting, maintaining, and sharing data belong to the mentioned
#' authors or copyright holders (see 'Source').
#'
#' @source
#' [Kenneth R. French's data library](http://mba.tuck.dartmouth.edu/pages/faculty/ken.french/data_library.html),
#' [global-q.org](http://global-q.org/index.html)
#'
#' @param x A character string specifying which data set to download. One of `FF3`, `FF5`, `MOM`, `REV`, or `Q5`. See 'Value'.
#' @param src A character string, the source to download data from. `FF` (default) and `HXZ` currently available.
#' @param freq A character string, specifying `x` data frequency. One of `'annual'`, `'monthly'` (default), `'quarterly'`, `'weekly'`, `'w2w'`, or `'daily'`. See 'Details'.
#' @param term A character to be additionally provided when `x='REV'`. Either `'ST'` (short-term, default) or `'LT'` (long term).
#' @param country A character string indicating for which country Fama-French's factors are being requested. Default is U.S. factors. See 'Details' for other countries available.
# #' TODO: param verbose A boolean, whether or not to retrieve additional info on data sets being downloaded. Not currently used.
#'
# #' TODO: `verbose`, if ever needed/wanted, should include Fama-French's data 'details' to provide factor construction info
#'
#' @return
#' An `xts` object with columns being factors over the whole period available
#' from source. For `FF3`, `FF5`, and `Q5`, the risk free rate (`RF`, e.g. 1-month
#' T-Bill return for the U.S.) is included as well. `RF` may present small differences
#' from data set to data set. All values are returned in decimal units.
#' Because the actual object depends on the data set chosen, which more often than not
#' resembles factors included in established models in the literature, below we
#' provide a brief summary of the factors currently available relative to the
#' model they originally belong to.
#'
#' * **Fama-French three-factor model** (`FF3`). Includes `MKT.RF` (market excess returns), `SMB` (Small Minus Big), and `HML` (high minus low).
#' * **Fama-French five-factor model** (`FF5`). Adds `RMW` (Robust Minus Weak) and `CMA` (Conservative Minus Aggressive) to `FF3`.
#' * **Q-factor models** (`Q5`). The four-factor version includes `MKT.RF` (market excess returns), `IA` (Investment-to-Assets), `ME` (size factor returns), and `ROE` (Return On Equity factor returns). `Q5` adds `EG` (Expected Growth returns).
#'
#' Other factors downloadable as standalone time series are `MOM` - the momentum
#' factor, also referred to as Up Minus Down (UMD) - and `REV`, the reversal factor
#' further distinguished in short- and long-term.
#' Adding the former to `FF3` gives the factors data set of the so called
#' **Fama-French-Carhart model**, while adding it to `FF5` originates the
#' **Fama-French six-factor model**.
#'
#' @note
#' WARNING: We are not in a position to interact directly with the online library
#' via an API and there could be possible inconsistencies in source files formatting.
#' Given this shaking foundations and despite our efforts to guarantee an optimal
#' result, it could happen that data obtained is not what expected.
#' A sign that the data file downloaded may be incomplete is the lack of the header
#' as specified above.
#'
#' Also, please be considerate while using the function. In particular, do not send
#' too frequent requests to the web source as the supported/tolerated request rate
#' is unknown. Usage remains at your own discretion and responsibility.
# #' TODO: deal with loops internally so to include some sleeping time?
#'
#' @details
#' Not all the data sets are available at all frequencies.
#' Most Fama-French data sets are available on a `'annual'`, `'monthly'` (default),
#' `'weekly'`, and `'daily'` frequency. However, with respect to factor data,
#' `'weekly'` data frequency is available for the three-factor model only.
#' For what concerns the q-factor models, frequencies available also include
#' `'quarterly'` and `w2w`(Wednesday-to-Wednesday weekly data) frequencies.
#'
#' The parameter `country` can specify one of those "country" (country or region)
#' made available by Fama-French.
#' Countries they make available are 'Asia Pacific ex Japan', 'Developed',
#' 'Developed ex US', 'Emerging', 'Europe', 'Japan', 'North America' and
#' 'United States' (the 'domestic' country with respect to which the standard
#' Fama-French's factors are computed, with markets being NYSE, AMEX and NASDAQ).
#'
#' Fama-French often indicate missing data by -99.99 or -999.
#'
#' @author
#' Vito Lestingi
#'
#' @examples
#' \dontrun{
#' # Fama-French Three-factor model data
#' GetFactors('FF3', src='FF')
#'
#' # Momentum factor
#' GetFactors('MOM', 'FF', 'monthly')
#'
#' # Short-term reversal factor
#' GetFactors('REV', 'FF', 'annual', term='ST')
#'
#' # Fama-French Five-factor model data
#' GetFactors('FF5', 'FF', 'weekly') # fails, no data currently available
#'
#' # q^5 monthly factors
#' GetFactors('Q5', src='HXZ', 'monthly')
#'
#' } #end dontrun
#'
#' @importFrom utils download.file read.csv unzip
#' @importFrom xts as.xts last
#'
#' @export
#'
GetFactors <- function(x
                       , src
                       , freq
                       , term
                       , country=NULL
                       # , verbose=FALSE
)
{
  if(missing(src)) src <- 'FF'
  src.available <- c('FF', 'HXZ')
  if(all(src != src.available)) {
    stop("src = ", sQuote(src), " is not currently implemented.")
  } else {
    if(missing(freq)) freq <- 'monthly'
    source <- match.arg(src, src.available, several.ok=FALSE)
    switch (source,
            FF = {
              # Get all FF web targets on factors
              base.url <- "http://mba.tuck.dartmouth.edu/pages/faculty/ken.french/"
              ff.links <- XML::getHTMLLinks("http://mba.tuck.dartmouth.edu/pages/faculty/ken.french/data_library.html")
              ff.factors.links <- grep('factor*', ff.links, ignore.case=TRUE, value=TRUE)
              ff.factors.data.links <- grep('_csv', ff.factors.links, ignore.case=TRUE, value=TRUE) # txt files available too
              # Identify web target to query
              # Data files with unspecified frequencies in the corresponding
              # file name include both monthly and annual data.
              # A way of proceeding in this last case is by exclusion.
              ff.factors.data.day.idxs <- grep('daily', ff.factors.data.links, ignore.case=TRUE)
              ff.factors.data.week.idxs <- grep('weekly', ff.factors.data.links, ignore.case=TRUE)
              ff.factors.data.mon.ann.idxs <- setdiff(1:length(ff.factors.data.links), union(ff.factors.data.day.idxs, ff.factors.data.week.idxs))
              if (is.null(country)) {# standard Fama-French's U.S. factors
                # Get factor model - frequency intersections
                us.factors.idxs <- grep('f-f', ff.factors.data.links, ignore.case=TRUE) # filter out other countries
                ff.factors.plain.links <- if (freq == 'daily') {
                  ff.factors.data.links[intersect(us.factors.idxs, ff.factors.data.day.idxs)]
                } else if (freq == 'weekly') {
                  ff.factors.data.links[intersect(us.factors.idxs, ff.factors.data.week.idxs)]
                } else if (freq == 'monthly' | freq == 'annual') {
                  ff.factors.data.links[intersect(us.factors.idxs, ff.factors.data.mon.ann.idxs)]
                }
                # Get to the actual factors needed
                x <- match.arg(x, c('FF3', 'FF5', 'MOM', 'REV'), several.ok=FALSE)
                ff5.idxs <- grep('5', ff.factors.plain.links, ignore.case=TRUE)
                mom.idxs <- grep('mom', ff.factors.plain.links, ignore.case=TRUE)
                rev.idxs <- grep('ST|LT', ff.factors.plain.links, ignore.case=TRUE)
                if (x == 'FF3') {# by exclusion, as 'indistinguishable' pattern name
                  ff3.idxs <- setdiff(1:length(ff.factors.plain.links), Reduce(union, c(ff5.idxs, mom.idxs, rev.idxs)))
                  target.url <- ff.factors.plain.links[ff3.idxs]
                  header.pattern <- ',Mkt-RF,SMB,HML,RF'
                } else if (x == 'FF5') {
                  # Oversimplified regex would likely fail on portfolios, need to
                  # account for '25' and '5x5' as well in that case
                  target.url <- ff.factors.plain.links[ff5.idxs]
                  header.pattern <- ',Mkt-RF,SMB,HML,RMW,CMA,RF'
                } else if (x == 'MOM') {
                  target.url <- ff.factors.plain.links[mom.idxs]
                  header.pattern <- ',Mom' # risky: may match file comments!
                } else if (x == 'REV') {
                  if(missing(term)) term <- 'ST'
                  target.url <- grep(term, ff.factors.plain.links, ignore.case=TRUE, value=TRUE)
                  header.pattern <- ifelse(term == 'ST', ',ST_Rev', ',LT_Rev')
                }
              } else {# data by country
                # TODO
                # Here the way we ask to input country can help, two ideas:
                # 1. Ask for full specification (as FF names), collapse and then regex
                # 2. Ask for abbreviation, expand internally and then regex
                stop('Factors by country download is currently not supported.')
                idx <- union(grep(x, ff.factors.data.links), grep(country, ff.factors.data.links))
                target.url <- ff.factors.data.links[idx]
                # TODO: get 'header.pattern' (e.g., Japan Momentum has a 'WML' col name)
              }
              if (length(target.url) == 0) {
                stop(gettextf('Unable to find %s factor data (%s) from %s.', x, freq, source))
              } else if (length(target.url) > 1) {
                # TODO: Deal with potential multiple matches
                # interactive human inspection?
                # utils::menu(target.url)
                stop('Multiple files matched, but choice or multiple downloads is not supported at the moment.')
              }
              # Download and format web source target identified
              temp.file <- tempfile()
              temp.dir <- tempdir()
              download.file(paste0(base.url, target.url), temp.file)
              ff.data.raw <- unzip(temp.file, exdir=temp.dir)
              # Clean comment lines from data set
              # TODO: 'sanitize' missing data, which they indicate with -99.99 or -999?
              # TODO: nice to add who's the underlying provider (e.g., CRSP, Bloomberg), which is file header
              # WARNING:
              # Possible inconsistencies in source files formatting, 'skip' may delete data.
              # If data files obtained lack header, that's a red flag.
              ff.data.raw.lines <-  scan(ff.data.raw, 'character', sep='\n', blank.lines.skip=FALSE, n=15, quiet=TRUE) # n=15 is arbitrary
              header.begin <- which(grepl(header.pattern, ff.data.raw.lines, ignore.case=TRUE)) # if n big, care on potential next header
              ff.data <- read.csv(ff.data.raw, header=TRUE, skip=(header.begin - 1))
              ff.data <- ff.data[-nrow(ff.data), ] # remove file copyright footer
              # monthly data sets contain annual factors too (for countries as well)
              annual.data.check <- grepl("annual*", ff.data[, 1], ignore.case=TRUE)
              split.idx <- which(annual.data.check)
              if (freq == 'annual' & any(annual.data.check)) {
                ff.data.split.raw.lines <- scan(ff.data.raw, 'character', sep='\n', blank.lines.skip=FALSE, skip=(split.idx+header.begin), n=15, quiet=TRUE) # n=15 arbitrary
                extra.header.rel.begin <- which(grepl(header.pattern, ff.data.split.raw.lines, ignore.case=TRUE)) # if n big, care on potential next header
                ff.data.annual <- ff.data[(split.idx+extra.header.rel.begin):nrow(ff.data), ] # remove extra header too
                annual.dates <- as.Date.character(paste0(ff.data.annual[, 1], '-12-31'), '%Y-%m-%d') # arbitrary E-o-Y
                ff.data.annual.xts <- as.xts(as.matrix(ff.data.annual[, -1]), order.by=annual.dates)
                out <- ff.data.annual.xts
              } else if (freq == 'monthly' & any(annual.data.check)) {
                ff.data.monthly <- ff.data[1:(split.idx-1), ]
                # Returns and variables are as of end of month
                yrs <- as.numeric(substr(ff.data.monthly[, 1], 1, 4))
                mos <- as.numeric(substr(ff.data.monthly[, 1], 5, 7))
                # monthly.dates <- as.Date.character(
                #   paste(yrs, mos + 1, '01', sep='-'),
                #   '%Y-%m-%d'
                # )
                # monthly.dates <- as.Date.yearmon(as.yearmon(paste(yrs, mos, sep = "-")), frac = 1)
                monthly.dates <- as.Date.yearmon(as.yearmon(ff.data.monthly$X, format = "%Y%m"), frac = 1)
                # monthly.dates <- monthly.dates - 1
                # artificial.thirteenth.idxs <- which(is.na(monthly.dates))
                # monthly.dates[artificial.thirteenth.idxs] <- as.Date.character(
                #   paste(yrs[yrs != last(yrs)], '12', '31', sep='-'),
                #   "%m/%d/%Y"
                # )[artificial.thirteenth.idxs]
                ff.data.monthly.xts <- as.xts(as.matrix(ff.data.monthly[, -1]), order.by=monthly.dates)
                storage.mode(ff.data.monthly.xts) <- 'numeric'
                # Convert to decimal values
                out <- ff.data.monthly.xts / 100
              } else {# (freq == 'weekly' || freq == 'daily') & ...
                # TODO
              }
              # Rename variables
              ifelse(
                ncol(out) == 1,
                ifelse(
                  x == 'MOM',
                  colnames(out) <- x,
                  colnames(out) <- paste(x, term, sep='.')
                ),
                colnames(out) <- toupper(colnames(out))
              )
            },
            HXZ = {
              base.url <- "http://global-q.org"
              hxz.links <- XML::getHTMLLinks("http://global-q.org/factors.html")
              hxz.factors.links <- grep('factor*', hxz.links, ignore.case=TRUE, value=TRUE)
              hxz.factors.data.links <- grep('*.csv', hxz.factors.links, ignore.case=TRUE, value=TRUE)
              if (x == 'Q5') {
                files.name <- basename(hxz.factors.data.links)
                freq.avail <- sapply(
                  strsplit(files.name, split = '_'), function(x) ifelse(length(x) == 4, x[[3]], x[[4]])
                )
                freq.idx <- match(freq, freq.avail)
                target.url <- hxz.factors.data.links[freq.idx]
                hxz.data.raw <- read.csv(paste0(base.url, target.url))
                if (any(freq == c('daily', 'weekly', 'w2w'))) {
                  yrs <- substr(hxz.data.raw[, 1], 1, 4)
                  mos <- substr(hxz.data.raw[, 1], 5, 6)
                  days <- substr(hxz.data.raw[, 1], 7, 8)
                  dates <- as.Date.character(paste(yrs, mos, days, sep='-'), '%Y-%m-%d')
                } else if (any(freq == c('monthly', 'quarterly'))) {
                  if (freq == 'quarterly') {
                    colnames(hxz.data.raw)[2] <- 'month'
                    # quarters are expressed as "1, 2, 3, 4" in source
                    hxz.data.raw$month <- hxz.data.raw$month * 3
                  }
                  # variables at end-of-month
                  yrs <- hxz.data.raw$year
                  mos <- hxz.data.raw$month
                  monthly.dates <- as.Date.character(
                    paste(yrs, mos + 1, '01', sep='-'),
                    '%Y-%m-%d'
                  )
                  dates <- monthly.dates - 1
                  artificial.thirteenth.idxs <- which(is.na(dates))
                  dates[artificial.thirteenth.idxs] <- as.Date.character(
                    paste(yrs, '12', '31', sep='-'),
                    '%Y-%m-%d'
                  )[artificial.thirteenth.idxs]
                } else if (freq == 'annual') {
                  # arbitrary end-of-year
                  dates <- as.Date.character(paste0(hxz.data.raw[, 1], '-12-31'), '%Y-%m-%d')
                }
                # Convert data set, including all q-factors and the risk-free rate
                hxz.data.xts <- as.xts(
                  hxz.data.raw[, (ncol(hxz.data.raw) - 5):ncol(hxz.data.raw)],
                  order.by=dates
                )
                # Convert to decimal values
                out <- hxz.data.xts / 100
                # Rename variables
                vars <- sapply(strsplit(colnames(out), '_'), function(x) x[2])
                vars[vars=='F'] <- 'RF'
                vars[vars=='MKT'] <- 'MKT.RF'
                colnames(out) <- vars
              }
            }
    )
  }
  return(out)
}
