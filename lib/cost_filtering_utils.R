?procedureCostState <- function(hcd_df, state_list, drg_code){
  out <- hcd %>%
    filter(state_name %in% state_query & drg_code %in% drg_query) %>%
    ddply(.(state_name), summarise, avg_covered = sum(total_discharges*average_covered_charges)/sum(total_discharges)) %>%
    select(state_name,avg_covered)
  return(out)
}

procedureCost <- function(hcd_df, drg_query){
  out <- hcd_df %>%
    filter(drg_code %in% drg_query) %>%
    ddply(.(state_name), summarise, avg_covered = sum(total_discharges*average_covered_charges)/sum(total_discharges)) %>%
    select(state_name,avg_covered)
  return(out)
}