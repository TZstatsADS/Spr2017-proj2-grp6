procedureCostState <- function(hcd, state_list, drg_code){
  out <- hcd %>%
    filter(state_name %in% state_query & drg_code %in% drg_query) %>%
    ddply(.(state_name), summarise, avg_covered = sum(total_discharges*average_covered_charges)/sum(total_discharges)) %>%
    select(state_name,avg_covered)
  return(out)
}

procedureCost <- function(hcd, drg_query){
  out <- hcd %>%
    filter(drg_code %in% drg_query) %>%
    ddply(.(state_name), summarise, avg_covered = sum(total_discharges*average_covered_charges)/sum(total_discharges)) %>%
    select(state_name,avg_covered)
  return(out)
}

scorecardChoices <- function(disease_category){
  out<-scr %>%
    filter(disease %in% disease_category) %>%
    select(measuretitle_long)
  return(unique(out))
}

stateScorecard <- function(measure_query){
  out <- scr %>%
    select(statecode, measuretitle_long,staterate_recent,regionalrate_recent,nationalrate_recent) %>%
    filter(measuretitle_long %in% measure_query)
  colnames(out)<-c("state","measure","rate","regional_rate","national_rate")
  return(out)
}

totalHosptialChargeState <- function(hcd, state_list){
  out <- hcd %>%
    select(provider_id,provider_name,state_name,total_discharges,average_covered_charges) %>%
    filter(state_name %in% state_list) %>%
    ddply(.(state_name, provider_id), summarise, hospital_charges = sum(total_discharges*average_covered_charges))
  return(out)
}

measureHospitalScore <- function(measure_query){
  out <- hrd %>%
    select(hospital_name,address, provider_city, provider_state, provider_zip_code, measure_name,score) %>%
    filter(measure_name %in% measure_query) %>%
    ddply(.(provider_state), summarise,
          median_score = median(score),
          highest_score = max(score),
          lowest_score = min(score)) %>%
    tbl_df()
  return(out)
}

measureHospitalDataTable <- function(hrd,state_list,measure_query){
  out <- hrd %>%
    select(measure_name, hospital_name,provider_state,provider_city,lower_estimate,higher_estimate,score) %>%
    filter(provider_state %in% state_list & measure_name %in% measure_query) %>%
    top_n(10, wt=score)
}

procedureCostPercentile <- function(procedure_query){
  pct <- hcd %>%
    select(provider_name,drg_definition, total_discharges,average_covered_charges, median_income) %>%
    filter(drg_definition %in% procedure_query) %>%
    mutate(cost_percentile = percent_rank(average_covered_charges), ami_percentile = percent_rank(median_income))
  return(pct)
}

hospitalLocationLeaflet <- function(state_query, measure_query, k){
  k<-as.numeric(k)
  top <- hrd %>%
    filter(provider_state %in% state_query & measure_name %in% measure_query) %>%
    top_n(k,wt=score) %>%
    mutate(address_str = paste(address, provider_city, provider_state, sep=", ")) %>%
    select(address_str,score,hospital_name)
  plot <- as.data.frame(top) %>% mutate_geocode(address_str)
  return(plot)
}