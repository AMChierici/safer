#  For Andrea

# Get data from police API, census and calculate probability of theft happening.

require(data.table)


#  total theft in SCotland 115628 in 2014-15


# upload census data -------------------------------------------------------------

englandandwales <- fread("/Users/amc/Documents/safer/datasets/England_Wales/Postcode_Estimates_Table_1.csv")
setnames(englandandwales, names(englandandwales), c('postcode', 'population', 'males', 'females', 'households'))
scotland <- fread("/Users/amc/Documents/safer/datasets/Scotland/rel1c2tableA1.csv")
setnames(scotland, names(scotland), c('postcode', 'population', 'households'))
scotland <- scotland[3:(nrow(scotland)-3), ]
nireland <- fread("/Users/amc/Documents/safer/datasets/Ireland/Headcount_and_Household_Estimates_for_Postcodes.csv")
setnames(nireland, names(nireland), c('postcode', 'population', 'males', 'females', 'households', 'v1', 'v2'))

population <- rbind(englandandwales[, match(c('postcode', 'population', 'households'), names(englandandwales)), with=FALSE], scotland[, match(c('postcode', 'population', 'households'), names(scotland)), with=FALSE], nireland[, match(c('postcode', 'population', 'households'), names(nireland)), with=FALSE])


# prob of crime per household ---------------------------------------------

library(jsonlite)
# library(sp) #not used for now
library(reshape2)
library(data.table)
library(tidyr)
library(ggplot2)
library(RCurl)
library(XML)
source("functions.R")

postcodecrime("GU20 6AW")



# Insurance cost ----------------------------------------------------------

source("InsureTheDice.R")

# So, if only 1 person insure one item vith value S, the risk cost per year is the expected cost of losing (or braking or have it stolen it).
# N = no. of insured
# p = probability of losing, braking, being robbed, etc
# S = cost of item(s)

N <- 1
p <- 2/3 #which can be interpreted as twice every three years.
S <- 500 #for example an iphone of £500

N*p*S

# InsureTheDice calculates the probability that N individuals, with the same probability of a bad event happening but independently, all lose/brake/etc. an item of value S:
InsureTheDice(N=10, p=2/3, S=500)

#You can actually use the result in row 1 and in the last row
InsureTheDice(N=20, p=2/3, S=500)[c(1, 20), ]

