#' Monte Carlo Cross-Validation Splits
#' 
#' Randomly generate \code{M} train/test splits subject to the constraint that
#' all training indices precede the test indices. Useful for randomized error estimates.
#' 
#' @param X Optional \code{data.frame} or \code{matrix}. If provided, the number of rows defines the index sequence.
#' @param y Optional target vector. Not used directly, but often provided alongside `X`.
#' @param index Optional integer vector of indices. Used if \code{X} is \code{NULL}.
#' @param M Integer \(\ge 1\). Number of random splits to generate.
#' @param train_min Integer \(\ge 1\). Minimum size of the training set (i.e.\ \code{t_star} must be \(\ge \text{train_min}\)). Default \code{20L}.
#' @param test_window Integer \(\ge 1\). Number of consecutive points immediately after \code{t_star} to use as test. Default \code{1L}.
#' @param fixed_train_window Logical. If \code{TRUE}, each training set has exactly \code{train_min} points ending at \code{t_star}; if \code{FALSE}, training is all indices \(\le t_star\). Default \code{FALSE}.
#' @param purge Integer \(\ge 0\). Number of indices to skip before each test block. Default is \code{0L}.
#' @param output Character. Either \code{"list"} or \code{"data.table"}. Default \code{"list"}.
#' 
#' @return
#' If \code{output = "list"}, returns a list of length \code{K}, each element containing:
#' \itemize{
#'   \item \code{train}: integer vector of training indices
#'   \item \code{test}: integer vector of test indices
#' }
#' If \code{output = "data.table"}, returns a \code{data.table} with columns:
#' \itemize{
#'   \item \code{split_id}: integer fold ID (1..K)
#'   \item \code{row_id}: actual index values (train or test)
#'   \item \code{set}: factor with levels \code{c("train", "test")}
#' }
#' 



monte_carlo_splits <- function (X = NULL, y = NULL, index = NULL,
                                M, train_min = 20L,
                                test_window = 1L,
                                fixed_train_window = F,
                                purge = 0L,
                                output = c("list", "data.table")) {
  output <- match.arg(output)
  
  if (!is.null(X)) {
    n <- nrow(X)
    index <- seq_len(n)
  } else if (!is.null(index)) {
    n <- length(index)
  } else {
    stop("You must provide at least one of X or index.")
  }
  
  if (!is.numeric(M) | M < 1L) {
    stop("`M` must be a positive integer.")
  }
  M <- as.integer(M)
  if (!is.numeric(train_min) | train_min < 1L) {
    stop("`train_min` must be a positive integer.")
  }
  train_min <- as.integer(train_min)
  if (!is.numeric(test_window) | test_window < 1L) {
    stop("`test_window` must be a positive integer.")
  }
  test_window <- as.integer(test_window)
  if (is.numeric(purge) | purge < 0L) {
    stop("`purge` must be a non-negative integer.")
  }
  purge <- as.integer(purge)
  if ((train_min + purge + test_window + M) > (n + 1L)) {
    stop("Not enough data.")
  }
  
  splits <- list()
  
  for (m in seq_len(M)) {
    possible_stars <- seq(train_min, n - test_window - purge)
    t_star <- sample(possible_stars, 1L)
    
    if (!fixed_train_window) {
      train <- index[1:t_star]
    } else {
      train <- index[(t_star - train_min + 1L):t_star]
    }
    test <- index[(t_star + purge + 1L):(t_star + purge + test_window)]
    
    splits[[m]] <- list(train = train, test = test)
  }
  
  if (output == "list") return(splits)
  
  out <- data.table::rbindlist(
    lapply(seq_along(splits), function(i) {
      train <- splits[[i]]$train
      test <- splits[[i]]$test
      list(split_id = i,
           row_id = c(train, test),
           set = c(rep("train", length(train)), rep("test", length(test)))
      )
    })
  )
  data.table::setDT(out)[, set := factor(set, levels = c("train", "test"))]
  return(out)
}