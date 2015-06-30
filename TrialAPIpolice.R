#### Try to fetch data from the Police API #####
# https://data.police.uk/docs/method/crime-street/
# http://postcodes.io/

# install.packages('jsonlite')
# install.packages('curl', dependencies = TRUE)
# install.packages('sp', dependencies = TRUE)
# install.packages('reshape2', dependencies = TRUE)
library(jsonlite)
# library(sp) #not used for now
library(reshape2)
source("functions.R")

#save poscode to search and its long and lat - later autocomplete address to find out how many households are there.
EnterPostcode <- "E1 3FE"

PostcodeInfo <- fromJSON(paste0("https://api.postcodes.io/postcodes/", EnterPostcode))
Ox <- PostcodeInfo$result$latitude
Oy <- PostcodeInfo$result$longitude

CrimeStats1mileRadius <- fromJSON(paste0(
  "https://data.police.uk/api/crimes-street/all-crime?lat=",
  Ox,
  "&lng=",
  Oy, #default is 1 mile radius
  "&date=", #default to past month, use this to specify date
  "2015-04"
))
table(CrimeStats1mileRadius$category)

# If I want calculate points of a triangle with centre Ox, Oy check this
# http://stackoverflow.com/questions/11449856/draw-a-equilateral-triangle-given-the-center
# but with my calcLatLong I can use bearing to draw any polygon!! E.g. an hexagon:
p1 <- calcLatLong(Ox, Oy, 250, 0)
p2 <- calcLatLong(Ox, Oy, 250, 60)
p3 <- calcLatLong(Ox, Oy, 250, 120)
p4 <- calcLatLong(Ox, Oy, 250, 180)
p5 <- calcLatLong(Ox, Oy, 250, 240)
p6 <- calcLatLong(Ox, Oy, 250, 300)

# Custom area example: https://data.police.uk/api/crimes-street/all-crime?poly=52.268,0.543:52.794,0.238:52.130,0.478&date=2013-01
CrimeStats250mHex <- fromJSON(paste0(
  "https://data.police.uk/api/crimes-street/all-crime?poly=",
  paste0(p1[1], ",", p1[2], ":", p2[1], ",", p2[2], ":", p3[1], ",", p3[2], ":", p4[1], ",", p4[2], ":", p5[1], ",", p5[2], ":", p6[1], ",", p6[2]),
  "&date=", #default to past month, use this to specify date
  "2015-04"
))

table(CrimeStats250mHex$category)

# loop through date to pick 1 yr of data
tmp <- NULL
for(i in c("2014-05", "2014-06", "2014-07", "2014-08", "2014-09", "2014-10", "2014-11", "2014-12", "2015-01", "2015-02", "2015-03", "2015-04")){
  
  i <- "2014-05"
  tmp <- table(fromJSON(paste0(
    "https://data.police.uk/api/crimes-street/all-crime?poly=",
    paste0(p1[1], ",", p1[2], ":", p2[1], ",", p2[2], ":", p3[1], ",", p3[2], ":", p4[1], ",", p4[2], ":", p5[1], ",", p5[2], ":", p6[1], ",", p6[2]),
    "&date=", #default to past month, use this to specify date
    i
  ))$category)
  melt(tmp)
  ### think about it...
}


## trials.. ##
# SpecPoint <- fromJSON("https://data.police.uk/api/crimes-street/all-crime?lat=52.629729&lng=-1.131592&date=2013-01")
# SpecPoint$category[1:10]
# SpecPoint$location_type[1:10]
# SpecPoint$context[1:10]
# SpecPoint$outcome_status[1000:1010, ]
# SpecPoint$location[1:10, ]
# table(SpecPoint$category)

