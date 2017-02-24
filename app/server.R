library(shiny)
library(plotly)
source("lib/cost_filtering_utils.R")
source("lib/mapping_region_utils.R")

shinyServer(function(input, output, session) {
  
  output$absoluteCost <- renderPlot({
    drg <- str_extract(input$drgCode, "[0-9]+")
    df <- procedureCost(hcd, drg)
    colnames(df)<-c("region","value")
    state_choropleth(df, legend = "Cost (USD)")
  })
  
  output$relativeCost <- renderPlot({
    drg <- str_extract(input$drgCode, "[0-9]+")
    df <- hcd %>%
      filter(drg_code %in% drg) %>%
      ddply(.(state_name), summarise,
            avg_covered = sum(total_discharges*average_covered_charges)/sum(total_discharges), income = mean(median_income)) %>%
      mutate(rel_cost = avg_covered/income) %>%
      select(state_name, rel_cost)
    colnames(df)<-c("region","value")
    state_choropleth(df, legend = "Pct of Median Income")
  })
  
  output$costDistribution <- renderPlotly({
    drg <- str_extract(input$drgCode, "[0-9]+")
    cost <- hcd %>%
      filter(drg_code %in% drg) %>%
      select(average_covered_charges) %>%
      tbl_df()
    plot_ly(x = ~cost$average_covered_charges, type = "histogram") %>%
      layout(
        yaxis = list(title = "Number of Hospitals"),
        xaxis = list(title = "Average Covered Charges"))
  })
  
  output$costDistributionSummary <- DT::renderDataTable({
    cost <- hcd %>%
      filter(drg_code %in% drg) %>%
      select(average_covered_charges) %>%
      as.data.frame()
    df<-summary(cost$average_covered_charges)
    datatable(df)
  })
  
  # output$scorecardMap <- renderPlot({
  #   plt <- stateScorecard(input$scorecardScore)
  #   ij <- full_join(plt,states, by = c("state" = "state_short"))
  #   browser()
  #   df <- ij %>%
  #     select(state_name,rate) %>%
  #     tbl_df()
  #   colnames(df) <- c("region", "value")
  #   state_choropleth(df, legend = "State Score")
  # })
  # 
  
  # output$scorecardMap <-  renderPlotly({
  #   plt <- stateScorecard(input$scorecardScore)
  #   plot_geo(data = plt, locationmode = 'USA-states') %>%
  #     add_trace(
  #       z = ~rate,
  #       text = ~paste("Regional Rate:", regional_rate, "National Rate:", national_rate),
  #       locations = ~state, 
  #       color = ~rate
  #     ) %>%
  #     layout(title = 'State Scorecard',
  #            geo = list(scope = "usa"))
  # })
  
  observe({
    x <- input$scorecardDisease
    y <- scorecardChoices(x)
    updateSelectInput(session,
                      "scorecardScore",
                      label = "Select disease measure",
                      choices = y,
                      selected = tail(y,1))
  })
  
  output$chargePlot <- renderPlotly({
    state_list <- getStatesFromRegion(input$region)
    plt <- totalHosptialChargeState(hcd, state_list)
    plot_ly(
      x = ~ plt$hospital_charges,
      color = ~ plt$state_name,
      type = "box"
    ) %>%
      layout(
        title = "IPPS Covered Charges of Hospitals by State",
        xaxis = list(title = "Total Charges (USD)")
      )
  })
  
  output$largestHospitals <- DT::renderDataTable({
    state_query<-getStatesFromRegion(input$region)
    df <- hcd %>%
      filter(state_name %in% state_query) %>%
      group_by(provider_id) %>%
      mutate(total_charges = round(average_covered_charges*total_discharges)) %>%
      top_n(50,wt=total_charges) %>%
      tbl_df() %>%
      select(provider_name,total_charges) %>%
      arrange(desc(total_charges))
    datatable(df, rownames = FALSE,
              extensions = 'Buttons',
              options = list(dom = 'Bfrtip', buttons = I('colvis')))
  })
  
  output$procedureHeatmap <- renderD3heatmap({
    d3heatmap(hm, dendrogram = "none", colors = "Blues", width = "75%", height = "75%")
  })
  
 
  output$readmissionsMap <- renderPlotly({
    plt<-measureHospitalScore(input$readmissionsMeasure)
    plot_geo(data = plt, locationmode = 'USA-states') %>%
      add_trace(
        z = ~median_score,
        text = ~paste("Highest Score:", highest_score,"Lowest Score:", lowest_score),
        locations = ~provider_state, 
        color = ~median_score,
        colors = 'Blues'
      ) %>%
      layout(title = 'Hospital Readmissions Scores',
             geo = list(scope = "usa"))
  })
  
  output$dataTable <- DT::renderDataTable({
    df<-measureHospitalDataTable(hrd, input$stateDT, input$measureDT)
    datatable(df, 
              rownames = FALSE,
              extensions = 'Buttons',
              options = list(dom = 'Bfrtip', buttons = I('colvis')))
  })
  
  output$hospitalLocationLeaflet <- renderLeaflet({
    plot<-hospitalLocationLeaflet(input$stateChooser,input$measureChooser,input$topChooser)
    leaflet() %>%
      addTiles() %>%
      addMarkers(lng=plot$lon, lat=plot$lat, popup=plot$hospital_name)
  })
})