#### Try to fetch data from the Police API #####
# https://data.police.uk/docs/method/crime-street/
# http://postcodes.io/
# https://getaddress.io/

# uncomment and run if you don't have the libraries installed
# install.packages('jsonlite', dependencies = TRUE)
# install.packages('sp', dependencies = TRUE)
# install.packages('reshape2', dependencies = TRUE)
# install.packages('data.table', dependencies = TRUE)
# install.packages('ggplot2', dependencies = TRUE)
# install.packages('tidyr', dependencies = TRUE)
# install.packages('XML', dependencies = TRUE)
library(jsonlite)
# library(sp) #not used for now
library(reshape2)
library(data.table)
library(tidyr)
library(ggplot2)
library(RCurl)
library(XML)
source("functions.R")

#save poscode to search and its long and lat - later autocomplete address to find out how many households are there.
EnterPostcode <- "BT1 2LB"

PostcodeInfo <- fromJSON(paste0("https://api.postcodes.io/postcodes/", EnterPostcode))
Ox <- PostcodeInfo$result$latitude
Oy <- PostcodeInfo$result$longitude

CrimeStats1mileRadius <- fromJSON(paste0(
  "https://data.police.uk/api/crimes-street/all-crime?lat=",
  Ox,
  "&lng=",
  Oy#, #default is 1 mile radius
  # "&date=", #default to latest month, use this to specify date
  # substr(Sys.Date()-61, 1, 7) # 2 months ago is the most recent update?
))
melt(table(CrimeStats1mileRadius$category))

# If I want calculate points of a triangle with centre Ox, Oy check this
# http://stackoverflow.com/questions/11449856/draw-a-equilateral-triangle-given-the-center
# but with my calcLatLong I can use bearing to draw any polygon!! E.g. an hexagon:
d <- 250
p1 <- calcLatLong(Ox, Oy, d, 0)
p2 <- calcLatLong(Ox, Oy, d, 60)
p3 <- calcLatLong(Ox, Oy, d, 120)
p4 <- calcLatLong(Ox, Oy, d, 180)
p5 <- calcLatLong(Ox, Oy, d, 240)
p6 <- calcLatLong(Ox, Oy, d, 300)

# Custom area example: https://data.police.uk/api/crimes-street/all-crime?poly=52.268,0.543:52.794,0.238:52.130,0.478&date=2013-01
CrimeStats250mHex <- fromJSON(paste0(
  "https://data.police.uk/api/crimes-street/all-crime?poly=",
  paste0(p1[1], ",", p1[2], ":", p2[1], ",", p2[2], ":", p3[1], ",", p3[2], ":", p4[1], ",", p4[2], ":", p5[1], ",", p5[2], ":", p6[1], ",", p6[2])#,
#   "&date=", #default to last month, use this to specify date
#   substr(Sys.Date()-61, 1, 7) # 2 months ago is the most recent update?
))

melt(table(CrimeStats250mHex$category))

hexCrimeStats(Ox, Oy, 200)

# loop through date to pick 1 yr of data
res <- NULL
CrimeOneYr <- data.table(Var1=melt(table(CrimeStats250mHex$category))$Var1)
setkey(CrimeOneYr, Var1)
dates <- c("2014-05", "2014-06", "2014-07", "2014-08", "2014-09", "2014-10", "2014-11", "2014-12", "2015-01", "2015-02", "2015-03", "2015-04")

for(i in dates){
  # i <- "2014-07"
  res <- data.table(melt(
    table(fromJSON(paste0(
      "https://data.police.uk/api/crimes-street/all-crime?poly=",
      paste0(p1[1], ",", p1[2], ":", p2[1], ",", p2[2], ":", p3[1], ",", p3[2], ":", p4[1], ",", p4[2], ":", p5[1], ",", p5[2], ":", p6[1], ",", p6[2]),
      "&date=", #default to past month, use this to specify date
      i))$category)
  ))
  setkey(res, Var1)
  CrimeOneYr <- res[CrimeOneYr]
}

setnames(CrimeOneYr, names(CrimeOneYr), c("crime_type", gsub("-", "_", dates)))
CrimeOneYr

PlotCrime <- gather(CrimeOneYr, year_month, count, -crime_type)
qplot(year_month, count, data=PlotCrime, geom = "histogram", stat='identity', fill=crime_type)

EnterPostcode <- "BT1 1GJ"
# count households
PostcodeLookup <- fromJSON(URLencode(paste0("https://api.getAddress.io/uk/", EnterPostcode, "?api-key=rJ_3SHdESkGtyVcY5dl3GQ794")))

head(PostcodeLookup)

No_households_in_postcode <- length(PostcodeLookup$Addresses)
No_households_in_postcode

  ## trials.. ##
# SpecPoint <- fromJSON("https://data.police.uk/api/crimes-street/all-crime?lat=52.629729&lng=-1.131592&date=2013-01")
# SpecPoint$category[1:10]
# SpecPoint$location_type[1:10]
# SpecPoint$context[1:10]
# SpecPoint$outcome_status[1000:1010, ]
# SpecPoint$location[1:10, ]
# table(SpecPoint$category)

