#' Stratified Block-Fold Cross-Validation Splits
#' 
#' Partition the series into \code{folds} contiguous blocks, ensuring that each
#' block (test fold) contains at least one observation from every level of a provided
#' \code{strata} factor. If exact stratification is impossible, blocks will be adjusted
#' to include all levels, but final blocks may vary in size.
#' 
#' @param X Optional \code{data.frame} or \code{matrix}. If provided, the number of rows defines the index sequence.
#' @param y Optional target vector. Not used directly, but often provided alongside `X`.
#' @param index Optional integer vector of indices. Used if \code{X} is \code{NULL}.
#' @param strata A vector or factor of length \code{n} indicating the stratum for each index.
#' @param folds Integer \(\ge 2\). Number of folds (blocks).
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

stratified_block_splits <- function(X = NULL, y = NULL, index = NULL,
                                    strata, folds, purge = 0L,
                                    output = c("list", "data.table")) {
  output <- match.arg(output)
  
  if (is.null(X)) {
    n <- nrow(X)
    index <- seq_len(n)
  } else if (!is.null(index)) {
    n <- length(index)
  } else {
    stop("You must provide at least one of X or index.")
  }
  
  if (length(strata) != n) {
    stop("`strata` must be the same length as `index` (or rows of X).")
  }
  strata <- as.factor(strata)
  levels_strata <- levels(strata)
  num_levels <- length(levels_strata)
  
  if (!is.numeric(folds) | folds < 2L) {
    stop("`folds` must be an integer >= 2.")
  }
  folds <- as.integer(folds)
  
  freq_table <- table(strata)
  if (any(freq_table < folds)) {
    warning("Some strata levels have fewer than `folds` occurances; perfect stratification may be impossible.")
  }
  
  base_size <- floor(n / (folds + 1L))
  if (base_size < num_levels) {
    warning("Base block size is less than the number of strata levels; forcing larger blocks for coverage.")
  }
  blocks <- list()
  start_pos <- rep(0L, folds)
  end_pos <- rep(0L, folds)
  
  for (i in seq_len(folds)) {
    start_pos[i] <- i * base_size + 1L
    if (i < folds) {
      end_pos[i] <- (i + 1L) * base_size
    } else {
      end_pos[i] <- n
    }
  }
  
  for (i in seq_len(folds)) {
    curr_start <- start_pos[i]
    curr_end <- end_pos[i]
    
    while (TRUE) {
      block_strata <- strata[curr_start:curr_end]
      if (all(levels_strata %in% block_strata)) {
        break
      }
      if (i == folds && curr_end == n) {
        warning(sprintf(
          "Block %d cannot contain all strata levels even when extended to the end.", i
        ))
        break
      } 
      
      next_boundary <- if(i < folds) end_pos[i + 1] else n
      if (curr_end < next_boundary) {
        curr_end <- curr_end + 1L
      } else {
        warning(sprintf(
          "Block %d cannot contain all strata levels without overlapping block %d+1.", i, i
        ))
        break
      }
    }
    
    end_pos[j] <- curr_end
    blocks[[j]] <- index[curr_start:curr_end]
    
    if (i < folds) {
      start_pos[i + 1] <- end_pos[i] + 1L
    }
  }
  
  splits <- list()
  for (i in seq_len(folds)) {
    test <- blocks[[j]]
    train <- index[1:(start_pos[i] - 1L)]
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