minmax_rescale <- function(data,
                           range = c(0,1)) {
  min <- range[1]
  max <- range[2]
  data <- apply(data, 2, function(x) {
    (x - min(x)) / (max(x) - min(x)) * (max - min) + min
  })

  return(data)
}

standard_rescale <- function(data,
                             with_mean = TRUE,
                             with_sd = TRUE) {

  data <- apply(data, 2, function(x) {
    mu = 0
    sd = 1
    if (with_mean) {
      mu = mean(x, na.rm = TRUE)
    }
    if (with_sd) {
      sd = sd(x, na.rm = TRUE)
    }
    (x- mu) / sd
  })

  return(data)
}

uniform_rescale <- function(data,
                            range = c(0, 1)) {
  min <- range[1]
  max <- range[2]
  data <- apply(data, 2, function(x) {
    ranks <- rank(x, na.last = "keep", ties.method = "average")
    ranks / length(ranks) * (max - min) + min
  })

  return(data)
}
