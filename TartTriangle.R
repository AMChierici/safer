#### Tartaglia Triangle generation ####

TartTriangle <- function(N){
#   N <- 4
  TT <- matrix(rep(c(1, rep(0, N-1)), N), nrow=N, byrow=TRUE)
  diag(TT) <- 1
  for(i in 3:N){
    J <- length(TT[i, TT[i, 1:(N-1)]==0])
    for(j in 2:(J+1)){
      TT[i, j] <- TT[i-1, j-1] + TT[i-1, j]
    }
  }
  TT
}

# TartTriangle(6)


  
# S <- 600
# N=10
# p <- 2
# q <- 1-p
# OccProb <- matrix(0, N, N)
# TT <- TartTriangle(N)
# for(i in 1:N){
#   OccProb[i, TT[i, ]!=0] <- p^(1:i)*q^(seq(i-1, 0, -1)) 
# }
# TT*OccProb
# 
# ExpSev <- data.table(N=1:N, RiskCost=rowSums(OccProb)*S*(1:N))
