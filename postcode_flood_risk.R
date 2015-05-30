# function to get flood risk for a given postcode

postcode_flood_risk <- function(PC){
  require(httr)
  htmlresp <- GET(paste0('http://maps.environment-agency.gov.uk/wiyby/wiybyController?value=',
                         gsub(' ','+',PC),
                         '&submit.x=-1&submit.y=11&submit=Search%09&lang=_e&ep=summary&topic=floodmap&layerGroups=default&scale=9&textonly=off'))
  
  htmlresp_content <- content(htmlresp)
  
  # extract the 'Yes'
  out <- htmlresp_content["//table[2]//td[2]//text()"]
  flood_risk <- gsub("\\t|\\r|\\n", "", xmlValue(out[[1]]))
  
  if(!is.na(flood_risk) && flood_risk=='Yes'){
    TRUE
  } else {
    FALSE
  }
}



