# Regular Version
train_test_split <- function(data,
                             ts_var = NULL,
                             cs_var = NULL,
                             cutoff = 0.8) {
  # Check if data is data.table, if not convert it, if conversion fails throw exact error back
  if (!is.data.table(data)) {
    tryCatch({
      data <- as.data.table(data)
    }, error = function(e) {
      stop(paste("Error: data conversion to data.table failed:", e$message))
    })
  }

  # Check if time series variable is given
  if (is.null(ts_var)) {
    stop("Error: time series variable cannot be empty")
  }

  # Check if ts_var column is a date object, if not convert it, if conversion fails throw exact error back
  if (!inherits(data[[ts_var]], "Date")) {
    tryCatch({
      data[[ts_var]] <- as.Date(data[[ts_var]])
    }, error = function(e) {
      stop(paste("Error: ts_var column conversion to Date object failed:", e$message))
    })
  }

  if (!(is.numeric(cutoff) && cutoff > 0 && cutoff < 1) && !inherits(cutoff, "Date")) {
    stop("Error: cutoff must either be a number between 0 and 1 or a date object")
  }

  # If cutoff is a date, ensure it is between the first and last date of ts_var
  if (inherits(cutoff, "Date")) {
    min_date <- min(data[[ts_var]], na.rm = TRUE)
    max_date <- max(data[[ts_var]], na.rm = TRUE)
    if (cutoff < min_date || cutoff > max_date) {
      stop("Error: cutoff date must be between the first and last date of the time series")
    }
    date_cutoff <- cutoff
  } else {
    # If cutoff is numeric, calculate the date cutoff
    unique_dates <- unique(data[[ts_var]])
    unique_dates <- unique_dates[order(unique_dates)]
    date_cutoff_index <- ceiling(length(unique_dates) * cutoff)
    date_cutoff <- unique_dates[date_cutoff_index]
  }
  # Split the data
  train_data <- data[data[[ts_var]] <= date_cutoff]
  test_data <- data[data[[ts_var]] > date_cutoff]

  return(list(train = train_data, test = test_data))
}

# Pipeline Version
TSML$set("public", "train_test_split", function(cutoff = 0.8) {
  data <- self$data
  ts_var <- self$ts_var

  if (!(is.numeric(cutoff) && cutoff > 0 && cutoff < 1) && !inherits(cutoff, "Date")) {
    stop("Error: cutoff must either be a number between 0 and 1 or a date object")
  }

  if (inherits(cutoff, "Date")) {
    min_date <- min(data[[ts_var]], na.rm = TRUE)
    max_date <- max(data[[ts_var]], na.rm = TRUE)
    if (cutoff < min_date || cutoff > max_date) {
      stop("Error: cutoff date must be between the first and last date of the time series")
    }
    date_cutoff <- cutoff
  } else {
    unique_dates <- unique(data[[ts_var]])
    unique_dates <- unique_dates[order(unique_dates)]
    date_cutoff_index <- ceiling(length(unique_dates) * cutoff)
    date_cutoff <- unique_dates[date_cutoff_index]
  }

  self$train_data <- data[data[[ts_var]] <= date_cutoff]
  self$test_data <- data[data[[ts_var]] > date_cutoff]
})

TSML$set("public", "train", function(task, ...) {

})

TSML$set("public", "train_predict", function(model, method = c("default", "recursive"), vars = NULL, ...) {
  if (!method %in% c("default", "recursive")) {
    stop("Error: method must be either 'default' or 'recursive'")
  }
  self$model = model
  self$learner = lrn(model, ...)
  if (is.null(vars)) {
    vars <- setdiff(colnames(self$data), c(self$ts_var, self$cs_var))
  }
  if (!self$y %in% vars) {
    stop("Error: the target variable must be included in the variable list")
  }
  current_train <- self$training_data[, ..vars]
  current_test <- self$testing_data[, ..vars]
  if (method == "default") {
    if ("regr" %in% model) {
      task <- TaskRegr$new(id = "newregr", backend = current_train, target = self$y)
    } else if ("classif" %in% model) {
      task <- TaskClassif$new(id = "newclassif", backend = current_train, target = self$y)
    }
    self$learner$train(task)

    self$prediction <- self$learner$predict_newdata(task, current_test)[["response"]]
  }
  if (method == "recursive") {
    if ("regr" %in% model) {
      task <- TaskRegr$new(id = "newregr", backend = current_train, target = self$y)
    } else if ("classif" %in% model) {
      task <- TaskClassif$new(id = "newclassif", backend = current_train, target = self$y)
    }
    old_test <- new_test <- NULL
    for (i in nrow(current_test)) {
      new_test <- current_test[i, ]
      if (!is.null(old_test)) {
        task$rbind(old_test)
      }
      self$learner$train(task)
      self$prediction[i] <- self$learner$predict_newdata(new_test)[["response"]]

      old_test <- new_test
    }
  }
})




