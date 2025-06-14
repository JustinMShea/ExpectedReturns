

RollingWindowCV = R6Class("RollingWindowCV", inherit=Resampling,
  public = list(
    initialize = function() {
      ps = ps(
        folds = p_int(lower = 2L, default = NA_integer_),
        train_window = p_int(lower = 1L, default = NA_integer_),
        test_window = p_int(lower = 1L, default = 1L),
        gap = p_int(lower = 0L, default = 0L),
        min_train_window = p_int(lower = 1L, default = 20L)
      )
      ps$setvalues(folds = 5, train_window = , test_window = , gap = 0)
      
      super$initialize(id = "rolling_window_cv", param_set = ps,
                       label = "Rolling Window Cross Validation", man = "")
    }
  ),
  
  active = list(
    iters = function(rhs) {
      assert_ro_binding(rhs)
      folds_val = self$param_set$values$folds
      
      if (!is.na(folds_val)) {
        return(folds_val)
      } else if (self$is_instantiated) {
        return(length(self$instance))
      } else {
        stop("Resampling not instantiated and `folds` undefined.")
      }
    }
  ),
  
  private = list(
    .sample = function(ids, ...){
      args = self$param_set$values
      
      if (is.na(args$folds) & is.na(args$train_window)) {
        stop("You must provide at least `folds` or `train_window`.")
      }
      
      folds = if (!is.na(args$folds)) args$folds else NULL
      train_window = if (!is.na(args$train_window)) args$train_window else NULL
      test_window = args$test_window
      gap = args$gap
      n = length(ids)
      
      window = rolling_window_splits(index=ids, folds=folds,
                                     train_window=train_window,
                                     test_window=test_window,
                                     gap=gap,
                                     output="list")
      
      if (is.na(args$folds)) {
        self$param_set$values$folds = length(window)
      }
      
      return(window)
    },
    
    .get_train = function(i) self$instance[[i]]$train
    .get_test = function(i) self$instance[[i]]$test
    
    deep_clone = function(name, value) {
      switch(name,
             "instance" = base::copy(value),
             "param_set" = value$clone(deep = TRUE),
             value
      )
    }
  )
)

mlr3::mlr_resampling$add("rollingwindowcv", function() RollingWindowCV$new())