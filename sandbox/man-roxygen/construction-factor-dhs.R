#' @section Daniel-Hirshleifer-Sun Three-Factors Construction:
#'
#' Daniel-Hirshleifer-Sun (2020) factors construction is the following procedure:
#'
#' * First, all NYSE, AMEX, and NASDAQ common stocks (CRSP 10 or 11 share codes,
#' excluding financial firms and firms with negative book equity).
#' * Second, at June end firms are assigned to one of two size groups ("small" and "big"),
#' depending on their ME being below or above the NYSE median size breakpoint.
#' * Finally, firms are also independently sorted into one of three financing groups
#' ("low", "middle", "high") based on: either stocks' 1-year NSI and 5-year CSI
#' financing measures rankings for the *FIN* factor, or the 4-day cumulative
#' abnormal return around the most recent quarterly earnings announcement date
#' (*CAR*) for the *PEAD* factor. Both sorts are with respect to NYSE 20th and
#' 80th percentiles breakpoints.
