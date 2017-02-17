library(dplyr)
library(stringr)
library(tidyr)
library(readr)
library(ggplot2)
library(devtools)
#install_github('arilamstein/choroplethrZip@v1.4.0')
library(choroplethrZip)

#Import the hospital charge data
hospital_charge_data <- read_csv("../../data/hospital_charge_data.csv", col_types = cols(`Average Covered Charges` = col_number(),`Average Medicare Payments` = col_number(),`Average Total Payments` = col_number()))

#Fix the column names
cnames <- colnames(hospital_charge_data)
new_cnames <- tolower(gsub("[ ]","_",cnames,perl=FALSE))
new_cnames -> colnames(hospital_charge_data)
drg <- as.numeric(str_extract(hospital_charge_data$drg_definition,"[0-9]+"))
mdf <- hospital_charge_data %>% mutate(drg_code = drg)

#Get data for the heatmap
hospital_charges <- mdf %>%
  select(drg_definition,total_discharges,provider_id,average_covered_charges) %>%
  mutate(charge_total = total_discharges*average_covered_charges) %>%
  group_by(provider_id) %>%
  summarise(provider_gross_charges = sum(charge_total))
# can chart a distribution of revenues by hospital?

top_hospitals_billing <- hospital_charges %>%
  top_n(20)

top_billing_procedures <- mdf %>%
  select(drg_definition,drg_code,total_discharges,provider_id,average_covered_charges) %>%
  mutate(charge_total = total_discharges*average_covered_charges) %>%
  group_by(drg_code) %>%
  summarise(drg_gross_charges = sum(charge_total)) %>%
  top_n(20)

hos<-unique(top_hospitals_billing$provider_id)
proc<-unique(top_billing_procedures$drg_code)

hmdata <- mdf %>%
  filter(drg_code %in% proc & provider_id %in% hos) %>%
  select(drg_definition,provider_name,total_discharges,average_covered_charges) %>%
  mutate(charge_total = total_discharges*average_covered_charges)

#Cardiac Related Procedures
heart_related <- mdf %>%
  select(drg_definition, drg_code, total_discharges, provider_zip_code) %>%
  mutate(heart_related = str_detect(drg_definition,"CARDIAC")) %>%
  filter(heart_related %in% TRUE) %>%
  group_by(provider_zip_code) %>%
  summarise(cardiac_discharges = sum(total_discharges))

all_discharges <- mdf %>%
  select(total_discharges,provider_zip_code) %>%
  group_by(provider_zip_code) %>%
  summarise(all_discharges = sum(total_discharges))

ij<-inner_join(all_discharges,heart_related)
ij<-ij %>% mutate(zip = as.character(provider_zip_code),
                  pct_cardiac = cardiac_discharges/all_discharges)

#Clean mapping data so that it works with choropleth package

data("zip.regions")
cz<-zip.regions %>%
  select(region,county.name,state.name)
ij<-ij %>%
  filter(zip %in% cz$region)
cj<-semi_join(ij,cz,by=c("zip" = "region"))


zip_data <- cj %>% select(zip,pct_cardiac)
colnames(zip_data)<-c("region","value")

plotState <- function(stateI){
  zip_choropleth(zip_data, title = "Heart Related Discharges as Pct of Total Discharges (By Zip Code)", state_zoom = stateI)

}

shinyServer <- function(input, output) {

  
  output$plot1 <- renderPlot({
    plotState(input$state)
  })
  
}
