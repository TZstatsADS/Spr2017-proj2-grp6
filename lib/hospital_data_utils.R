loadHospitalChargeData_CSV <- function(){
  require(choroplethrZip,dplyr)
  hospital_charge_data <- read_csv("../data/hospital_charge_data.csv",
                                   col_types = cols(`Average Covered Charges` = col_number(),
                                                    `Average Medicare Payments` = col_number(), 
                                                    `Average Total Payments` = col_number(), 
                                                    `Provider Id` = col_character(),
                                                    `Provider Zip Code` = col_character()))
  # remove useless data
  NULL->hospital_charge_data$`Hospital Referral Region Description`
  cnames <- colnames(hospital_charge_data)
  new_cnames <- tolower(gsub("[ .]","_",cnames,perl=FALSE))
  new_cnames -> colnames(hospital_charge_data)
  drg <- str_extract(hospital_charge_data$drg_definition,"[0-9]+")
  mdf <- hospital_charge_data %>% mutate(provider_city = tolower(provider_city),
                                         drg_code = drg)
  hcd <- mdf %>%
    select(drg_code,
           drg_definition,
           provider_id,
           provider_name,
           total_discharges,
           average_covered_charges,
           average_total_payments,
           average_medicare_payments,
           provider_street_address,
           provider_city,
           provider_state,
           provider_zip_code)
  hcd$provider_zip_code = str_pad(hcd$provider_zip_code,5,side=c("left"),pad="0")
  return(hcd)
}

loadHospitalReadmissionData_CSV <- function(){
  require(choroplethrZip)
  readmission_data <- read_csv("../data/readmission_data.csv",
                               col_types = cols(Denominator = col_number(), 
                                                      `Higher Estimate` = col_number(), 
                                                      `Lower Estimate` = col_number(), 
                                                      `Measure End Date` = col_date(format = "%m/%d/%Y"), 
                                                      `Measure Start Date` = col_date(format = "%m/%d/%Y"), 
                                                      `Phone Number` = col_skip(), Score = col_number(), 
                                                      `ZIP Code` = col_character()))
  
  # remove useless data
  NULL->readmission_data$Footnote
  NULL->readmission_data$Location
  
  cnames <- colnames(readmission_data)
  new_cnames <- tolower(gsub("[ .]","_",cnames,perl=FALSE))
  new_cnames -> colnames(readmission_data)
  hrd <- readmission_data %>%
    mutate(city_name = tolower(city), provider_state = state, provider_city = tolower(city),
           zip_code = str_pad(zip_code,5,side=c("left"),pad="0")) %>%
    select(provider_id,
           hospital_name,
           measure_id,
           measure_name,
           compared_to_national,
           denominator,
           score,
           lower_estimate,
           higher_estimate,
           measure_start_date,
           measure_end_date,
           address,
           provider_city,
           provider_state,
           zip_code
           )
  hrd$zip_code <- str_pad(hrd$zip_code,5,side=c("left"),pad = "0")
  return(hrd)
}