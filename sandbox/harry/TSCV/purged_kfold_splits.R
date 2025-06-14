#' Purged K-Fold Cross-Validation Splits
#' 
#' Partition a time-series index into \code{K} contiguous blocks. For each fold \code{i}:
#' \enumerate{
#'   \item Skip (purge) the \code{purge} indices immediately preceding the \code{i}th block,
#'   \item Use all remaining indices before the purge as \code{train},
#'   \item Use the \code{i}th block itself as \code{test}.
#' }
#' 
#' @param X Optional \code{data.frame} or \code{matrix}. If provided, the number of rows defines the index sequence.
#' @param y Optional target vector. Not used directly, but often provided alongside `X`.
#' @param index Optional integer vector of indices. Used if \code{X} is \code{NULL}.
#' @param folds Integer \(\ge 2\). Number of folds (blocks).
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

purged_kfold_splits <- function(X = NULL, y = NULL, index = NULL,
                                folds, purge = 0L, output = c("list", "data.table")) {
  output <- match.arg(output)
  
  if (!is.null(X)) {
    n <- nrow(X)
    index <- seq_len(n)
  } else if (!is.null(index)) {
    n <- length(index)
  } else {
    stop("You must provide at least one of X or index.")
  }
  
  if (!is.numeric(folds) | folds < 2L) {
    stop("`folds` must be an integer >= 2.")
  }
  folds <- as.integer(folds)
  
  if (!is.numeric(purge) | purge < 0L) {
    stop("`purge` must be a non-negative integer")
  }
  purge <- as.integer(purge)
  
  base_size <- floor(n / (folds + 1L))
  if (base_size < 1L) {
    stop("`folds` is too large for the data length.")
  }
  last_size <- n - folds * base_size
  
  splits <- list()
  for (i in seq_len(folds)) {
    start_i <- i * base_size + 1L
    if (i < (folds)) {
      end_i <- (i + 1L) * base_size
    } else {
      end_i <- n
    }
    train <- index[i:(start_i-purge-1L)]
    test <- index[start_i:end_i]
    splits[[i]] <- list(train = train, test = test)
  }
  
  if (output == "list") return(splits)
  
  out <- data.table::rbindlist(
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