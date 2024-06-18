feature_correlation <- function(data,
                             varnames = NULL,
                             threshold = 0.7,
                             remove = FALSE,
                             method = "pearson") {
  # Note to self: Convert data to data.table if not already

  # If varnames is NULL, use all column names
  if (is.null(varnames)) {
    varnames <- colnames(data)
  }

  if (!method %in% c("pearson", "kendall", "spearman")) {
    stop("Error: method must be one of 'spearman', 'pearson', or 'kendall'")
  }

  # Calculate the correlation matrix
  cor_matrix <- cor(data[, ..varnames], use = "pairwise.complete.obs", method = method)

  # Find the pairs of variables with absolute correlation above the threshold
  high_cor_pairs <- which(abs(cor_matrix) > threshold, arr.ind = TRUE)

  # Remove duplicates and self-correlations
  high_cor_pairs <- high_cor_pairs[high_cor_pairs[, 1] != high_cor_pairs[, 2], ]
  high_cor_pairs <- high_cor_pairs[!duplicated(t(apply(high_cor_pairs, 1, sort))), ]

  # Initialize a vector to keep track of variables to be removed
  to_remove <- c()

  # Loop to remove highly correlated variables
  while (nrow(high_cor_pairs) > 0) {
    # Find the most correlated pair
    highest_cor_pair <- high_cor_pairs[1, ]
    var1 <- varnames[highest_cor_pair[1]]
    var2 <- varnames[highest_cor_pair[2]]

    # Choose one variable to remove (e.g., var2) and add to to_remove
    to_remove <- c(to_remove, var2)

    # Update the list of variables and the correlation matrix
    varnames <- setdiff(varnames, var2)
    cor_mat <- cor(data[, ..varnames], use = "pairwise.complete.obs", method = method)
    high_cor_pairs <- which(abs(cor_mat) > threshold, arr.ind = TRUE)
    high_cor_pairs <- high_cor_pairs[high_cor_pairs[, 1] != high_cor_pairs[, 2], ]
    high_cor_pairs <- high_cor_pairs[!duplicated(t(apply(high_cor_pairs, 1, sort))), ]
  }

  # Return the data without the highly correlated variables
  if (remove) {
    data[, (to_remove) := NULL]
  }
  return(list(data = data, remove_var = to_remove, cor_matrix = cor_matrix))
}

# Future work: clustering analysis, tree based selection
