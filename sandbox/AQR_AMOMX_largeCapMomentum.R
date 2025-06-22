#' Generate AQR AMOMX portfolio holdings data.
#'
#' Runs and renews AQR Large Cap Momentum Style Fund Class I data (AQR.AMOMX.RData) in 'ExpectedReturns/sandbox/data'
#' based on AQR methodology. The fund is designated as an institutional share class and retail investors cannot trade it.
#'
#' [AQR's portfolio methodology description](https://www.aqr.com/Insights/Datasets/Momentum-Indices-Monthly)
#'
#' [In-depth PDF](https://www.aqr.com/-/media/AQR/Documents/Insights/Data-Sets/AQR-Momentum-Index-Methodology.pdf)
#'
#' This portfolio is constructed from the following criteria:
#'
#' The top 333 stocks by trailing 12 month returns minus the final month are selected out of a universe of the top 1,000 stocks
#' fitting these criteria:
#'
#' - NYSE/NASDAQ listed*
#' - Is a U.S. company
#' - Company type*
#' - Trailing three-month median trading volume of >$100k
#' - IPO seasoning of >12 months
#' - If company has multiple version of stock only most liquid is selected (think BRK, only class A or B will be selected)
#' - Company cannot be the target of an announced acquisition or merger
#'
#' (* - exact details specified within PDF)
#'
#' AQR reallocates this portfolio quarterly.


library(qkiosk)
library(quantmod)
library(FactorAnalytics)
