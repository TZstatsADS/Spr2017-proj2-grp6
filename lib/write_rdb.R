library(dplyr)
library(tibble)
library(readr)
library(stringr)
library(XML)
library(choroplethr)
library(choroplethrMaps)
library(choroplethrZip)

# load required data parsing functions from local R source files
source("hospital_data_utils.R")

# following functions load data from csv files in "data" folder" and format column names
hcd <- loadHospitalChargeData_CSV()
hrd <- loadHospitalReadmissionData_CSV()
scr <- loadStateScorecard_XML()
reg <- loadRegionInfo_CSV()
inc <- loadIncomeData_TSV()

states <- getStateInfoByAbbrev(hcd$provider_state)
states <- inner_join(states,reg,by= c("state_name" = "state_name"))
states <- inner_join(states,inc,by= c("state_short" = "state_name"))
zips <- getRegionInfoByZip(unique(hcd$provider_zip_code))

hcd <- inner_join(hcd,states,by=c("provider_state" = "state_short"))
hrd <- inner_join(hrd,states,by=c("provider_state" = "state_short"))

# save copies of RData in data folder and the app data folder (for deployment to shinyapps)
save(hcd, file="../data/hcd.RData")
save(hrd, file="../data/hrd.RData")
save(scr, file="../data/scr.RData")
save(states, file="../data/states.RData")
save(zips, file="../data/zips.RData")

save(hcd, file="../app/data/hcd.RData")
save(hrd, file="../app/data/hrd.RData")
save(scr, file="../app/data/scr.RData")
save(states, file ="../app/data/states.RData")
save(zips, file="../app/data/zips.RData")