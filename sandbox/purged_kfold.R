purged_kfold <- function(object,
                         cv,
                         buffer = 0,
                         purge = 0) {
  train_data <- object$training_data

  indices <- seq(1, nrow(train_data))
  test_indices <- lapply(seq_split(indices, cv), function(x) c(start = x[1], end = x[length(x)]))

  results <- list()

  for (test_idx in test_indices) {
    test_start <- test_idx["start"]
    test_end <- test_idx["end"]

    test_idx_sequence <- test_start:test_end
    train_idx_sequence <- setdiff(indices, seq(test_start - buffer, test_end + buffer + purge))

    results <- append(results, list(list(test_idx = test_idx_sequence, train_idx = train_idx_sequence)))
  }
}
