##### InsureTheDice #####

InsureTheDice <- function(N, p=1/6, S){
  require(data.table)
  source('TartTriangle.R')
  TT <- TartTriangle(N)
  q <- 1-p
  OccProb <- matrix(0, N, N)
  for(i in 1:N){
    OccProb[i, TT[i, ]!=0] <- p^(1:i)*q^(seq(i-1, 0, -1)) 
  }
  data.table(N=1:N, RiskCost=rowSums(OccProb)*S*(1:N))
}

# InsureTheDice(6, S=600)
