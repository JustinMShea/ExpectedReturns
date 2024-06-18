min_max_rescale <- function(data,
                            ts_var = NULL,
                            cs_var = NULL,
                            varnames = NULL,
                            method = "standard") {
  # Note to self: Convert data to data.table if not already

  # Validate the method input
  if (!method %in% c("standard", "wide")) {
    stop("Error: method must be 'standard' or 'wide'")
  }

  # If varnames is NULL, use all column names except ts_var and cs_var
  if (is.null(varnames)) {
    varnames <- setdiff(colnames(data), c(ts_var, cs_var))
  }

  # Min-max rescale for each variable separately by ts_var and cs_var
  data[, (varnames) := lapply(.SD, function(x) {
    if (method == "standard") {
      # Rescale to [0, 1]
      (x - min(x, na.rm = TRUE)) / (max(x, na.rm = TRUE) - min(x, na.rm = TRUE))
    } else if (method == "wide") {
      # Rescale to [-1, 1]
      2 * (x - min(x, na.rm = TRUE)) / (max(x, na.rm = TRUE) - min(x, na.rm = TRUE)) - 1
    }
  }), by = ts_var, .SDcols = varnames]

  return(data)
}

standardize <- function(data,
                        ts_var = NULL,
                        cs_var = NULL,
                        varnames = NULL) {
  # Note to self: Convert data to data.table if not already

  # If varnames is NULL, use all column names
  if (is.null(varnames)) {
    varnames <- setdiff(colnames(data), c(ts_var, cs_var))
  }

  # Standardize each variable separately by ts_var and cs_var
  data[, (varnames) := lapply(.SD, function(x) {
    mean_x <- mean(x, na.rm = TRUE)
    sd_x <- sd(x, na.rm = TRUE)
    (x - mean_x) / sd_x
  }), by = ts_var, .SDcols = varnames]

  return(data)
}

uniformize <- function(data,
                       ts_var = NULL,
                       cs_var = NULL,
                       varnames = NULL) {
  # Note to self: Convert data to data.table if not already

  # If varnames is NULL, use all column names
  if (is.null(varnames)) {
    varnames <- setdiff(colnames(data), c(ts_var, cs_var))
  }

  # Uniformize each variable
  data[, (varnames):= lapply(.SD, function(x) {
    ranks_x <- rank(x, na.last = "keep", ties.method = "average")
    ranks_x / (length(ranks) + 1)
  }), by = ts_var, .SD.cols = varnames]

  return(data)
}
