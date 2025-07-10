# Load qk library
library(qkiosk)

# May need to add qk API key into environment variables for data to be fetched.
# Free keys available online.

# Get qk earnings per share and return file date and earnings per share. Returns data frame.
MSFT_eps <- as.data.frame(qk_fn(qk_ticker("MSFT"), "EPS")[])
MSFT_eps <- na.omit(MSFT_eps[MSFT_eps$fq > 0, c("fq","filed")])
MSFT_eps$filed <- as.Date(as.character(MSFT_eps$filed), "%Y%m%d")

str(MSFT_eps)

save(MSFT_eps, file = "data/MSFT_eps.RData")
