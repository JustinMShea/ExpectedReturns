# Load libraries
library(qkiosk)
library(xts)

# May need to add qk API key into environment variables for data to be fetched.
# Free keys available online.

# Get qk earnings per share and return file date and earnings per share. Returns data frame.
MSFT_epsPIT <- as.data.frame(qk_fn(qk_ticker("MSFT"), "EPS", asfiled = TRUE)[])
# Check if data is in EPS style
# if(MSFT_epsPIT[, "fq"] != ){
#     warning("Unexpected EPS Value")
# }
MSFT_epsPIT <- na.omit(MSFT_epsPIT[, c("fq", "fpe")])
MSFT_epsPIT$fpe <- as.Date(as.character(MSFT_epsPIT$fpe), "%Y%m%d")

# convert to xts object
MSFT_epsPIT <- xts(as.numeric(MSFT_epsPIT$fq), order.by = MSFT_epsPIT$fpe)

str(MSFT_epsPIT)

save(MSFT_epsPIT, file = "data/MSFT_epsPIT.RData")
