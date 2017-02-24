library(shiny)
library(plotly)

navbarPage("Hospital",
  
           tabPanel("Statistics",
                    sidebarLayout(      
                      
                      sidebarPanel(
                        selectInput("region", "Region:", 
                                    choices=unique(hospital_info$hospital_region)
                                    )
                        ),
    
                      mainPanel(
                        plotlyOutput("chargePlot")
                        )
                      )
                    ),
           tabPanel("Map",
                    sidebarLayout(      
                      sidebarPanel(
                        selectInput("measure", "Measure Name:", 
                                    choices=unique(select$Measure.Name)
                                    )
                        ),
                      
                      mainPanel(plotlyOutput("mapPlot"))
                      )
                    ),
           
           tabPanel("Data Table",
                    fluidRow(
                      column(4,
                             selectInput("state",
                                         "State:",
                                         c("All",
                                           unique(as.character(readmission$provider_state))))
                      ),
                      column(4,
                             selectInput("county",
                                         "County:",
                                         c("All",
                                           unique(as.character(readmission$County.Name))))
                      ),
                      column(4,
                             selectInput("measure",
                                         "Measure Name",
                                         c("All",
                                           unique(as.character(readmission$Measure.Name))))
                      )
                    ),
                    # Create a new row for the table.
                    fluidRow(
                      DT::dataTableOutput("table")
                    ))
           )


