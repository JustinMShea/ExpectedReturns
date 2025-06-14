combinatorial_purged <- function(object,
                                n_splits,
                                test_size,
                                buffer = 0,
                                purge = 0) {
  if (test_size * 2 > n_splits) {
    warning("Warning: test size is generally advised to be less than half of training set length.")
  }

  train_data <- object$training_data

  indices <- seq(1, nrow(train_data))
  splits_index <- lapply(seq_split(indices, n_splits), function(x) c(start = x[1], end = x[length(x)]))

  splits <- combn(n_splits, test_size, simplify = FALSE)

  results <- list()

  for (split in splits) {
    test_index <- unlist(lapply(split, function(i) {
      seq(splits_index[[i]]['start'], splits_index[[i]]['end'])
    }))

    train_index <- setdiff(indices, union(union(test_index, test_index - buffer), test_index + buffer + purge))
    results <- append(results, list(list(test_idx = test_index, train_idx = train_index)))
  }
}
