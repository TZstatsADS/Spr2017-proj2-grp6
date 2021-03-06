fluidPage(
  titlePanel("Hospital readmission rate and maturity rate"),
  
  # Create a new Row in the UI for selectInputs
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
  )
)