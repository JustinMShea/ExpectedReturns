min_max_rescale <- function(data,
                            varnames = NULL,
                            method = "standard") {
  # Note to self: Convert data to data.table if not already

  # Validate the method input
  if (!method %in% c("standard", "wide")) {
    stop("Error: method must be 'standard [0,1]' or 'wide [-1,1]'")
  }

  # If varnames is NULL, use all column names
  if (is.null(varnames)) {
    varnames <- colnames(data)
  }

  # Min-max rescale for each variable
  for (variable in varnames) {
    col_min <- min(data[[variable]], na.rm = TRUE)
    col_max <- max(data[[variable]], na.rm = TRUE)

    if (method == "standard") {
      # Rescale to [0, 1]
      data[[variable]] <- (data[[variable]] - col_min) / (col_max - col_min)
    } else if (method == "wide") {
      # Rescale to [-1, 1]
      data[[variable]] <- 2 * (data[[variable]] - col_min) / (col_max - col_min) - 1
    }
  }

  return(data)
}

standardize <- function(data,
                        varnames = NULL) {
  # Note to self: Convert data to data.table if not already

  # If varnames is NULL, use all column names
  if (is.null(varnames)) {
    varnames <- colnames(data)
  }

  # Min-max rescale for each variable
  for (variable in varnames) {
    col_mean <- mean(data[[variable]], na.rm = TRUE)
    col_sd <- sd(data[[variable]], na.rm = TRUE)
    data[[variable]] <- (data[[variable]] - col_mean) / col_sd
  }

  return(data)
}

uniformize <- function(data,
                       varnames = NULL) {
  # Note to self: Convert data to data.table if not already

  # If varnames is NULL, use all column names
  if (is.null(varnames)) {
    varnames <- colnames(data)
  }

  # Uniformize each variable
  for (variable in varnames) {
    # Compute the empirical CDF values
    ranks <- rank(data[[variable]], na.last = "keep", ties.method = "average")
    data[[variable]] <- ranks / (length(ranks) + 1)
  }

  return(data)
}
