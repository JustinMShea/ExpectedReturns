walkforward_kfold <- function(object,
                              cv,
                              buffer = 0,
                              train_window = NULL,
                              min_train_window = NULL,
                              test_window = 1) {
  if (is.null(train_window) & is.null(min_train_window)) {
    stop("Error: must set a minimum training window when applying a dynamic training window.")
  }

  if (is.null(min_train_window)) {
    min_train_window = train_window
  }

  train_data <- object$training_data

  indices <- seq(train_window + buffer + 1, nrow(train_data))

  if (floor(length(indices) / cv) < test_window) {
    stop("Error: test window and training dataset mismatch, decrease cross-validation number or shorten test window.")
  }

  test_indices <- lapply(seq_split(indices, cv), function(x) c(start = x[1], end = ifelse(is.null(test_window), x[length(x)], x[1] + test_window - 1)))

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
