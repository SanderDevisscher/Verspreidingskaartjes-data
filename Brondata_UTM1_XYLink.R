
####Basics#### Workingdirectory instellen, Data inlezen & Libraries laden
setwd(dir = "C://Users/sander_devisscher/Google Drive/EU_IAS/T0")

library(dplyr)

Brondata <- read.csv("C:/Users/sander_devisscher/Google Drive/EU_IAS/T0/invasive-t0-occurrences/data/processed/invasive_EU_listed_and_considered_with_joins.tsv", header=TRUE)
UTM1 <- read.csv2("C:/Users/sander_devisscher/Google Drive/EU_IAS/T0/Verspreidingskaartjes data/UTM1.csv")

####Opsplitsen#### Volgens eulist status
EuConc <- subset(Brondata, euConcernStatus == "listed")
EuPrep <- subset(Brondata, euConcernStatus == "under preparation")
EuCons <- subset(Brondata, euConcernStatus == "under consideration")

####Vereenvoudiging EUConcern####

UTM1_Hokken <- unique(EuConc$gis_utm1_code) 
temp5 <- data.frame()

for(a in UTM1_Hokken){
  temp <- subset(EuConc, gis_utm1_code == a )
  Soorten <- unique(EuConc$gbifapi_acceptedScientificName)
  for(b in Soorten){
    temp2 <- subset(temp, gbifapi_acceptedScientificName == b)
    jaren <- unique(temp2$year)
    for(c in jaren){
      temp3 <- subset(temp2, year == c)
      AWNM <- as.numeric(nrow(temp3))
      temp4 <- data.frame(a, b, c, AWNM)
      temp6 <- subset(UTM1, TAG == a)
      for (!is.na(temp6$POINT_X)){next}
      temp4$x <- temp6$POINT_X
      temp4$y <- temp6$POINT_Y
      temp5 <- rbind(temp5,temp4)
    }
  }
}
 

write.csv(temp5, "EuConc_UTM1_xyLink.csv", sep = ",")




