ui <- fluidPage(
  titlePanel("Heart Related Discharges as Pct of Total Discharges (By Zip Code)"),
  
  
  selectInput("state", 
              "Choose a state:",
              choices = sort(unique(zip.regions$state.name)), 	
              selected = "new york"), plotOutput("plot1")
  
)
