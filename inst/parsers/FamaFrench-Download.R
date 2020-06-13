## Download FamaFrench

FF3.monthly <- ExpectedReturns::GetFactors('FF3', 'FF', freq='monthly') # don't run upon knitting

# Save to sandbox if needed
save(FF3.monthly, file = paste0("data/FF3.monthly.RData"),
     compress = "xz", compression_level = 9)
