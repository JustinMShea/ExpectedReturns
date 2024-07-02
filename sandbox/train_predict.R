#' Perform Model Training and Make Predictions
#'
#' @section Usage
#' ## Conventional pipeline
#' TSML$train_predict(model, method = "default",...)
#' ## Recursive pipeline
#' TSML$train_predict(model, method = "recursive",...)
#' ## Recursive pipeline with fixed buffer window
#' TSML$train_predict(model, method = "recursive", buffer = bufferwindow, ...)
#' ## Either pipeline with specific covariates
#' TSML$train_predict(model, vars = varlist)
#' @section Arguments
#' @param model a character string for the machine learning algorithm to be called.
#' @param method a character string of either "default" or "recursive".
#' @param vars a character vector of covariate names. Default uses all available covariates.
#' @param buffer a number for the fixed buffer period. Default set to no fixed rolling window.

TSML$set("public", "train_predict", function(model,
                                             method = c("default", "recursive"),
                                             vars = NULL,
                                             buffer = NULL,
                                             ...) {
  method <- method[1]
  if (!method %in% c("default", "recursive")) {
    stop("Error: method must be either 'default' or 'recursive'")
  }
  self$model <- model
  self$learner <- lrn(model, ...)
  self$prediction <- NULL
  if (is.null(vars)) {
    vars <- setdiff(colnames(self$data), c(self$ts_var, self$cs_var))
  }
  if (!self$y %in% vars) {
    stop("Error: the target variable must be included in the variable list")
  }
  if (is.null(buffer)) {
    current_train <- self$train_data[, ..vars]
  } else {
    if (!is.numeric(buffer)) {
      stop("Error: buffer must be a number.")
    }
    if (buffer > nrow(self$train_data)) {
      stop("Error: buffer must be smaller than the length of training data.")
    }
    buffer_idx <- -1:-(nrow(current_train) - buffer)
    current_train <- self$train_data[buffer_idx, ..vars]
  }

  current_test <- self$test_data[, ..vars]
  if (method == "default") {
    if ("regr" %in% model) {
      task <- as_task_regr(current_train, target = self$y)
    } else if ("classif" %in% model) {
      task <- as_task_classif(current_train, target = self$y)
    }
    self$learner$train(task)

    self$prediction <- self$learner$predict_newdata(current_test)[["response"]]
  }
  if (method == "recursive") {
    if ("regr" %in% model) {
      task <- as_task_regr(current_train, target = self$y)
    } else if ("classif" %in% model) {
      task <- as_task_classif(current_train, target = self$y)
    }

    # This gets rid of the for loop, will have to test if it works
    #recursive_predict <- function(index) {
    #  new_test <- current_test[index, ]
    #  self$learner$train(task)
    #  prediction <- self$learner$predict_newdata(new_test)[["response"]]
    #  current_train <<- rbind(current_train[-1, ], new_test)
    #  task$backend <- current_train
    #  return(prediction)
    #}

    self$prediction <- sapply(seq_len(nrow(current_test)), recursive_predict)

    for (i in 1:nrow(current_test)) {
      new_test <- current_test[i, ]
      self$learner$train(task)
      self$prediction[i] <- self$learner$predict_newdata(new_test)[["response"]]
      current_train <- rbind(current_train[-1, ], new_test)
      task$backend <- current_train
    }
  }
})
