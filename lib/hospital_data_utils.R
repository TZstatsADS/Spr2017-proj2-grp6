loadHospitalChargeData_CSV <- function(){
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
  readmission_data <- read_csv("../data/readmission_data.csv",
                               col_types = cols(Denominator = col_number(), 
                                                      `Higher Estimate` = col_number(), 
                                                      `Lower Estimate` = col_number(), 
                                                      `Measure End Date` = col_date(format = "%m/%d/%Y"), 
                                                      `Measure Start Date` = col_date(format = "%m/%d/%Y"), 
                                                      `Phone Number` = col_skip(),
                                                      Score = col_number(), 
                                                      `ZIP Code` = col_character()),
                               na = "NA")
  
  # remove useless data
  NULL->readmission_data$Footnote
  NULL->readmission_data$Location
  
  cnames <- colnames(readmission_data)
  new_cnames <- tolower(gsub("[ .]","_",cnames,perl=FALSE))
  new_cnames -> colnames(readmission_data)
  hrd <- readmission_data %>%
    filter(!is.na(denominator)) %>%
    mutate(city_name = tolower(city), provider_state = state, provider_city = tolower(city),
           provider_zip_code = str_pad(zip_code,5,side=c("left"),pad="0")) %>%
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
           provider_zip_code
           )
  return(hrd)
}

loadRegionInfo_CSV <- function(){
  reg <- read_csv("../data/us_regions.csv")
  reg <- mutate(reg,state_name = tolower(state_name))
  return(reg)
}

loadIncomeData_TSV <- function(){
  data <- read_delim("../data/income_data_fred.txt", 
                     "\t", escape_double = FALSE, trim_ws = TRUE)
  colnames(data) -> cnames
  labels<-substring(cnames[-1],9,10)
  median_income <- data[nrow(data),-1] 
  colnames(median_income) <- labels
  df <- tibble(labels, as.vector(t(median_income)))
  colnames(df) <- c("state_name","median_income")
  return(df)
}

loadStateScorecard_XML <- function(){
  data <- xmlParse("../data/state_scorecard.xml")
  df <- xmlToDataFrame(data)
  x <- colnames(df)
  colnames(df)<-tolower(x)
  return(df)
}

getRegionInfoByZip <- function(zip_list){
  data("zip.regions")
  
  out <- zip.regions %>%
    filter(region %in% zip_list) %>%
    select(region, county.name, county.fips.numeric)
  colnames(out) <- c("zip_code","county_name","county_id")
  return(out)
}

getStateInfoByAbbrev <- function(state_abbrev_list){
  data("state.regions")
  
  state_abbrev_list <- toupper(state_abbrev_list)
  out <- state.regions %>%
    filter(abb %in% state_abbrev_list) %>%
    select(region, abb, fips.numeric)
  colnames(out) <- c("state_name","state_short","state_id")
  return(out)
}
