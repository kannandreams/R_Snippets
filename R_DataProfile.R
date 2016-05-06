

bike = read.csv("bikeshare_needcleansing.csv", sep = ",", header = TRUE)
str(bike)



#Data Cleansing process

#Data Type Correction
bike$humidity <- gsub( '*', '', bike$humidity)
str(bike)
bike$humidity <- as.numeric(bike$humidity)
str(bike)

subset(bike, is.na(bike$humidity))
sum(bike$humidity, na.rm=TRUE)
bike$humidity[is.na(bike$humidity)] <- 0
subset(bike, is.na(bike$humidity))
sum(bike$humidity)

#String manipulation 
library(stringr)
unique(bike$Referrer)
bike$Referrer <- str_trim(bike$Referrer)
bike$Referrer <- tolower(bike$Referrer)

#Creating new variable based on pattern matching
#
bike$Referrer[bike$Referrer == ""] <- "Unknown"
class(bike$Referrer)
bike$Referrer <- factor(bike$Referrer)
class(bike$Referrer)


#Deriving new column 
bike$channel_grouping <- bike$Referrer
bike$channel_grouping <- gsub(".*google.*", "SEO", bike$Referrer)
bike$channel_grouping[grep(".*yahoo*", bike$channel_grouping)] <- "SEO"
unique(bike$channel_grouping)

library(DataCombine)
Replaces <- data.frame(from = c("ad campaign","blog","facebook page","Twitter"), to = c("Referrals","social media","social media","social media"))
bike <- FindReplace(data = bike, Var = "Referrer", replaceData = Replaces, from = "from", to = "to", exact = FALSE)

