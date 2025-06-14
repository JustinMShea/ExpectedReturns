seq_split <- function(sequence, n_splits) {
  groups <- cut(seq_along(sequence), breaks = n_splits, labels = FALSE)
  split_sequence <- split(sequence, groups)
  return(split_sequence)
}
