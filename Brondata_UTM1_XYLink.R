
setwd(dir = "C://Users/sander_devisscher/Google Drive/EU_IAS/T0")

library(dplyr)

Brondata <- read.csv("C:/Users/sander_devisscher/Google Drive/EU_IAS/T0/invasive-t0-occurrences/data/processed/invasive_EU_listed_and_considered_with_joins.tsv", header=TRUE)
UTM1 <- read.csv2("C:/Users/sander_devisscher/Google Drive/EU_IAS/T0/Verspreidingskaartjes data/UTM1.csv")

UTM1
EuConc <- subset(Brondata, euConcernStatus == "listed")
EuConc$UTM1_TAG <- as.character(EuConc$gis_utm1_code)

EuPrep <- subset(Brondata, euConcernStatus == "under preparation")
EuCons <- subset(Brondata, euConcernStatus == "under consideration")

Data_EuConc <- merge(x=EuConc, y=UTM1, by.x = UTM1_TAG , by.y= TAG)
