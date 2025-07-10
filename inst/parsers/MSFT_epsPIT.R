# Load qk library
library(qkiosk)

# May need to add qk API key into environment variables for data to be fetched.
# Free keys available online.

# Get qk earnings per share and return file date and earnings per share. Returns data frame.
MSFT_epsPIT <- as.data.frame(qk_fn(qk_ticker("MSFT"), "EPS")[])
MSFT_epsPIT <- na.omit(MSFT_epsPIT[MSFT_epsPIT$fq > 0, c("fq","fpe")])
MSFT_epsPIT$fpe <- as.Date(as.character(MSFT_epsPIT$fpe), "%Y%m%d")

str(MSFT_epsPIT)

save(MSFT_epsPIT, file = "data/MSFT_epsPIT.RData")
