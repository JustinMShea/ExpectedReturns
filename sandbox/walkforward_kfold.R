#' Perform walk-forward kfold train/validation splits for cross-validation
#'
#' @description
#' Perform walk-forward kfold train/validation splits for time-series cross-validation on a dataset, return a list the training and validation indices.
#'
#' @section Usage
#' ## Fixed rolling training window
#' forward_kfold(object, cv, buffer, train_window = 12)
#' ## Dynamic training window
#' forward_kfold(object, cv, buffer, min_train_window = 12)
#' ## Fixed test window
#' forward_kfold(object, cv, buffer, train_window = 12, validation_window = 1)
#'
#' @section Arguments
#' @param object a TSML object
#' @param cv number of cross-validation splits
#' @param buffer number of periods between training and testing set to be omitted to avoid look-ahead bias
#' @param train_window training window size. Default set to NULL for dynamic window using all training data available
#' @param min_train_window minimum training window size. Ignored when train_window is specified. Must be specified if using a dynamic training window approach
#' @param validation_window test window size. Default set to NULL for full testing sample in each cross-validation block.
#'
#' @details
#' The walk-forward kfold train/validation splits is built on the idea that the validation phase should best approximate the actual prediction phase in order to obtain optimal hyper-parameters.
#' The function first break the entire training set into two groups sequentially. The first group is reserved for training only and the kfold splits are performed on the second group. This is done to make sure the first validation bin has enough training data to make prediction.

forward_kfold <- function(object,
                          cv,
                          buffer = 0,
                          train_window = NULL,
                          min_train_window = NULL,
                          validation_window = NULL) {
  if (is.null(train_window) & is.null(min_train_window)) {
    stop("Error: must set a minimum training window when applying a dynamic training window.")
  }

  if (is.null(min_train_window)) {
    min_train_window = train_window
  }

  train_data <- object$training_data

  indices <- seq(train_window + buffer + 1, nrow(train_data))

  if (floor(length(indices) / cv) < validation_window) {
    stop("Error: test window and training dataset mismatch, decrease cross-validation number or shorten test window.")
  }

  test_indices <- lapply(seq_split(indices, cv), function(x) c(start = x[1], end = ifelse(is.null(validation_window), x[length(x)], x[1] + validation_window - 1)))

  results <- list()

  for (test_idx in test_indices) {
    test_start <- test_idx["start"]
    test_end <- test_idx["end"]
    train_start <- ifelse(is.null(train_window), 1, test_start - train_window - buffer)
    train_end <- test_start - buffer - 1

    test_idx_sequence <- test_start:test_end
    train_idx_sequence <- train_start:train_end

    results <- append(results, list(list(test_idx = test_idx_sequence, train_idx = train_idx_sequence)))
  }
}
