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
