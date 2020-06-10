#' @title Scraping Academic Financial Data Libraries
#'
#' This is a convenience function to provide an easy way to download research
#' financial data sets from several accredited sources.
#' Specifically, it allows to import them in the `R` environment as `xts` objects.
#'
#' The scientific libraries here contemplated are from several researchers as,
#' unfortunately, an open source systematic collection is not available at this
#' time. On one hand, these resources - of admirable effort - lack important features
#' (financial) databases guarantee; most notably, this results in the impossibility
#' to leverage APIs as in most cases there aren't any.
#' On the other hand, these data sets satisfy important characteristics: they are
#' open sourced, public and free to use, collected by world renewed Researchers
#' of the field.
#'
#' TODO: provide a general overview of data made available
#'
#' Please be considerate while using the function. In particular, do not send too
#' frequent requests to the web source as the supported/tolerated request rate is
#' unknown. Usage remains at your own discretion and responsibility.
#' TODO: deal with loops internally so to include some sleeping time?
#'
#' All the credits for collecting, maintaining and sharing data belong to the
#' mentioned authors or copyright holders (see 'sources' below).
#'
#' @source
#' [Kenneth F. French's data library](http://mba.tuck.dartmouth.edu/pages/faculty/ken.french/data_library.html),
#' [Robert Shiller's online data](http://www.econ.yale.edu/~shiller/data.htm),
#' [AQR data sets](https://www.aqr.com/Insights/Datasets)
#'
#' @param x A character specifying the query specifying the data set to download. One of 'FF3', 'FF5', 'MOM' or 'REV'. See 'Details'.
#' @param src A character, the source to download data from. Currently only "FF" (default) is available.
#' @param freq A character, specifying . One of 'annual', 'monthly', 'weekly' or 'daily'. See 'Details'.
#' @param term A character, to provide when `x='REV'`. Either 'ST' (short-term, default) or 'LT' (long term).
#' @param verbose A boolean, whether or not to retrieve additional info on data sets being downloaded.
#'
#' @return
#' An `xts` object with columns being the requested factors.
#'
#' @details
#' With respect to the Fama-French's library, the parameter `x` specifies the
#' factors required, which can be the Fama-French Three factor model (`'FF3'`),
#' Fama-French Five factor model (`'FF5'`), The Momentum factor model (`'MOM'`) or
#' The Reversal model (`'REV'`).
#'
#' When `x` is used as "y/z" it provides additional specifications
#' on the data set to be queried with the syntax "model/country" (position matters).
#' Countries made available are 'Asia Pacific ex Japan', 'Developed', Developed ex US',
#' 'Emerging', 'Europe', 'Japan', 'North America' and 'United States'.
#'
#' Also, note that not all the Fama-French's series are available with all the
#' possible frequencies of `freq`.
#'
#' @author Vito Lestingi
#'
#' @examples
#' GetFactors('FF3', src='FF')
#'
#' @export GetFactors
#'
GetFactors <- function(x
                       , src="FF"
                       , freq="monthly"
                       , term="ST"
                       # , country=NULL
                       , verbose=FALSE)
{
  require(xts) # TODO: momentary
  require(XML)
  src.available <- c("FF")
  if(all(src != src.available)) {
    stop("src = ", sQuote(src), " is not currently implemented.")
  } else {
    source <- match.arg(src, src.available)
    freq <- c("annual", "monthly", "weekly", "daily")
    switch (source,
            FF = {
              # Get all FF web targets on factors
              base.url <- "http://mba.tuck.dartmouth.edu/pages/faculty/ken.french/"
              ff.links <- XML::getHTMLLinks("http://mba.tuck.dartmouth.edu/pages/faculty/ken.french/data_library.html")
              ff.factors.links <- grep('factor*', ff.links, ignore.case=TRUE, value=TRUE)
              ff.factors.data.links <- grep('csv', ff.factors.links, ignore.case=TRUE, value=TRUE) # txt files avilable too
              # Identify web target to query
              x <- unlist(strsplit(x, '/'))
              if(length(x) == 1) {# standard Fama-French's factors
                # Exclude countries
                # Exclude countries and select data frequency
                # NOTE:
                # Although 'monthly' is FF's default, they don't spell it in file names.
                # A way of proceeding in this case is by exclusion.
                # Also, their 'monthly' data files include annual data.
                plain.idxs <- grep('f-f', ff.factors.data.links, ignore.case=TRUE)
                if (freq == 'daily' || freq == 'weekly') {
                  idxs <- intersect(plain.idxs, grep(freq, ff.factors.data.links, ignore.case=TRUE))
                } else if (freq == 'monthly' || freq == 'annual') {
                  idxs <- setdiff(plain.idxs, union(grep('daily', ff.factors.data.links, ignore.case=TRUE), grep('weekly', ff.factors.data.links, ignore.case=TRUE)))
                }
                ff.factors.plain.links <- ff.factors.data.links[idxs]
                x <- match.arg(x, c('FF3', 'FF5', 'MOM', 'REV'))
                switch (x,
                        FF3 = {
                          # TODO: should be by exclusion instead
                          target.url <- grep("ftp/F-F_Research_Data_Factors_CSV.zip", ff.factors.plain.links, ignore.case=TRUE, value=TRUE)
                        },
                        FF5 = {
                          target.url <- grep('5', ff.factors.plain.links, ignore.case=TRUE, value=TRUE)
                        },
                        MOM = {
                          target.url <- grep('mom*?', ff.factors.plain.links, ignore.case=TRUE, value=TRUE)
                        },
                        REV = {
                          if (term == 'ST' || term == 'LT') {
                            target.url <- grep(term, ff.factors.plain.links, ignore.case=TRUE, value=TRUE)
                          } else {
                            stop("term = ", sQuote(term), " is not recognized. \nEither use 'ST' or 'LT'.")
                          }
                        }
                )
              } else {# x = model/country
                # TODO
                ff.model <- x[1]
                country <- x[2]
                idx <- union(grep(ff.model, ff.factors.data.links), grep(country, ff.factors.data.links))
                target.url <- ff.factors.data.links[idx]
              }
            }
    )
    # Download and format web source identified
    temp.file <- tempfile()
    download.file(paste0(base.url, target.url), temp.file)
    ff.data.raw <- unzip(temp.file)
    #
    # TODO:
    # Code below needs to be generalized.
    # Clearly, it's currently too specialized towards FF3, which I used as a
    # proof of concept (see @examples).
    #
    # Clean comments lines and leave data only
    # TODO: inconsistencies in source files formatting, 'skip' may delete data!
    # TODO: nice to add who's the underlying provider (e.g., CRSP, Bloomberg)
    ff.data <- read.csv(ff.data.raw, skip=3)
    ff.data <- ff.data[-nrow(ff.data), ] # remove copyright footer
    # monthly data sets contain annual factors too, split the two
    annual.data.check <- grepl("annual*", ff.data[, 1], ignore.case=TRUE)
    if (any(annual.data.check)) {
      split.idx <- which(annual.data.check)
      ff.data.annual <- ff.data[(split.idx+2):nrow(ff.data), ] # remove extra header too
      ff.data.monthly <- ff.data[1:(split.idx-1), ]
    }

    annual.dates <- as.Date.character(paste0(ff.data.annual[ ,1], '-12-31'), '%Y-%m-%d') # arbitrary EoY
    ff.data.annual.xts <- as.xts(ff.data.annual[, -1], order.by=annual.dates)
    storage.mode(ff.data.annual.xts) <- 'numeric'

    monthly.dates <- as.Date.character(paste(substr(ff.data.monthly[, 1], 1, 4), substr(ff.data.monthly[, 1], 5, 7), '01', sep='-'), '%Y-%m-%d') # arbitrary beginning of month
    ff.data.monthly.xts <- as.xts(ff.data.monthly[, -1], order.by=monthly.dates)
    storage.mode(ff.data.monthly.xts) <- 'numeric'

    if (verbose) {
      # TODO: include Fama-French's data 'details' to provide factor construction info
    }
  }
  out <- list(ff.data.annual.xts = ff.data.annual.xts, ff.data.monthly.xts = ff.data.monthly.xts)
  return(out)
}
