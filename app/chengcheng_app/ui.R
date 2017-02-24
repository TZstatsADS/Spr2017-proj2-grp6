library(shiny)
library(leaflet)
library(dplyr)


load("readmission_map.RData")

navbarPage("Hospital",
           
           tabPanel("Choose a hospital",
                    div(class="outer",
                        
                        tags$head(
                          # Include our custom CSS
                          includeCSS("styles.css"),
                          includeScript("gomap.js")
                        ),
                        
                        leafletOutput("mapPlot", width="100%", height="100%"),
                        
                        # Shiny versions prior to 0.11 should use class="modal" instead.
                        absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                                      draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
                                      width = 330, height = "auto",
                                      
                                      h2("Selection"),
                                      
                                      selectInput("State", "State:", 
                                                  choices=unique(readmission$State)
                                      ),
                                      selectInput("Measurename", "Measure Name:", 
                                                  choices=unique(readmission$Measure.Name)
                                      ),
                                      selectInput("threshold", "Number of Hospitals to display", choices=1:5)
                        )
                        
                        ),
                        
                        tags$div(id="cite",
                                 'Data source:', tags$em('https://catalog.data.gov/dataset/readmissions-and-deaths-hospital')
                        )
                    )
           )
          


