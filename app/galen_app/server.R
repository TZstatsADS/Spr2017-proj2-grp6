library(shiny)
source("lib/cost_filtering_utils.R")
source("lib/mapping_region_utils.R")

shinyServer(function(input,output){
  output$map <- renderPlot({
    drg_code <- str_extract(input$var,"[0-9]+")
    data <- procedureCost(hcd,drg_code)
    plotDrgCode(data,input$var,input$reg)
  })
}
)