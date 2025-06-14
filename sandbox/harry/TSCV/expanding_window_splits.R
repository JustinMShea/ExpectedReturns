#' Generate Expanding Window Cross-Validation Splits
#' 
#' Creates training and testing indices for expanding window (rolling origin) cross-validation.
#' 
#' @param X Optional \code{data.frame} or \code{matrix}. If provided, the number of rows defines the index sequence.
#' @param y Optional target vector. Not used directly, but often provided alongside `X`.
#' @param index Optional integer vector of indices. Used if \code{X} is \code{NULL}.
#' @param folds Integer. Number of folds (splits) to generate. If NULL, calculated automatically based on data length and window sizes.
#' @param min_train_window Integer. Minimum number of observations in the first training window. Default is 20L.
#' @param test_window Integer. Number of observations in each testing window. Default is 1L.
#' @param purge Integer. Number of observations to skip between train and test windows. Default is 0L.
#' @param output Character. Either \code{"list"} or \code{"data.table"}. Default \code{"list"}.
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
#' 

expanding_window_splits <- function(X = NULL, y = NULL, index = NULL,
                                    folds = NULL, min_train_window = 20L,
                                    test_window = 1L, purge = 0L,
                                    output = c("list", "data.table")) {
  if (!is.null(X)){
    n <- nrow(X)
    index <- seq_len(n)
  } else if (!is.null(index)) {
    n <- length(index)
  } else {
    stop("You must provide at least one of X or index.")
  }
  
  if (is.null(folds)){
    folds <- n - (min_train_window + purge + test_window) + 1L
  }
  
  first_train_window = n - (folds + purge + test_window) + 1L
  
  if ((folds < 2) | (n <= (min_train_window + purge + test_window))) {
    stop("More data needed for the specified parameters")
  }
  
  if (folds > 0.5 * n) {
    warning("Number of folds (", folds, ") is large and may lead to high computation time.")
  }
  
  splits <- list()
  for (i in seq_len(folds)){
    train <- index[1:(first_train_window + i - 1L)]
    test <- index[(first_train_window + i + purge):(first_train_window + i + purge + test_window - 1L)]
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
