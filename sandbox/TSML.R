library(R6)
library(data.table)

TSML <- R6Class("Time Series Machine Learning",
  public = list(
    data = NULL,
    task = NULL,
    ts_var = NULL,
    y = NULL,
    cs_var = NULL,
    train_data = NULL,
    test_data = NULL,
    model = NULL,
    learner = NULL,
    benchmark = list(),
    prediction = NULL,
    evals = NULL,

    initialize = function(data, task, ts_var, y, cs_var = NULL) {
      if (!is.data.table(data)) {
        tryCatch({
          data <- as.data.table(data)
        }, error = function(e) {
          stop(paste("Error: data conversion to data.table failed:", e$message))
        })
      }

      task <- toupper(task)
      if (!task %in% c("REGRESSION", "CLASSIFICATION")) {
        stop(paste("Error: must specify whether it is a regression or a classification task."))
      }

      if (is.null(ts_var)) {
        stop("Error: time series variable cannot be empty")
      }

      if (!inherits(data[[ts_var]], "Date")) {
        tryCatch({
          data[[ts_var]] <- as.Date(data[[ts_var]])
        }, error = function(e) {
          stop(paste("Error: time-series column not properly formatted:", e$message))
        })
      }

      self$data <- data
      self$ts_var <- ts_var
      self$y <- y
      self$cs_var <- cs_var
    }
  )
)
