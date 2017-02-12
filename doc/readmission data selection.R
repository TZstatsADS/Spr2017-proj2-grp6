library(dplyr)
library(stringr)
library(tidyr)
library(readr)

#Import the hospital charge data
hospital_charge_data <- read_csv("/Users/xuxuanzi/Desktop/Spr2017-proj2-grp6/data/hospital_charge_data.csv", col_types = cols(`Average Covered Charges` = col_number(),`Average Medicare Payments` = col_number(),`Average Total Payments` = col_number()))

#Fix the column names
cnames <- colnames(hospital_charge_data)
new_cnames <- tolower(gsub("[ ]","_",cnames,perl=FALSE))
new_cnames -> colnames(hospital_charge_data)
drg <- as.numeric(str_extract(hospital_charge_data$drg_definition,"[0-9]+"))
mdf <- hospital_charge_data %>% mutate(drg_code = drg)

#Import the readmission data
readmission<-read.csv("/Users/xuxuanzi/Desktop/Spr2017-proj2-grp6/data/readmission_data.csv")

#Reorder by provider id
charge<-arrange(mdf, provider_id)
readmission<-arrange(readmission, Provider.ID)


# Total Numbers of Hospitals in hospital_charge dataset
length(unique(charge$provider_id))
# Total Numbers of Hospitals in readmission dataset
length(unique(readmission$Provider.ID))

# The number of hospitals that both datasets have
sum(unique(charge$provider_id) %in% unique(readmission$Provider.ID))

# The hospitals (provider ID) that both datasets have
a <- unique(charge$provider_id)[unique(charge$provider_id) %in% unique(readmission$Provider.ID)]

# Filter the readmission data by "a"
readmission<-filter(readmission,Provider.ID  %in% a)

# Match the colnames between two datasets
colnames(readmission)[1:6]<-colnames(charge)[2:7]

