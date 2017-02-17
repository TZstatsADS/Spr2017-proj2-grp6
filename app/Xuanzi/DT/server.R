function(input, output) {
  
  # Filter data based on selections
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