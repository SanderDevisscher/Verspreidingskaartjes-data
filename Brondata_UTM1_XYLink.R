
####Basics#### Workingdirectory instellen, Data inlezen & Libraries laden
setwd(dir = "C://Users/sander_devisscher/Google Drive/EU_IAS/T0/Verspreidingskaartjes data")

library(dplyr)

Brondata <- read.csv("C:/Users/sander_devisscher/Google Drive/EU_IAS/T0/invasive-t0-occurrences/data/processed/invasive_EU_listed_and_considered_with_joins.tsv", header=TRUE)
UTM1 <- read.csv2("C:/Users/sander_devisscher/Google Drive/EU_IAS/T0/Verspreidingskaartjes data/UTM1.csv")

Brondata_Ruw <- Brondata
Brondata_Redux <- Brondata[c("euConcernStatus", "gis_utm1_code", "gbifapi_acceptedScientificName", "year")]

####Opsplitsen#### Volgens eulist status
EuConc <- subset(Brondata_Redux, euConcernStatus == "listed")
EuPrep <- subset(Brondata_Redux, euConcernStatus == "under preparation")
EuCons <- subset(Brondata_Redux, euConcernStatus == "under consideration")

####Vereenvoudiging EUConcern####

temp <- subset(EuConc, !is.na(gis_utm1_code))
temp <- subset(EuConc, !is.na(gbifapi_acceptedScientificName))
temp <- subset(EuConc, !is.na(year))

temp7 <- data.frame()
UTM1_Hokken <- unique(temp$gis_utm1_code) 
for(a in UTM1_Hokken){
  temp2 <- subset(temp, gis_utm1_code == a)
  soorten <- unique(temp2$gbifapi_acceptedScientificName)
  for(b in soorten){
    temp3 <- subset(temp2, gbifapi_acceptedScientificName == b)
    jaren <- unique(temp3$year)
    for(c in jaren){
      temp4 <- subset(temp3, year == c)
      aantalwnm <- nrow(temp4)
      TAG <- a
      soort <- b
      jaar <- c
      temp5 <- data.frame(TAG, soort, jaar, aantalwnm)
      temp6 <- merge(x = temp5, y = UTM1, all.x = TRUE)
      temp7 <- rbind(temp7, temp6)
      
    }
  }
}

write.csv2(temp7, "EuConc_UTM1_xyLink.csv")



