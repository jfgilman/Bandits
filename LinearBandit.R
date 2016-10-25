
library(MASS)
setwd("~/GitHub/Bandits")

# Linear Bandits simple example
# Find the fastest path

# 81 possible routes 
# matrix of possible paths
moveCombos <- expand.grid(c(1,2,3),c(4:12), c(13:21), c(22:30), c(31:33))
br <- rep(0,nrow(moveCombos))
badRows <- function(mat){
  for(i in 1:nrow(mat)){
    if(mat[i,1] == 1 && !(mat[i,2] %in% c(4,5,6))){
      br[i] <- 1
    } else if (mat[i,1] == 2 && !(mat[i,2] %in% c(7,8,9))){
      br[i] <- 1
    } else if (mat[i,1] == 3 && !(mat[i,2] %in% c(10,11,12))){
      br[i] <- 1
    }
    
    if(mat[i,2] %in% c(4,7,10) && !(mat[i,3] %in% c(13,14,15))){
      br[i] <- 1
    } else if (mat[i,2] %in% c(5,8,11) && !(mat[i,3] %in% c(16,17,18))){
      br[i] <- 1
    } else if (mat[i,2] %in% c(6,9,12) && !(mat[i,3] %in% c(19,20,21))){
      br[i] <- 1
    }
    
    if(mat[i,3] %in% c(13,16,19) && !(mat[i,4] %in% c(22,23,24))){
      br[i] <- 1
    } else if (mat[i,3] %in% c(14,17,20) && !(mat[i,4] %in% c(25,26,27))){
      br[i] <- 1
    } else if (mat[i,3] %in% c(15,18,21) && !(mat[i,4] %in% c(28,29,30))){
      br[i] <- 1
    }
    
    if(mat[i,4] %in% c(22,25,28) && !(mat[i,5] == 31)){
      br[i] <- 1
    } else if (mat[i,4] %in% c(23,26,29) && !(mat[i,5] == 32)){
      br[i] <- 1
    } else if (mat[i,4] %in% c(24,27,30) && !(mat[i,5] == 33)){
      br[i] <- 1
    }
  }
  return(br)
}
drop <- badRows(moveCombos)
routes <- moveCombos[-which(drop == 1),]
binaryRoutes <- matrix(0, nrow = 81, ncol = 33)
for(i in 1:81){
  for(j in 1:5){
    binaryRoutes[i, routes[i,j]] <- 1
  }
}


drawPaths <- function(pathSpeed = NULL,
                      pathSize = rep(1,33),
                      iter = NULL, dash = NULL){
  
  par(oma=c(0,0,0,0), mar=c(4, 4, 2, 2))
  plot(1,2,type="n",axes=FALSE,ann=FALSE,
       xlim=c(1,6),ylim=c(1,3.5))
  
  nodes <- matrix(c(c(1,2),
                    c(2,1),
                    c(2,2),
                    c(2,3),
                    c(3,1),
                    c(3,2),
                    c(3,3),
                    c(4,1),
                    c(4,2),
                    c(4,3),
                    c(5,1),
                    c(5,2),
                    c(5,3),
                    c(6,2)), ncol = 2, byrow = T)
  
  points(nodes, pch=19)
  points(1,2, pch=15, cex = 2)
  points(6,2,col=5,pch=15, cex = 2)
  
  text(1,2.5,"Start")
  text(6,2.5,"Finish")
  
  if(is.null(pathSpeed)){
    for(i in 1:(nrow(nodes)-1)){
      segments(nodes[i,1],nodes[i,2], nodes[i,1]+1, 2)
      if(i < 11){
        segments(nodes[i,1],nodes[i,2], nodes[i,1]+1, 3)
        segments(nodes[i,1],nodes[i,2], nodes[i,1]+1, 1)
      }
    }
  } else {
    
    if(!is.null(iter)){
      mtext(paste("Iteration Number", iter), side = 1,line=1)
    }
    
    
    if(is.null(pathSize)){
      pathSize <- rep(1,33)
    }
    
    if(is.null(dash)){
      pathNum <- 1
      for(i in 1:(nrow(nodes)-1)){
        if(i < 11){
          segments(nodes[i,1],nodes[i,2], nodes[i,1]+1, 1,
                   col = pathSpeed[pathNum], lwd = pathSize[pathNum])
          pathNum = pathNum + 1
          
          segments(nodes[i,1],nodes[i,2], nodes[i,1]+1, 2,
                   col = pathSpeed[pathNum], lwd = pathSize[pathNum])
          pathNum = pathNum + 1
          
          segments(nodes[i,1],nodes[i,2], nodes[i,1]+1, 3,
                   col = pathSpeed[pathNum], lwd = pathSize[pathNum])
          pathNum = pathNum + 1
          
        } else{
          segments(nodes[i,1],nodes[i,2], nodes[i,1]+1, 2,
                   col = pathSpeed[pathNum], lwd = pathSize[pathNum])
          pathNum = pathNum + 1
        }
      }
    } else {
      pathNum <- 1
      for(i in 1:(nrow(nodes)-1)){
        if(i < 11){
          segments(nodes[i,1],nodes[i,2], nodes[i,1]+1, 1, lty = dash[pathNum]*2 + 1,
                   col = pathSpeed[pathNum], lwd = pathSize[pathNum])
          pathNum = pathNum + 1
          
          segments(nodes[i,1],nodes[i,2], nodes[i,1]+1, 2, lty = dash[pathNum]*2 + 1,
                   col = pathSpeed[pathNum], lwd = pathSize[pathNum])
          pathNum = pathNum + 1
          
          segments(nodes[i,1],nodes[i,2], nodes[i,1]+1, 3, lty = dash[pathNum]*2 + 1,
                   col = pathSpeed[pathNum], lwd = pathSize[pathNum])
          pathNum = pathNum + 1
          
        } else{
          segments(nodes[i,1],nodes[i,2], nodes[i,1]+1, 2, lty = dash[pathNum]*2 + 1,
                   col = pathSpeed[pathNum], lwd = pathSize[pathNum])
          pathNum = pathNum + 1
        }
      }
    }
    

    legend(1, 3.5, legend=c("Slow", "Moderate", "Fast"),
           col=c("red", "blue", "Green"),lty = 1, cex=1)
  }
}

