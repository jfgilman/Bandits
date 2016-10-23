


# Linear Bandits simple example
# Find the fastest path
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

# for(i in 1:(nrow(nodes)-1)){
#   segments(nodes[i,1],nodes[i,2], nodes[i,1]+1, 2)
#   if(i < 11){
#     if(nodes[i,2] != 1){
#       segments(nodes[i,1],nodes[i,2], nodes[i,1]+1, 3)
#     }
#     if(nodes[i,2] != 3){
#       segments(nodes[i,1],nodes[i,2], nodes[i,1]+1, 1)
#     }
#   }
# }

for(i in 1:(nrow(nodes)-1)){
  segments(nodes[i,1],nodes[i,2], nodes[i,1]+1, 2)
  if(i < 11){
    segments(nodes[i,1],nodes[i,2], nodes[i,1]+1, 3)
    segments(nodes[i,1],nodes[i,2], nodes[i,1]+1, 1)
  }
}


# Now set up reward structure for the 36 different paths
# 2 is slow (Red)
# 3 is fast (Green)
# 4 is average (Blue)

# pathSpeed <- sample(2:4,27, replace = T)
# 
# pathNum <- 1
# 
# for(i in 1:(nrow(nodes)-1)){
# 
#   segments(nodes[i,1],nodes[i,2], nodes[i,1]+1, 2, col = pathSpeed[pathNum])
# 
#   pathNum = pathNum + 1
# 
#   if(i < 11){
#     if(nodes[i,2] != 1){
#       segments(nodes[i,1],nodes[i,2], nodes[i,1]+1, 3, col = pathSpeed[pathNum])
# 
#       pathNum = pathNum + 1
#     }
#     if(nodes[i,2] != 3){
#       segments(nodes[i,1],nodes[i,2], nodes[i,1]+1, 1, col = pathSpeed[pathNum])
# 
#       pathNum = pathNum + 1
#     }
#   }
# }

pathSpeed <- sample(2:4,33, replace = T)

pathNum <- 1

for(i in 1:(nrow(nodes)-1)){
  if(i < 11){

    segments(nodes[i,1],nodes[i,2], nodes[i,1]+1, 1, col = pathSpeed[pathNum])
    pathNum = pathNum + 1

    segments(nodes[i,1],nodes[i,2], nodes[i,1]+1, 2, col = pathSpeed[pathNum])
    pathNum = pathNum + 1

    segments(nodes[i,1],nodes[i,2], nodes[i,1]+1, 3, col = pathSpeed[pathNum])
    pathNum = pathNum + 1

  } else{
    segments(nodes[i,1],nodes[i,2], nodes[i,1]+1, 2, col = pathSpeed[pathNum])
    pathNum = pathNum + 1
  }
}

legend(1, 3.5, legend=c("Slow", "Moderate", "Fast"),
       col=c("red", "blue", "Green"),lty = 1, cex=1)

pathObsLoss <- c()
pathELoss <- c()

for(i in 1:length(pathSpeed)){
  if(pathSpeed[i] == 3){
    pathObsLoss[i] <- runif(1,.1,.5)
    pathELoss[i] <- .3
  } else if(pathSpeed[i] == 4){
    pathObsLoss[i] <- runif(1,.3,.8)
    pathELoss[i] <- .55
  } else {
    pathObsLoss[i] <- runif(1,.55,1)
    pathELoss[i] <- .775
  }
}



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

which(binaryRoutes%*%pathObsLoss == min(binaryRoutes%*%pathObsLoss))

