data("zip.regions")
data("state.regions")

getRegionInfoByZip <- function(zip_list){
  out <- zip.regions %>%
    filter(region %in% zip_list) %>%
    select(region, county.name, county.fips.numeric, state.name)
  colnames(out) <- c("zip_code","county_name","county_id","state_name")
  return(out)
}

getStateInfoByAbbrev <- function(state_abbrev_list){
  state_abbrev_list <- toupper(state_abbrev_list)
  out <- state.regions %>%
    filter(abb %in% state_abbrev_list) %>%
    select(region, abb, fips.numeric)
  colnames(out) <- c("state_name","state_short","state_id")
  return(out)
}

prepStatePlotDf <- function(data){
  colnames(data)<-c("region","value")
  return(data)
}

getStatesFromRegion <- function(region_list){
  out <- natl_regions %>%
    filter(natl_region %in% region_list) %>%
    select(state_name)
  return(as.vector(out$state_name))
}

plotDrgCode <- function(data,drg,region){
  df <- prepStatePlotDf(data)
  state_choropleth(df,
                   title = paste("Cost by State for:",drg),
                   legend = "Average Cost (Dollars)",
                   zoom = getStatesFromRegion(region))  
}
