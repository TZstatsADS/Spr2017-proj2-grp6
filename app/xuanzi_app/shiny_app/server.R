# Define a server for the Shiny app
library(plotly)
library(shiny)

function(input, output) {
  
  output$chargePlot <- renderPlotly(
    
    plot_ly(hospital_info[hospital_info$hospital_region == input$region,], x = ~Charge, 
            color = ~provider_state, type = "box") %>%
      layout(title="Charges of Hospitals in Each State", yaxis = list(title="States"),xaxis = list(title="Charges"))
    )
  
  
  
  output$mapPlot <- renderPlotly(
    
    
    plot_geo(select[select$Measure.Name==input$measure,], locationmode = 'USA-states') %>%
      add_trace(
        z = ~avg,text = ~info, locations = ~provider_state,
        color = ~avg, colors = 'Oranges'
      ) %>%
      layout(
        title = 'Hospital Selection',
        geo = g
      )

  )
  
  
  
  output$table <- DT::renderDataTable(DT::datatable({
    data <- readmission[,c(1:9,13)]
    data$Score[data$Score=="Not Available"]<-0
    data<-arrange(data, desc(Score))
    if (input$state != "All") {
      data <- data[data$provider_state == input$state,]
    }
    if (input$county != "All") {
      data <- data[data$County.Name == input$county,]
    }
    if (input$measure != "All") {
      data <- data[data$Measure.Name == input$measure,]
    }
    data
  }))
}
