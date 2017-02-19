library(shiny)
library(leaflet)

navbarPage("Hospital",
  
           tabPanel("Choose a hospital",
                    sidebarLayout(
                    
                      sidebarPanel(
                        selectInput("State", "State:", 
                                    choices=unique(readmission$State)
                                    ),
                       
                     
                        selectInput("Measurename", "Measure Name:", 
                                   choices=unique(readmission$Measure.Name)
                                  )
                      ),
                     
                  
                      mainPanel(
                        leafletOutput("mapPlot")
                        )
                      )
                    )
)
          


