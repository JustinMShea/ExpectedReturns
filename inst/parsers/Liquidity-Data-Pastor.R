# From the website:
#
# LIQUIDITY FACTORS OF PASTOR AND STAMBAUGH (JPE 2003) UPDATED THROUGH DEC 2019
# Column 1: Month
# Column 2: Levels of aggregated liquidity (Figure 1 in the paper)
# Column 3: Innovations in aggregated liquidity (non-traded liquidity factor; equation(8); the main series)
# Column 4: Traded liquidity factor (LIQ_V, 10-1 portfolio return)
# Note: The traded factor is the value-weighted return on the 10-1 portfolio from a sort on historical
# liquidity betas. This procedure is simpler than sorting on predicted betas (as in the original study)
# and through 2019 it is similarly successful at creating a spread in post-ranking betas. The traded
# factor has a positive and significant alpha through 2019, consistent with liquidity risk being priced.

## WARNING:
## As of today, 2020-06-16 18:12:15 CEST, it looks like the website certificate
## is expired.
## Direct download is therefore more articulated and potentially unwanted under
## such conditions.
## The parser below relies on a local file being downloaded manually by copy-pasting.
## Name the file "Liquidity-Data-Pastor.txt".

path <- " " # your path here
data <- read.delim(path, skip=11)
# NOTE: I inserted 'Date' instead of the original 'Month'
colnames(data) <- c('Date', 'Agg Liq.', 'Innov Liq (eq8)', 'Traded Liq (LIQ_V)')
data$Date <- as.Date.character(
  paste(substr(data[, 1], 1, 4), substr(data[, 1], 5, 7), '01', sep='-'),
  '%Y-%m-%d'
) # arbitrary B-o-M, double check if E-o-M
