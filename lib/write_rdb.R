library(dplyr)
source("hospital_data_utils.R")
source("mapping_region_utils.R")
hcd <- loadHospitalChargeData_CSV()
hrd <- loadHospitalReadmissionData_CSV()

states <- getStateInfoByAbbrev(hcd$provider_state)
hcd <- inner_join(hcd,states,by=c("provider_state" = "state_short"))
hrd <- inner_join(hrd,states,by=c("provider_state" = "state_short"))

save(hcd, file="../data/hcd.RData")
save(hrd, file="../data/hrd.RData")
