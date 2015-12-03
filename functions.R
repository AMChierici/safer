### functions ###

# calculate the location an arbitrary distance and bearing from a known location
# http://stackoverflow.com/questions/2151645/draw-polygon-x-meters-around-a-point

calcLatLong <- function(lat, longitude, distance, bearing=0){
  EARTH_RADIUS_EQUATOR <- 6378140.0
  RADIAN <- 180/pi
  b <- bearing/RADIAN
  lon <- longitude/RADIAN
  lat <- lat/RADIAN
  f <- 1/298.257
  e <- 0.08181922
  
  R <- EARTH_RADIUS_EQUATOR*(1 - e*e) / ((1 - e*e*(sin(lat))^2))^1.5    
  psi <- distance/R
  phi <- pi/2-lat
  arccos <- cos(psi)*cos(phi) + sin(psi)*sin(phi)*cos(b)
  latP <- (pi/2 - acos(arccos))*RADIAN
  
  arcsin <- sin(b)*sin(psi)/sin(phi)
  longP <- (lon - asin(arcsin))*RADIAN
  
  return(c(lat=latP, long=longP))
}
#test
# calcLatLong(-0.0430042, 51.5195786, 250) #check on gmap



# Calc crime stats for hexagon --------------------------------------------

hexCrimeStats <- function(Ox, Oy, d, categories=c("anti-social-behaviour", "bicycle-theft", "burglary", "criminal-damage-arson", "drugs", "other-theft", "possession-of-weapons", "public-order", "robbery", "shoplifting", "theft-from-the-person", "vehicle-crime", "violent-crime", "other-crime")){
  library(jsonlite)
  # library(sp) #not used for now
  library(reshape2)
  library(data.table)
  library(tidyr)
  library(ggplot2)
  library(RCurl)
  library(XML)
  # d <- 250 #in metres
  p1 <- calcLatLong(Ox, Oy, d, 0)
  p2 <- calcLatLong(Ox, Oy, d, 60)
  p3 <- calcLatLong(Ox, Oy, d, 120)
  p4 <- calcLatLong(Ox, Oy, d, 180)
  p5 <- calcLatLong(Ox, Oy, d, 240)
  p6 <- calcLatLong(Ox, Oy, d, 300)
  
  # Custom area example: https://data.police.uk/api/crimes-street/all-crime?poly=52.268,0.543:52.794,0.238:52.130,0.478&date=2013-01
  CrimeStats <- fromJSON(paste0(
    "https://data.police.uk/api/crimes-street/all-crime?poly=",
    paste0(p1[1], ",", p1[2], ":", p2[1], ",", p2[2], ":", p3[1], ",", p3[2], ":", p4[1], ",", p4[2], ":", p5[1], ",", p5[2], ":", p6[1], ",", p6[2])#,
    #   "&date=", #default to last month, use this to specify date
    #   substr(Sys.Date()-61, 1, 7) # 2 months ago is the most recent update?
  ))
  
  melt(table(CrimeStats$category))
}


postcodecrime <- function(postcode){
  library(jsonlite)
  library(reshape2)
  library(data.table)
  library(tidyr)
  library(ggplot2)
  library(RCurl)
  library(XML)
  # EnterPostcode <- "E1 3FE"
  d <- 200
  # count households
  PostcodeLookup <- fromJSON(URLencode(paste0("https://api.getAddress.io/uk/", EnterPostcode, "?api-key=rJ_3SHdESkGtyVcY5dl3GQ794")))
  No_households_in_postcode <- length(PostcodeLookup$Addresses)
  PostcodeInfo <- fromJSON(paste0("https://api.postcodes.io/postcodes/", EnterPostcode))
  Ox <- PostcodeInfo$result$latitude
  Oy <- PostcodeInfo$result$longitude
  res <- hexCrimeStats(Ox, Oy, d)
  res$prob <- res$value/No_households_in_postcode 
  res$event_per_household_per_year <- paste0(ceiling(12*res$value/No_households_in_postcode), " times per year")
  names(res)[1:2] <- c("crime_type", "count_last_month")
  
  # population[postcode==EnterPostcode]
  # as.numeric(population[postcode==EnterPostcode, population]) #for estimated population (in 2011?)
  
  
  return(res)
  
}