################################################################################
################################################################################
# Draw the course 
drawPaths()

# Randomly draw difficulty levels 
# Fixed adversary
pSpeed <- sample(2:4,33, replace = T)

# See paths with difficulty levels 
# These are unknown to the agent 
drawPaths(pSpeed)

# Pull function takes in a choosen route and returns the observed loss
pull <- function(route, pSize, iter = NULL){
  
  allObsLoss <- c()
  pSize <- pSize + route*.01
  
  if(iter %% 10 == 0){
    drawPaths(pSpeed,pSize, iter)
    Sys.sleep(.1)
  }
  
  for(i in 1:length(pSpeed)){
    if(pSpeed[i] == 3){
      allObsLoss[i] <- runif(1,.1,.5)
    } else if(pSpeed[i] == 4){
      allObsLoss[i] <- runif(1,.3,.8)
    } else {
      allObsLoss[i] <- runif(1,.6,1)
    }
  }
  return(list(loss = allObsLoss, size = pSize))
}

# Expected loss for Pseudo-regret calculations
expectedLoss <- c()
for(i in 1:length(pSpeed)){
  if(pSpeed[i] == 3){
    expectedLoss[i] <- .3
  } else if(pSpeed[i] == 4){
    expectedLoss[i] <- .55
  } else {
    expectedLoss[i] <- .8
  }
}


################################################################################
################################################################################
# Simulations


# Total number of iterations 
n <- 5000
# Matrix of updated probability vectors 
P <- matrix(0, nrow = 81, ncol = n + 1)
# Setting first column to be uniform
P[,1] <- rep(1/81,81)
# Matrix of choosen routes
X <- matrix(0, nrow = 33, ncol = n)
# Matrix of cummulative loss
CL <- matrix(0, nrow = 81, ncol = n)
# exploration param
nu <- sqrt(log(81)/(3*n*33))

# size to be adjusted during iterations
pSize <- rep(.5,33)
expLosses <- c()

for(i in 1:n){ 
  routePicked <- sample(1:81, 1, prob = P[,i])
  X[,i] <- binaryRoutes[routePicked,]
  
  expLosses[i] <- t(t(binaryRoutes)%*%P[,i])%*%expectedLoss

  out <- pull(X[,i], pSize, i)
  ObsL <- out$loss
  pSize <- out$size
  
  Pt <- matrix(0, nrow = 33, ncol = 33)
  for(j in 1:81){
    Pt <- Pt + P[j,i]*outer(binaryRoutes[j,], binaryRoutes[j,]) 
  }
  lest <- ginv(Pt) %*% outer(X[,i], X[,i]) %*% ObsL
  
  if(i > 1){
    for(j in 1:81){
      CL[j,i] <- CL[j,i-1] + binaryRoutes[j,]%*%lest
    }
    for(j in 1:81){
      P[j,i+1] <- exp(-nu*CL[j,i])/(sum(exp(-nu*CL[,i])))
    }
  } else {
    for(j in 1:81){
      CL[j,i] <- binaryRoutes[j,]%*%lest
    }
    for(j in 1:81){
      P[j,i+1] <- exp(-nu*CL[j,i])/(sum(exp(-nu*CL[,i])))
    }
  }
}

