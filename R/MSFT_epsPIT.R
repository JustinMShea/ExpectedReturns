#' @title Microsoft Earnings Per Share Point in Time Data Set
#'
#' @docType data
#'
#' @description
#' 'MSFT_epsPIT' is data on earnings per share at point in time of Microsoft going back to 2011-07-28,
#' up to 2025-04-30*. This means the EPS values we use are the original, first-released values that MSFT 
#' released in their financial statements, this data ignores restatements of eps values. For restated values
#' use MSFT_epsRes.
#'
#' *Can run MSFT_wso.R parser to obtain present day data. Needs library quantkiosk and API
#' key (free non-institutional version available online).
#'
#' @usage
#' data("MSFT_epsPIT")
#'
#' @format
#' A `data.frame` object containing observations on return data for Microsoft.
#'
#' * __fq__: Earnings per share at that point in time.
#' * __filed__: Quarterly frequency from 2011-07028 to 2025-04-30.
#'
#' The object consists of 60 rows and 2 columns.
#'
#' @source
#' quantkiosk
#'
#' @examples
#' data(MSFT_epsPIT)
#'
#' head(MSFT_epsPIT)
#'
"MSFT_epsPIT"
