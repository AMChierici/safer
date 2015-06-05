# allianz api

require(httr)

key <- 'test-apiKey-1'
# THIS IS AN EXAMPLE...
possible_categories <- c('HOME','SMART_HOME','ROADSIDE','TRAVEL','HEALTH')

category_name <- possible_categories[2]


base.string <- 'https://aai-api.com/api/products?'

xx <- lapply(possible_categories,function(z){
  x <- GET(paste0(base.string,'apiKey=',key,'&category=',z))
  
  if(x$status_code==200){
    y <- content(x)
    num.prod <- length(y)
    y
  } else {
    cat('URL REQUEST ERROR')
  }
})

names(xx) <- possible_categories

xx

