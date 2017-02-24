
# plotProcedurePct <- function(data) {
#   plot_ly(data, x = ~cost_percentile, y= ~total_discharges, color = ~total_discharges,
#           text = ~paste("Hospital: ", provider_name, "Cost: ", average_covered_charges))
# }

# plotStateScore <- function(data){
#   df<-data.frame(region=data$statecode,value=data$staterate_recent)
#   state_choropleth(df,
#                    title = "Title",
#                    legend = "Score")
# }

# plotPercentiles <- function(data) {
#   plot_ly(data, x = ~cost_percentile, y= ~total_discharges, color = ~total_discharges,
#           text = ~paste("Hospital: ", provider_name, "Cost: ", average_covered_charges))
# }

getStatesFromRegion <- function(query_region){
  out <- states %>%
    filter(region_str %in% query_region) %>%
    select(state_name)
  return(as.vector(out$state_name))
}

