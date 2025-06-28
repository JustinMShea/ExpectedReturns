# Load qk library
library(qkiosk)

# May need to add qk API key into environment variables for data to be fetched. Free keys available online.

# Get qk weighted shares outstanding and return file date and shares outstanding. Returns data frame.
MSFT_wso <- as.data.frame(qk_fn(qk_ticker("MSFT"), "WSO")[])
MSFT_wso <- na.omit(MSFT_wso[ MSFT_wso$fq > 0, c("fq","filed")])
MSFT_wso$filed <- as.Date(as.character(MSFT_wso$filed), "%Y%m%d")

str(MSFT_wso)

save(MSFT_wso, file = "data/MSFT_wso.RData")
