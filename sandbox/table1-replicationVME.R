# grep("[1 & 3]", colnames(VME.Portfolios))
# colnames(VME.Portfolios)[grep("[1 & 3]", colnames(VME.Portfolios))]

val3index <- grep("VAL3", colnames(VME.Portfolios))
val1index <- grep("VAL1", colnames(VME.Portfolios))

val3xts <- VME.Portfolios[,val3index]
val1xts <- VME.Portfolios[,val1index]

val3_1 <- val3xts - val1xts
colnames(val3_1) <- paste0(colnames(val3xts), "_",colnames(val1xts))

mom3index <- grep("MOM3", colnames(VME.Portfolios))
mom1index <- grep("MOM1", colnames(VME.Portfolios))

mom3xts <- VME.Portfolios[, mom3index]
mom1xts <- VME.Portfolios[, mom1index]

mom3_1 <- mom3xts - mom1xts
colnames(mom3_1) <- paste0(colnames(mom3xts), "_", colnames(mom1xts))

combined_port <- merge(VME.Portfolios, VME.Factors.orig, val3_1, mom3_1)

US_index <- grep("US", colnames(combined_port))
UK_index <- grep("UK", colnames(combined_port))
EU_index <- grep("EU", colnames(combined_port))
JP_index <- grep("JP", colnames(combined_port))
EQ_index <- grep("EQ", colnames(combined_port))
FX_index <- grep("FX", colnames(combined_port))
FI_index <- grep("FI", colnames(combined_port))
CM_index <- grep("CM", colnames(combined_port))

USfactors <- combined_port[,US_index]
USfactors <- combined_port[,sort(colnames(USfactors))]

UKfactors <- combined_port[,UK_index]
UKfactors <- combined_port[,sort(colnames(UKfactors))]

EUfactors <- combined_port[,EU_index]
EUfactors <- combined_port[,sort(colnames(EUfactors))]

JPfactors <- combined_port[,JP_index]
JPfactors <- combined_port[,sort(colnames(JPfactors))]

EQfactors <- combined_port[,EQ_index]
EQfactors <- combined_port[,sort(colnames(EQfactors))]

FXfactors <- combined_port[,FX_index]
FXfactors <- combined_port[,sort(colnames(FXfactors))]

FIfactors <- combined_port[,FI_index]
FIfactors <- combined_port[,sort(colnames(FIfactors))]

CMfactors <- combined_port[,CM_index]
CMfactors <- combined_port[,sort(colnames(CMfactors))]


USfactors$CombinedP3_P1US <- (0.5 * USfactors$MOM3US_MOM1US) + (0.5 * USfactors$VAL3US_VAL1US)
USfactors$Combined_FactorUS <- (0.5 * USfactors$MOMFactorUS) + (0.5 * USfactors$VALFactorUS)

UKfactors$CombinedP3_P1UK <- (0.5 * UKfactors$MOM3UK_MOM1UK) + (0.5 * UKfactors$VAL3UK_VAL1UK)
UKfactors$Combined_FactorUK <- (0.5 * UKfactors$MOMFactorUK) + (0.5 * UKfactors$VALFactorUK)

EUfactors$CombinedP3_P1EU <- (EUfactors$MOM3EU_MOM1EU) + (0.5 * EUfactors$VAL3EU_VAL1EU)
EUfactors$Combined_FactorEU <- (0.5 * EUfactors$MOMFactorEU) + (0.5 * EUfactors$VALFactorEU)

JPfactors$CombinedP3_P1JP <- (JPfactors$MOM3JP_MOM1JP) + (0.5 * JPfactors$VAL3JP_VAL1JP)
JPfactors$Combined_FactorJP <- (0.5 * JPfactors$MOMFactorJP) + (0.5 * JPfactors$VALFactorJP)

EQfactors$CombinedP3_P1EQ <- (EQfactors$MOM3EQ_MOM1EQ) + (0.5 * EQfactors$VAL3EQ_VAL1EQ)
EQfactors$Combined_FactorEQ <- (0.5 * EQfactors$MOMFactorEQ) + (0.5 * EQfactors$VALFactorEQ)

FXfactors$CombinedP3_P1FX <- (FXfactors$MOM3FX_MOM1FX) + (0.5 * FXfactors$VAL3FX_VAL1FX)
FXfactors$Combined_FactorFX <- (0.5 * FXfactors$MOMFactorFX) + (0.5 * FXfactors$VALFactorFX)

FIfactors$CombinedP3_P1FI <- (FIfactors$MOM3FI_MOM1FI) + (0.5 * FIfactors$VAL3FI_VAL1FI)
FIfactors$Combined_FactorFI <- (0.5 * FIfactors$MOMFactorFI) + (0.5 * FIfactors$VALFactorFI)

CMfactors$CombinedP3_P1CM <- (CMfactors$MOM3CM_MOM1CM) + (0.5 * CMfactors$VAL3CM_VAL1CM)
CMfactors$Combined_FactorCM <- (0.5 * CMfactors$MOMFactorCM) + (0.5 * CMfactors$VALFactorCM)

test_datatable_xts <- merge(USfactors, UKfactors, EUfactors, JPfactors, EQfactors, FXfactors, FIfactors, CMfactors)

test <- merge(USfactors$MOM1US, MSCI.ACWI$COMP.RET[index(USfactors)])

VME_table1(test_datatable_xts)
