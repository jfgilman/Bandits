
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


drawPaths <- function(pathSpeed = NULL, pathSize = NULL, iter = NULL){
  
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
      mtext(paste("Iteration Number", iter), ,side = 1,line=1)
    }
    
    
    if(is.null(pathSize)){
      pathSize <- rep(1,33)
    }
    
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
    legend(1, 3.5, legend=c("Slow", "Moderate", "Fast"),
           col=c("red", "blue", "Green"),lty = 1, cex=1)
  }
}

pSpeed <- sample(2:4,33, replace = T)
pSize <- rep(.5,33)

pull <- function(route, pSize, iter = NULL){
  
  allObsLoss <- c()
  allELoss <- c()
  
  routeObsLoss <- rep(NA, 33)
  
  pSize <- pSize + route*.2
  
  drawPaths(pSpeed,pSize, iter)
  
  
  for(i in 1:length(pathSpeed)){
    if(pSpeed[i] == 3){
      allObsLoss[i] <- runif(1,.1,.5)
      allELoss[i] <- .3
    } else if(pSpeed[i] == 4){
      allObsLoss[i] <- runif(1,.3,.8)
      allELoss[i] <- .55
    } else {
      allObsLoss[i] <- runif(1,.55,1)
      allELoss[i] <- .775
    }
  }
  
  return(list(loss = allObsLoss, size = pSize))
  
}

for(i in 1:100){
  
  arm <- sample(1:81, 1)
  pSize <- pull(binaryRoutes[arm,], pSize, i)$size
  Sys.sleep(1)
  
}

library(MASS)

P <- matrix(0, nrow = 81, ncol = 100)

P[,1] <- rep(1/81,81)

X <- matrix(0, nrow = 33, ncol = 100)

X[,1] <- binaryRoutes[sample(1:81, 1, prob = P[,1]),]

Pt <- matrix(0, nrow = 33, ncol = 33)
for(i in 1:81){
  Pt <- Pt + P[i,1]*outer(binaryRoutes[i,], binaryRoutes[i,]) 
}

ObsL <- pull(binaryRoutes[1,], pSize)$loss
  
lest <- ginv(Pt) %*% outer(X[,1], X[,1]) %*% ObsL

