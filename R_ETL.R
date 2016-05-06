#iImporting Data from CSV
bike = read.csv("bikeshare.csv", sep = ",", header = TRUE)
#variable path
file_path <- "E:/PACKT/B04662/Ch1/Data"
file_name <- "bikeshare.csv"
bike <- read.csv(paste(file_path, file_name, sep="/"))

#read.table function 
bike = read.table("bikeshare.csv", sep = ",", header = TRUE)

#Importing Data from Database
install.packages("RODBC")
library(RODBC)
connection <- odbcConnect(dsn="servername",uid="userid",pwd="******")
query <- "SELECT * FROM mydb.bikeshare"
bike <- sqlQuery(connection, query, errors=TRUE)
odbcClose(connection)

#dplyr
install.packages("dplyr")
library(dplyr)

#FILTER TRANSFORMATION
#Filter season as Summer and only one total rental occured during those days
#1 = spring, 2 = summer, 3 = fall, 4 = winter 
filter(bike, season == 2,count == 1)
#Filter season as Spring or Summer and  Zero registration for those days
bike_filter <- filter(bike, season == 1 | season == 2,registered <1)
# same above filter using IN Operator 
filter(bike, season %in% c(1,2),registered <1)
#Randomly like to extract the rows on position based.
#3:5 - From third to fifth rows 
slice(bike, 3:5)

#SELECT COLUMNS
select(bike, datetime,season,humidity)
slice(select(bike, season:holiday),1:10)
slice(select(bike, -(season:registered)),1:10)
select(bike, datetime,season,humidity)

# MUTATE
#Combining the Select columns function with filter option 
filter(select(bike, datetime, registered,season), registered < 1)
arrange(filter(select(bike, datetime, registered,season), registered < 1), season)
arrange(filter(select(bike, datetime, registered,season), registered < 1), desc(season))

bike %>%
  select(datetime, registered,season) %>%
  filter(registered < 1) %>%
  arrange(desc(season))

bike %>%
  select(datetime, registered,season) %>%
  mutate(registerationcost = registered*10) %>%
  arrange(desc(season))

#AGGREGATION TRANSFORMATION
bike %>%
  select(datetime,registered,season) %>%
  group_by(season) %>%
  summarise(totalbyseason = sum(registered))


#Export the Data
write.table(bike, "E:\\PACKT\\B04662\\Ch1\\Data\\bikeshare_exp_tab.txt", sep="\t")
write.csv(bike, file = "bikeshare_csv_exp.csv")

#SQLite

install.packages("RSQLite") 
library("RSQLite")
sqlite    <- dbDriver("SQLite")
mydb <- dbConnect(sqlite, dbname="bikeshare.db")
dbListTables(mydb)
getwd()
dbWriteTable(mydb,"BikeShareTbl",bike)
dbListFields(mydb, "BikeShareTbl")
dbGetQuery(mydb, 
           "select count(*) from BikeShareTbl")
tblresults <- dbSendQuery(mydb, 
                          "select * from BikeShareTbl")
fetch(tblresults,2)
dbClearResult(tblresults)
dbDisconnect(mydb)

