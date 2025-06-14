#' Generate Rolling Window Cross-Validation Splits
#' 
#' Creates training and testing indices for rolling window cross-validation.
#' 
#' @param X Optional \code{data.frame} or \code{matrix}. If provided, the number of rows defines the index sequence.
#' @param y Optional target vector. Not used directly, but often provided alongside `X`.
#' @param index Optional integer vector of indices. Used if \code{X} is \code{NULL}.
#' @param folds Integer. Number of folds (splits) to generate. If NULL, calculated from `train_window`.
#' @param train_window Integer. Number of observations in each training window. If NULL, calculated from `folds`.
#' @param test_window Integer. Number of observations in each testing window. Default is 1L.
#' @param purge Integer. Number of observations to skip between train and test windows. Default is 0L.
#' @param min_train_window Integer. Minimum allowed size for `train_window`. Default is 20L.
#' @param output Character. Either \code{"list"} or \code{"data.table"}. Default \code{"list"}.
#'   \describe{
#'     \item{"list"}{A list of length `folds`, where each element is a list with `train` and `test` index vectors.}
#'     \item{"data.table"}{A `data.table` with columns `split_id`, `row_id`, and `set` indicating train/test membership.}
#'   }
#'
#' @return 
#' If \code{output = "list"}, returns a list of length \code{K}, where each element is a list with two components:
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
#' @examples

rolling_window_splits <- function(X = NULL, y = NULL, index=NULL,
                                  folds = NULL, train_window = NULL,
                                  test_window = 1L, purge = 0L,
                                  min_train_window = 20L,
                                  output = c("list", "data.table")) {
  output = match.arg(output)
  
  if (!is.null(X)) {
    n <- nrow(X)
    index <- seq_len(n)
  } else if (!is.null(index)) {
    n <- length(index)
  } else {
    stop("You must provide at least one of X or index.")
  }
  
  if (is.null(folds) & is.null(train_window)) {
    stop("You must provide at least either `folds` or `train_window`.")
  } else if (is.null(folds)) {
    folds <- n - (train_window + test_window + purge) + 1L
  } else if (is.null(train_window)) {
    train_window <- n - (folds + test_window + purge) + 1L
  }
  
  if ((folds < 2) | (train_window < min_train_window) | (n <= (train_window + test_window + purge))) {
    stop("More data needed for the specified parameters")
  }
  if (folds > 0.5 * n) {
    warning("Number of folds (", folds, ") is large and may lead to high computation time.")
  }
  
  splits <- list()
  start = n - (train_window + purge + test_window + folds) + 1L
  for (i in seq_len(folds)) {
    start_i <- start + i
    train <- index[start_i:(start_i + train_window - 1L)]
    test <- index[(start_i + train_window + purge):(start_i + train_window + purge + test_window - 1L)]
    splits[[i]] <- list(train = train, test = test)
  }
  
  if (output == "list") return(splits)
  
  out = data.table::rbindlist(
    lapply(seq_along(splits), function(i) {
      train <- splits[[i]]$train
      test <- splits[[i]]$test
      list(
        split_id = i,
        row_id = c(train, test),
        set = c(rep("train", length(train)), rep("test", length(test)))
      )
    })
  )
  data.table::setDT(out)[, set := factor(set, levels = c("train", "test"))]
  return(out)
}