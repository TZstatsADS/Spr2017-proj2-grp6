
readmission <-read.csv(file="data/readmission_cleaning.csv", as.is=T)
readmission <- readmission[,-1]
unique(readmission$Measure.Name)
select <- readmission[readmission$Measure.Name %in% unique(readmission$Measure.Name)[7:14],]
measure<-unique(select$Measure.Name)
select$Measure.Name[select$Measure.Name==measure[1]]<-"Chronic obstructive pulmonary disease (COPD)"
select$Measure.Name[select$Measure.Name==measure[2]]<-"Stroke"
select$Measure.Name[select$Measure.Name==measure[3]]<-"Heart failure (HF)"
select$Measure.Name[select$Measure.Name==measure[4]]<-"Hip/knee replacement"
select$Measure.Name[select$Measure.Name==measure[5]]<-"Acute Myocardial Infarction (AMI)"
select$Measure.Name[select$Measure.Name==measure[6]]<-"CABG"
select$Measure.Name[select$Measure.Name==measure[7]]<-"Hospital-wide"
select$Measure.Name[select$Measure.Name==measure[8]]<-"Pneumonia (PN)"
readmission <- select
save(readmission, file="output/readmission_map.RData")
