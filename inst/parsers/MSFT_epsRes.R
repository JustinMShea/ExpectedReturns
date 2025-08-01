# Load libraries
library(qkiosk)
library(xts)

# May need to add qk API key into environment variables for data to be fetched.
# Free keys available online.

# Get qk earnings per share and return file date and earnings per share. Returns data frame.
MSFT_epsRes <- as.data.frame(qk_fn(qk_ticker("MSFT"), "EPS")[]) # excludes as filed, includes Restatements
MSFT_epsRes <- na.omit(MSFT_epsRes[, c("fq", "fpe")])
MSFT_epsRes$fpe <- as.Date(as.character(MSFT_epsRes$fpe), "%Y%m%d")

# convert to xts object
MSFT_epsRes <- xts(as.numeric(MSFT_epsRes$fq), order.by = MSFT_epsRes$fpe)

str(MSFT_epsRes)

save(MSFT_epsRes, file = "data/MSFT_epsRes.RData")
