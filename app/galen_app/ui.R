library(shiny)
library(stringr)
library(dplyr)
library(plyr)
library(choroplethr)
library(choroplethrMaps)
library(choroplethrZip)
load("data/hcd.RData", .GlobalEnv)
load("data/natl_regions.RData", .GlobalEnv)

shinyUI(fluidPage(
  titlePanel("Average Billed Cost of Common Medical Procedures By State"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Create map showing average cost of a medical procedure averaged across all hospitals that receive Medicare Inpatient Prospective Payment System (IPPS) payments by State"),
      selectInput("var",
                  label = "Choose a variable to display",
                  choices = unique(hcd$drg_definition)),
    helpText("Choose a region to map over"),
    selectInput("reg",
                label = "Select Region",
                choices = unique(natl_regions$natl_region)
                )
    ),
    mainPanel(
      plotOutput("map")
    )
  )
))