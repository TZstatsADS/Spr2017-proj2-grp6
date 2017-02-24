library(shiny)
library(shinythemes)
library(d3heatmap)
library(stringr)
library(dplyr)
library(choroplethr)
library(choroplethrMaps)
library(choroplethrZip)
library(leaflet)
library(ggplot2)
library(plotly)
library(ggmap)
library(googleVis)
library(DT)
load("data/hcd.RData", .GlobalEnv)
load("data/hrd.RData", .GlobalEnv)
load("data/scr.RData", .GlobalEnv)
load("data/zips.RData", .GlobalEnv)
load("data/states.RData", .GlobalEnv)
load("data/hm.RData", .GlobalEnv)

navbarPage("US Healthcare Dashboard", theme = shinytheme("flatly"),
  navbarMenu("Costs",
             tabPanel("Procedure Cost Variation",
                      sidebarLayout(
                        sidebarPanel(
                          helpText("Create map showing average cost of a medical procedure averaged across all hospitals that receive Medicare Inpatient Prospective Payment System (IPPS) payments by State"),
                          selectInput("drgCode",
                                      label = "Choose a the drg definition to map",
                                      choices = unique(hcd$drg_definition))
                        ),
                        mainPanel(
                          tabsetPanel(
                            tabPanel("Absolute Cost",plotOutput("absoluteCost")),
                            tabPanel("Relative Cost",plotOutput("relativeCost")),
                            tabPanel("Cost Distribution",
                                     fluidRow(plotlyOutput("costDistribution"))
                                     #,
                                     #fluidRow(DT::dataTableOutput("costDistributionSummary"))
                                     )
                          )
                        )
                      ),
                      fluidRow(
                        column(1),
                        column(10,includeText("text/charge_data.txt")),
                        column(1)
                      )
                      ),
             tabPanel("Hospital System Revenues",
                      sidebarLayout(      
                        sidebarPanel(
                          helpText("Explore the distribution of hospital charges by visualizing the total IPSS payments charged by all hospitals in a state and the distribution of procedure costs nationally."),
                          selectInput("region",
                                      label = "Region:", 
                                      choices = unique(states$region_str)
                          )
                        ),
                        mainPanel(
                          tabsetPanel(
                            tabPanel("Total Charge Distribution",plotlyOutput("chargePlot")),
                            tabPanel("Largest Hospitals",DT::dataTableOutput("largestHospitals")),
                            tabPanel("Top Earning Hospitals & Procedures",d3heatmapOutput("procedureHeatmap"))
                          )
                        )
                      ),
                      fluidRow(
                        column(1),
                        column(10,includeText("text/hospital_revenues.txt")),
                        column(1)
                      )
             )
  ),
  navbarMenu("Quality",
             # tabPanel("State Health Scorecard",
             #          sidebarLayout(
             #            sidebarPanel(
             #              helpText("Create map showing state scorecard for different disease categories"),
             #              selectInput("scorecardDisease",
             #                          label = "Disease category",
             #                          choices = unique(scr$disease),
             #                          selected = scr$disease[1]
             #                          ),
             #              selectInput("scorecardScore",
             #                          label = "Score type",
             #                          choices = NULL
             #                          )
             #            ),
             #            mainPanel(
             #              plotOutput("scorecardMap")
             #            )
             #          ),
             #          fluidRow(
             #            column(1),
             #            column(10,includeText("text/scorecard.txt")),
             #            column(1)
             #          )
             #  ),
             tabPanel("Hospital Readmissions",
                      sidebarLayout(
                        sidebarPanel(
                          selectInput("readmissionsMeasure",
                                      label = "Measure Name:", 
                                      choices = unique(hrd$measure_name))
                        ),
                        mainPanel(
                          plotlyOutput("readmissionsMap")
                        )),
                        fluidRow(
                          column(1),
                          column(10,includeText("text/readmission.txt")),
                          column(1)
                        )
             ),
             tabPanel("Readmissions Data Tool",
                      fluidRow(
                        column(4,
                               selectInput("stateDT",
                                           label = "State:",
                                           choices = unique(states$state_short))
                        ),
                        column(4,
                               selectInput("measureDT",
                                           label = "Measure Name:",
                                           choices = unique(hrd$measure_name))
                        ),
                        column(4,
                               helpText("The data table can be used to search provider information for each disease.  This search can be filtered by state.")
                        )
                      ),
                      fluidRow(
                        column(width = 9, align = "center",
                               DT::dataTableOutput("dataTable"))
                      )
             )
 ),
  tabPanel("Top Hospital Finder",
           div(class="outer",
               tags$head(
                 includeCSS("www/styles.css"),
                 includeScript("www/gomap.js")
               ),
               leafletOutput("hospitalLocationLeaflet", width = "100%", height = "100%"),
               absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                             draggable = TRUE, top = 60, left = "auto", right = 20,
                             bottom = "auto", width = 330, height = "auto",
                             h2("Hospital Selection"),
                             selectInput("stateChooser", "State:", 
                                         choices=unique(hrd$provider_state),
                                         selected = "NY"
                             ),
                             selectInput("measureChooser", "Measure Name:", 
                                         choices=unique(hrd$measure_name)
                             ),
                             selectInput("topChooser", "Top Ranked Hospitals (#):", 
                                         choices=1:5,
                                         selected = 3
                             )
               )
           ),
           tags$div(id = "cite",
                    'Data Source:', tags$em('https://catalog.data.gov/dataset/readmissions-and-deaths-hospital')
                    )
  )
)
