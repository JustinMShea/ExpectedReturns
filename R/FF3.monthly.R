#' @title Fama-French 3 Factors Data Set
#'
#' @docType data
#'
#' @description
#' `FF3.monthly` is the Fama-French Factors monthly data series on U.S. stock market from 1926-07 to 2020-04.
#'
#' @section Generated from GetFactors():
#' See GetFactors.
#'
#' @usage data(FF3.monthly)
#'
#' @format
#' An `xts` object containing observations of Fama-French Factors on US Stock
#' Market 1926-2020. The object consists of 1126 rows and 4 columns.
#' Refer to 'Details' for column variables definitions and their construction.
#'
#' @details
#'
#' @template construction-factor-ff3
#' @template variable-me
#' @template variable-be
#' @template variable-bm
#' @template portfolios-6-size-bm
#' @template variable-rf
#' @template factor-mktrf
#' @template factor-smb
#' @template factor-hml
#'
#' @template general-missing-data
#' @template general-data-providers
#' @template general-french-copyright
#'
#' @source
#' [Kenneth F. French's data library](http://mba.tuck.dartmouth.edu/pages/faculty/ken.french/data_library.html)
#'
#' @examples
#' data(FF3.monthly)
#'
#' head(FF3.monthly)
#'
"FF3.monthly"
