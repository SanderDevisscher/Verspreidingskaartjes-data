
####Basics#### Workingdirectory instellen, Data inlezen & Libraries laden
setwd(dir = "C://Users/sander_devisscher/Google Drive/EU_IAS/T0/Verspreidingskaartjes data")

library(dplyr)
library(foreign)
library(ggplot2)

Brondata <- read.csv("C:/Users/sander_devisscher/Google Drive/EU_IAS/T0/invasive-t0-occurrences/data/processed/invasive_EU_listed_and_considered_with_joins.tsv", header=TRUE)
UTM1 <- read.csv2("C:/Users/sander_devisscher/Google Drive/EU_IAS/T0/Verspreidingskaartjes data/UTM1.csv")

Brondata_Ruw <- Brondata
Brondata_Redux <- Brondata[c("euConcernStatus", "gis_utm1_code", "gbifapi_acceptedScientificName", "year")]

####Opsplitsen Volgens eulist status####
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
    temp4 <- temp3
    aantalwnm <- nrow(temp4)
    TAG <- a
    soort <- b
    temp5 <- data.frame(TAG, soort, aantalwnm)
    temp6 <- merge(x = temp5, y = UTM1)
    temp7 <- rbind(temp7, temp6)
      
    
  }
}

write.dbf(temp7, "EuConc_UTM1_xyLink.dbf")
write.csv2(temp7, "EuConc_UTM1_xyLink.csv")

#Opkuis
remove(temp)
remove(temp2)
remove(temp3)
remove(temp4)
remove(temp5)
remove(temp6)
remove(a)
remove(b)
remove(c)
remove(d)
remove(jaar)
remove(jaren)
remove(soorten)
remove(TAG)
remove(UTM1_TAG)

####Species checkup####
#Sometimes there are errors in the dataset
#to enable to check the data from a single species 

soorten <- unique(Brondata$gbifapi_acceptedScientificName)
print(soorten)
soort <- "Vespa velutina Lepeletier, 1836" #Choose the species to be examined
soortcode <- substr(soort, 1, 3)
fname <- paste("C://Users/sander_devisscher/Google Drive/EU_IAS/T0/Verspreidingskaartjes data/Speciesdata/", soortcode, ".dbf", sep="")

temp <- subset(Brondata, gbifapi_acceptedScientificName == soort)

write.csv2(temp, fname)
write.dbf(temp, fname)

remove(temp)
remove(soorten)
remove(soort)
remove(fname)
remove(soortcode)

####Gedetaileerd per soort####

soorten <- unique(EuConc$gbifapi_acceptedScientificName)
print(soorten)
soort <- "Hydrocotyle ranunculoides L. fil." #Choose the species to be examined
soortcode <- substr(soort, 1, 3)
fname <- paste("C://Users/sander_devisscher/Google Drive/EU_IAS/T0/Verspreidingskaartjes data/Speciesdata/", soortcode, ".dbf", sep="")

temp <- subset(EuConc, gbifapi_acceptedScientificName == soort)

#Tijdelijke tussenstap
Jaren <- c("2014","2015")
tempexport <- subset(temp, year == Jaren)
write.dbf(tempexport, fname)
#Einde tijdelijke tussenstap

n=0
temp3 <- data.frame(x=soort)
temp4 <- data.frame()
Jaren <- unique(temp$year)
for(j in Jaren){
  temp2 <- subset(temp, year == j)
  Hokken <- unique(temp2$gis_utm1_code)
  for(h in Hokken){
    n <- n + 1
  }
  temp3$hokken <- n
  temp3$year <- j
  temp3$soort <- soort
  n = 0
  temp4 <- rbind(temp4, temp3)
}

Brondata_Soort <- temp4
Brondata_Soort$x <- NULL

remove(temp)
remove(temp2)
remove(temp3)
remove(temp4)

remove(j)
remove(h)
remove(n)

remove(Hokken)
remove(Jaren)

#Relevante data voor grafieken selecteren

Jaren <- c("2014","2015","2016")

GRA_Data <- subset(Brondata_Soort, year == Jaren)
GRA_Data$year <- as.factor(GRA_Data$year)

plot <- ggplot(GRA_Data, aes(x=year, y=hokken))
plot <- plot + geom_bar(stat="identity")
plot <- plot + scale_x_discrete(expand = c(0, 0)) + scale_y_continuous(limits=c(0,NA),expand = c(0, 0))
print(plot)






