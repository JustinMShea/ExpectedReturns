library(zoo)

#' Use the triple-barrier labeling method to create classification labels
#'
#' @description
#' Create triple-barrier labels as introduced by Lopez de Prado (2018). Labels are created according to the first barrier touched by the time-series. Two horizontal barriers are defined by profit-taking and stoploss limits, and the third vertical barrier is the expiration barrier.
#'
#' @section Usage:
#' ## No vertical barrier
#' triple_barrier(obj, events, ptsl = c(1, 1, 0), ...)
#' ## Specify vertical barrier
#' triple_barrier(obj, events, ptsl = c(1, 1, 10), ...)
#' ## Specify minimal profit-taking level
#' triple_barrier(obj, events, ptsl, min_return = 0.1, ...)
#' ## Specify horizontal targets
#' triple_barrier(obj, events, ptsl, target)
#'
#' @section Arguments:
#' @param obj a TSML object
#' @param events a list of index for the triple-barrier labels. If set to NULL, all rows will be calculated.
#' @param ptsl a list for the three barrier levels. Turned on by setting the level to positive values. Turn off by setting the level to 0.
#' @param min_return a numeric value for the minimum profit-taking level.
#' @param target a numeric or a string for specifying the horizontal target. Set a return target if a numeric is passed; set to a column value if a string is passed; set to historical volatility if NULL is passed.
#' @param ... additional arguments to be passed. If target is set to NULL, can pass lookback to set the historical volatility look-back window.


triple_barrier <- function(obj,
                           events = NULL,
                           ptsl = c(1, 1, 0),
                           min_return = NULL,
                           target = NULL,
                           ...) {

  data <- obj$data
  y <- obj$y

  if (!is.null(target)) {
    if (is.numeric(target)) {
      data[, "return_target" := abs(target)]
      target = "return_target"
    } else if (is.character(target)) {
      if (!target %in% names(data)) {
        stop("Error: target not defined.")
      }
    } else {
      stop("Error: target must either be a numeric or a character.")
    }
  } else {
    data[, "daily_vol" := get_daily_vol(get(y), lookback)]
    target = "daily_vol"
  }

  if (is.null(events)) {
    events <- setdiff(seq(1, nrow(data) - ptsl[3]), which(is.na(data[, ..target])))
  }

  data[, "tbl" := get_barrier_labels(get(y), events, ptsl, min_return, get(target))]
}



get_daily_vol <- function(returns, lookback) {
  daily_vol <- rollapply(returns, width = lookback, FUN = sd, fill = NA, align = "right")
  return(daily_vol)
}

get_barrier_labels <- function(returns,
                               events,
                               ptsl = c(1, 1, 0),
                               min_return = NULL,
                               target) {
  # Initialize the tbl vector to NA
  tbl <- rep(NA_real_, length(returns))

  # Iterate over each event index
  for (i in events) {

    # Define the upper and lower barriers based on the target column
    upper_bar <- max(target[i] * ptsl[1], min_return)
    lower_bar <- target[i] * -ptsl[2]

    # Get the end of the vertical barrier or the end of the data, whichever comes first
    end_idx <- min(i + ptsl[3], length(returns))

    # Calculate cumulative returns from the current index to the end of the vertical barrier
    cumulative_returns <- cumsum(returns[i:end_idx])

    # Check if the upper or lower bar is crossed first
    upper_cross <- which(cumulative_returns >= upper_bar)[1]
    lower_cross <- which(cumulative_returns <= lower_bar)[1]

    # Determine the value for tbl
    if (!is.na(upper_cross) && !is.na(lower_cross)) {
      # Both bars are crossed, determine which comes first
      if (upper_cross < lower_cross) {
        tbl[i] <- 1
      } else {
        tbl[i] <- -1
      }
    } else if (!is.na(upper_cross)) {
      # Only the upper bar is crossed
      tbl[i] <- 1
    } else if (!is.na(lower_cross)) {
      # Only the lower bar is crossed
      tbl[i] <- -1
    } else {
      # Neither bar is crossed within the vertical limit
      tbl[i] <- 0
    }
  }

  return(tbl)
}
