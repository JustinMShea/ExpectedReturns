objects <- c(ls(envir = .GlobalEnv), 'factor_data', 'class_data', 'regr_data')
source(file.path('inst', 'parsers', 'Value--Devil-in-HMLs-Details.R'))
source(file.path('inst', 'parsers', 'MSCI-WI.R'))
factor_data <- list(HML_Dev = HML_Devil.HML.DEV, ME = HML_Devil.ME_1,
                    MKT_EX = HML_Devil.MKT, SMB = HML_Devil.SMB,
                    UMD = HML_Devil.UMD, WI.RET = MSCI.WI)
factor_vars <- c("HML_Dev", "ME", "MKT_EX","SMB", "UMD", "WI.RET")
nfactor <- length(factor_data)
for (f in 1:nfactor) {
  if ('USA' %in% colnames(factor_data[[f]])) {
    factor_data[[f]] <- factor_data[[f]][, 'USA']
  } else if ('RET' %in% colnames(factor_data[[f]])) {
    factor_data[[f]] <- factor_data[[f]][, 'RET']
  }
  factor_data[[f]] <- data.table(
    "FACTOR" = factor_data[[f]],
    "DATE" = index(factor_data[[f]])
  )
  colnames(factor_data[[f]]) <- c(factor_vars[f], 'DATE')
}
factor_data <- Reduce(function(...) {
  merge(..., by='DATE', all=TRUE)
}, factor_data)

factor_data <- factor_data |>
  na.omit() |>
  as.data.table()

breakpoints <- quantile(factor_data$WI.RET, probs = c(1/3, 2/3))

# Create the new column
factor_data[, signal := ifelse(WI.RET < breakpoints[1], -1,
                               ifelse(WI.RET <= breakpoints[2], 0, 1))]
regr_data <- factor_data[, !'signal']
class_data <- factor_data[, !'WI.RET']
rm(list = setdiff(ls(envir = .GlobalEnv), objects), envir = .GlobalEnv)
