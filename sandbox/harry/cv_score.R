cv_score(learner,
         object,
         cv_splits,
         weights = NULL,
         cv_loss = c("mse", "mspe", "mae", "mape",
                     "huber", "pseudo_huber", "logcosh",
                     "tweedie", "log_likelihood", "elastic_net",
                     "smooth_l1")) {

  data <- object$train_data
  ts_var <- object$ts_var
  y <- object$y

  if (is.null(vars)) {
    vars <- setdiff(names(train_data), ts_var)
  }

  test_indices <- Reduce(union, lapply(cv_splits, function(x) x$test_idx))
  if (is.null(weights)) {
    weights <- rep(0, nrow(data))
    weights[seq_len(length(weights)) %in% test_indices] <- 1 / length(weights)
  } else {
    weights <- c(weights, rep(0, nrow(data) - length(weights)))[1:n]
    weights[is.na(weights)] <- 0
    weights[!seq_len(length(weights)) %in% test_indices] <- 0
    weights <- weights / sum(weights, na.rm = TRUE)
  }

  loss <- matrix(NA, nrow = nrow(data), ncol = length(cv_splits))

  for (i in 1:length(cv_splits)) {
    train_idx <- cv_splits[[i]]$train_idx
    test_idx <- cv_splits[[i]]$test_idx

    task <- Task$new(id = "cv", backend = data[train_idx, var], target = y)
    learner$train(task)

    prediction <- learner$predict_newdata(data[test_idx, ..var])$response
    loss[test_idx, i] <- calculate_loss(prediction, data[test_idx, ..y], cv_loss, weights = weights[test_idx])
  }

  loss <- t(apply(loss, 1, function(row) row[!is.na(row)]))
  mean_loss <- colMeans(loss, na.rm = TRUE)

  return(mean_loss)
}

