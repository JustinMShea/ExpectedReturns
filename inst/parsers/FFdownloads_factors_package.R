# devtools::install_github("sstoeckl/ffdownload")
require(FFdownload)

##########################################################
## downloading all necessary factors. for expected returns
#  as well as additonal factors for future work
##########################################################


FFfactors_xts <- function(x) {
  tempf <- tempfile(fileext = ".RData")
  inputlist <- c('F-F_Rsearch_Data_Factors', 'F-F_Momentum_Factor', 'F-F_ST_Reversal_Factor', 'F-F_LT_Reversal_Factor',
                 "F-F_Research_Data_5_Factors_2x3", "Developed_5_Factors", "Developed_ex_US_5_Factors",
                 "Europe_5_Factors", "Japan_5_Factors", "Asia_Pacific_ex_Japan_5_Factors", "North_America_5_Factors",
                 "Emerging_5_Factors", "Developed_3_Factors", "Developed_ex_US_3_Factors", "Europe_3_Factors", "Japan_3_Factors",
                 "Asia_Pacific_ex_Japan_3_Factors", "North_America_3_Factors", "Developed_5_Factors",
                 "Developed_Mom_Factor", "Developed_ex_US_Mom_Factor", "Europe_Mom_Factor", "Japan_Mom_Factor",
                 "Asia_Pacific_ex_Japan_MOM_Factor", "North_America_Mom_Factor", "Emerging_MOM_Factor")
  FFdownload(output_file = tempf, inputlist = inputlist, exclude_daily = TRUE, download = TRUE, download_only = FALSE)
  load(tempf)
  x <- list()
  for (i in 1:length(FFdata)) {
    x[[i]] <- FFdata[[i]][["monthly"]][["Temp2"]]
  }
  name <- names(FFdata)
  names(x) <- name
  x
}

# FFfactors <- FFfactors_xts(x)
#
# FF3 <- FFfactors[["x_F-F_Research_Data_Factors"]]
# FF5 <- FFfactors[["x_F-F_Research_Data_5_Factors_2x3"]]
# MOM <- FFfactors[["x_F-F_Momentum_Factor"]]


