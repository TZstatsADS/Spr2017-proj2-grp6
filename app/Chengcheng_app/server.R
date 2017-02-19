# Define a server for the Shiny app

library(shiny)

if (!require("dtplyr")) install.packages('dtplyr')
if (!require("leaflet")) install.packages("leaflet")
library(dplyr)
library(leaflet)

load("../output/readmission_map.RData")

shinyServer(function(input, output) {
  
  output$mapPlot <- renderLeaflet({
    subdata <- readmission[readmission$State==input$State & readmission$Measure.Name==input$Measurename,] 
    subdata <- subdata[order(subdata$Score,decreasing=T),]
    n <- min(10,nrow(subdata))
    subdata_plot <- subdata[1:n,]
    subdata_plot$ADDRESS_Ext <- paste(subdata_plot$Address,subdata_plot$City,subdata_plot$State, sep=", ")
    subdata.geo=  
      subdata_plot%>%
      mutate_geocode(ADDRESS_Ext)
    rownames(subdata.geo) <- 1:n
    subdata.geo$label <- paste("No.",rownames(subdata.geo),subdata.geo$Hospital.Name)
    leaflet() %>%
      addTiles() %>%  # Add default OpenStreetMap map tiles
      addMarkers(lng=subdata.geo$lon, lat=subdata.geo$lat, popup=subdata.geo$label)
    })

})