which(P[,n+1] == max(P[,n+1]))
which(binaryRoutes%*%expectedLoss == min(binaryRoutes%*%expectedLoss))

P[which(binaryRoutes%*%expectedLoss == min(binaryRoutes%*%expectedLoss)),n+1]

drawPaths(pSpeed,pSize, 5000, binaryRoutes[which(P[,n+1] == max(P[,n+1])),])

Regret <- c()
best <- min(binaryRoutes%*%expectedLoss)
Regret[1] <- expLosses[1] - best
for(i in 2:n){
  Regret[i] <- Regret[i-1] + expLosses[i] - best
}
bound <- function(n, d, N) 2*sqrt(3*n*d*log(N))

plot(bound(1:5000, 33, 81), xlab = "Iteration",
     ylab = "Regret", main = "Cummulative Pseudo-Regret", type = "l")
lines(Regret, col = 2)


################################################################################
################################################################################
# random adversary

P <- matrix(0, nrow = 81, ncol = n + 1)
P[,1] <- rep(1/81,81)
X <- matrix(0, nrow = 33, ncol = n)
CL <- matrix(0, nrow = 81, ncol = n)
nu <- sqrt(log(81)/(3*n*33))
pSize <- rep(.5,33)
expLosses <- c()
expSum <- rep(0,33)
for(i in 1:n){ 
  # Now changing the speeds each time
  pSpeed <- sample(2:4,33, replace = T)
  
  routePicked <- sample(1:81, 1, prob = P[,i])
  X[,i] <- binaryRoutes[routePicked,]
  
  expectedLoss <- c()
  for(j in 1:length(pSpeed)){
    if(pSpeed[j] == 3){
      expectedLoss[j] <- .3
    } else if(pSpeed[j] == 4){
      expectedLoss[j] <- .55
    } else {
      expectedLoss[j] <- .8
    }
  }
  expLosses[i] <- t(t(binaryRoutes)%*%P[,i])%*%expectedLoss
  expSum <- expSum + expectedLoss

  out <- pull(X[,i], pSize, i)
  ObsL <- out$loss
  pSize <- out$size
  
  Pt <- matrix(0, nrow = 33, ncol = 33)
  for(j in 1:81){
    Pt <- Pt + P[j,i]*outer(binaryRoutes[j,], binaryRoutes[j,]) 
  }
  lest <- ginv(Pt) %*% outer(X[,i], X[,i]) %*% ObsL
  
  if(i > 1){
    for(j in 1:81){
      CL[j,i] <- CL[j,i-1] + binaryRoutes[j,]%*%lest
    }
    for(j in 1:81){
      P[j,i+1] <- exp(-nu*CL[j,i])/(sum(exp(-nu*CL[,i])))
    }
  } else {
    for(j in 1:81){
      CL[j,i] <- binaryRoutes[j,]%*%lest
    }
    for(j in 1:81){
      P[j,i+1] <- exp(-nu*CL[j,i])/(sum(exp(-nu*CL[,i])))
    }
  }
}

Regret <- c()
aveExpL <- expSum*(1/n)
best <- min(binaryRoutes%*%aveExpL)
Regret[1] <- expLosses[1] - best
for(i in 2:n){
  Regret[i] <- Regret[i-1] + expLosses[i] - best
}
bound <- function(n, d, N) 2*sqrt(3*n*d*log(N))

plot(bound(1:5000, 33, 81), xlab = "Iteration",
     ylab = "Regret", main = "Cummulative Pseudo-Regret", type = "l")
lines(Regret, col = 2)


################################################################################
################################################################################
# random adversary some fixed paths

