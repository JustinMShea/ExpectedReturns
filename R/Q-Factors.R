#' @title Hou-Xue-Zhang q-factor Five-Factors Data Set
#'
#' @docType data
#'
#' @description
#' `Q5.monthly` is the Hou-Mo-Xue-Zhang (2020) q-factor five-factors monthly data
#' series on U.S. stock market from 1967-01 to 2019-12. The data set also includes
#' the risk-free rate on 1-month U.S. T-Bill during the same period.
#'
#' @usage
#' data("Q5.monthly")
#'
#' @format
#' An `xts` object containing observations of Hou-Mo-Xue-Zhang q-factor five-factors
#' data set on U.S. Stock Market, and the risk-free rate on 1-month U.S. T-Bill.
#'
#' * __Frequency__: Monthly.
#' * __Date Range__: 1967-01 to 2019-12.
#' * __Data updated__: 2020-08-20 19:19:20 CEST.
#' * __RF__: A numeric. The risk-free rate on 1-month U.S. T-Bill. See 'RF variable' section below.
#' * __MKT.RF__: A numeric. The market portfolio proxy return net of risk-free rate factor. See 'MKT.RF factor' section below.
#' * __ME__: A numeric. The size factor. See 'ME factor' section below.
#' * __IA__: A numeric. The investment factor. See 'IA factor' section below.
#' * __ROE__: A numeric. The profitability factor. See 'ROE factor' section below.
#' * __EG__: A numeric. The "Expected Growth" factor. See 'EG factor' section below.
#'
#' The object consists of 636 rows and 6 columns.
#'
#' @details
#' In addition to column definitions, this section contains a glimpse into factors
#' construction and their underlying variables.
#'
#' @template construction-factor-q
#' @template variable-rf
#' @template variable-be
#' @template variable-me
#' @template variable-ia
#' @template variable-roe
#' @template factor-mktrf
#' @template factor-me
#' @template factor-ia
#' @template factor-roe
#' @template factor-eg
#'
#' @references
#' Hou, K. and Mo, H. and Xue, C. and Zhang, L. (2019). *Which factors?*. Review of Finance.
#'
#' Hou, K. and Mo, H. and Xue, C. and Zhang, L. (2020). *An augmented q-factor model with expected growth*. Review of Finance.
#'
#' @source
#' [global-q.org](http://global-q.org/index.html),
#' [Technical Document: Factors](http://global-q.org/uploads/1/2/2/6/122679606/factorstd_2020july.pdf)
#'
#' @seealso
#' The series was generated with [ExpectedReturns::GetFactors()].
#'
#' @examples
#' data(Q5.monthly)
#'
#' head(Q5.monthly)
#'
"Q5.monthly"

#' @title Hou-Xue-Zhang q-factor Four-Factors Data Set
#'
#' @docType data
#'
#' @description
#' `Q4.monthly` is the Hou-Xue-Zhang q-factor four-factors monthly data series on
#' U.S. stock market from 1967-01 to 2019-12. The data set also includes the risk-free
#' rate on 1-month U.S. T-Bill during the same period.
#'
#' @usage
#' data("Q4.monthly")
#'
#' @format
#' An `xts` object containing observations of Hou-Xue-Zhang (2015) q-factor
#' four-factors data set on U.S. Stock Market, and the risk-free rate on 1-month
#' U.S. T-Bill.
#'
#' * __Frequency__: Monthly.
#' * __Date Range__: 1967-01 to 2019-12.
#' * __Data updated__: 2020-08-20 19:32:19 CEST.
#' * __RF__: A numeric. The risk-free rate on 1-month U.S. T-Bill. See 'RF variable' section below.
#' * __MKT.RF__: A numeric. The market portfolio proxy return net of risk-free rate factor. See 'MKT.RF factor' section below.
#' * __ME__: A numeric. The size factor. See 'ME factor' section below.
#' * __IA__: A numeric. The investment factor. See 'IA factor' section below.
#' * __ROE__: A numeric. The profitability factor. See 'ROE factor' section below.
#'
#' The object consists of 636 rows and 6 columns.
#'
#' @details
#' In addition to column definitions, this section contains a glimpse into factors
#' construction and their underlying variables.
#'
#' @template construction-factor-q
#' @template variable-rf
#' @template variable-be
#' @template variable-me
#' @template variable-ia
#' @template variable-roe
#' @template factor-mktrf
#' @template factor-me
#' @template factor-ia
#' @template factor-roe
#'
#' @references
#' Hou, K. and Xue, C. and Zhang, L. (2015). *Digesting Anomalies: An Investment Approach*. The Review of Financial Studies.
#'
#' Hou, K. and Mo, H. and Xue, C. and Zhang, L. (2019). *Which factors?*. Review of Finance.
#'
#' @source
#' [global-q.org](http://global-q.org/index.html),
#' [Technical Document: Factors](http://global-q.org/uploads/1/2/2/6/122679606/factorstd_2020july.pdf)
#'
#' @seealso
#' The series was generated with [ExpectedReturns::GetFactors()].
#'
#' @examples
#' data(Q4.monthly)
#'
#' head(Q4.monthly)
#'
"Q4.monthly"