P <- matrix(0, nrow = 81, ncol = n + 1)
P[,1] <- rep(1/81,81)
X <- matrix(0, nrow = 33, ncol = n)
CL <- matrix(0, nrow = 81, ncol = n)
nu <- sqrt(log(81)/(3*n*33))
pSize <- rep(.5,33)
expLosses <- c()
expSum <- rep(0,33)
for(i in 1:n){ 
  
  # Now changing the speeds each time
  pSpeed <- c(sample(2:4,10, replace = T), 2, sample(2:4,8, replace = T),
              3,sample(2:4,6, replace = T), 3, sample(2:4,5, replace = T), 4)
  
  routePicked <- sample(1:81, 1, prob = P[,i])
  X[,i] <- binaryRoutes[routePicked,]
  
  expectedLoss <- c()
  for(j in 1:length(pSpeed)){
    if(pSpeed[j] == 3){
      expectedLoss[j] <- .3
    } else if(pSpeed[j] == 4){
      expectedLoss[j] <- .55
    } else {
      expectedLoss[j] <- .8
    }
  }
  expLosses[i] <- t(t(binaryRoutes)%*%P[,i])%*%expectedLoss
  expSum <- expSum + expectedLoss
  
  out <- pull(X[,i], pSize, i)
  ObsL <- out$loss
  pSize <- out$size
  
  Pt <- matrix(0, nrow = 33, ncol = 33)
  for(j in 1:81){
    Pt <- Pt + P[j,i]*outer(binaryRoutes[j,], binaryRoutes[j,]) 
  }
  lest <- ginv(Pt) %*% outer(X[,i], X[,i]) %*% ObsL
  
  if(i > 1){
    for(j in 1:81){
      CL[j,i] <- CL[j,i-1] + binaryRoutes[j,]%*%lest
    }
    for(j in 1:81){
      P[j,i+1] <- exp(-nu*CL[j,i])/(sum(exp(-nu*CL[,i])))
    }
  } else {
    for(j in 1:81){
      CL[j,i] <- binaryRoutes[j,]%*%lest
    }
    for(j in 1:81){
      P[j,i+1] <- exp(-nu*CL[j,i])/(sum(exp(-nu*CL[,i])))
    }
  }
}

Regret <- c()
aveExpL <- expSum*(1/n)
best <- min(binaryRoutes%*%aveExpL)
Regret[1] <- expLosses[1] - best
for(i in 2:n){
  Regret[i] <- Regret[i-1] + expLosses[i] - best
}
bound <- function(n, d, N) 2*sqrt(3*n*d*log(N))

plot(bound(1:5000, 33, 81), xlab = "Iteration",
     ylab = "Regret", main = "Cummulative Pseudo-Regret", type = "l")
lines(Regret, col = 2)


################################################################################
################################################################################
# Lets try and get worst case

pSpeed <- c(3,2,2,3,rep(2,8),3,rep(2,8),3,rep(2,8),3,rep(2,2))

expectedLoss <- c()
for(j in 1:length(pSpeed)){
  if(pSpeed[j] == 3){
    expectedLoss[j] <- .3
  } else if(pSpeed[j] == 4){
    expectedLoss[j] <- .55
  } else {
    expectedLoss[j] <- .8
  }
}

P <- matrix(0, nrow = 81, ncol = n + 1)
P[,1] <- rep(1/81,81)
X <- matrix(0, nrow = 33, ncol = n)
CL <- matrix(0, nrow = 81, ncol = n)
nu <- sqrt(log(81)/(3*n*33))
pSize <- rep(.5,33)
expLosses <- c()
for(i in 1:n){ 
  
  routePicked <- sample(1:81, 1, prob = P[,i])
  X[,i] <- binaryRoutes[routePicked,]
  
  expLosses[i] <- t(t(binaryRoutes)%*%P[,i])%*%expectedLoss
  
  out <- pull(X[,i], pSize, i)
  ObsL <- out$loss
  pSize <- out$size
  
  Pt <- matrix(0, nrow = 33, ncol = 33)
  for(j in 1:81){
    Pt <- Pt + P[j,i]*outer(binaryRoutes[j,], binaryRoutes[j,]) 
  }
  lest <- ginv(Pt) %*% outer(X[,i], X[,i]) %*% ObsL
  
  if(i > 1){
    for(j in 1:81){
      CL[j,i] <- CL[j,i-1] + binaryRoutes[j,]%*%lest
    }
    for(j in 1:81){
      P[j,i+1] <- exp(-nu*CL[j,i])/(sum(exp(-nu*CL[,i])))
    }
  } else {
    for(j in 1:81){
      CL[j,i] <- binaryRoutes[j,]%*%lest
    }
    for(j in 1:81){
      P[j,i+1] <- exp(-nu*CL[j,i])/(sum(exp(-nu*CL[,i])))
    }
  }
}

Regret <- c()
best <- min(binaryRoutes%*%expectedLoss)
Regret[1] <- expLosses[1] - best
for(i in 2:n){
  Regret[i] <- Regret[i-1] + expLosses[i] - best
}
bound <- function(n, d, N) 2*sqrt(3*n*d*log(N))

plot(bound(1:5000, 33, 81), xlab = "Iteration",
     ylab = "Regret", main = "Cummulative Pseudo-Regret", type = "l")
lines(Regret, col = 2)



