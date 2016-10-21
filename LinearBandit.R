

plot(1,2,type="n",axes=FALSE,ann=FALSE,
     xlim=c(1,6),ylim=c(1,3))

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
points(6,2,col=2,pch=15, cex = 2)

# 2 is slow
# 3 is fast
# 4 is average
pathSpeed <- sample(2:4,36, replace = T)

pathNum <- 1

for(i in 1:(nrow(nodes)-1)){
  
  segments(nodes[i,1],nodes[i,2], nodes[i,1]+1, 2, col = pathSpeed[pathNum])
  
  pathNum = pathNum + 1
  
  if(i < 11){
    if(nodes[i,2] != 1){
      segments(nodes[i,1],nodes[i,2], nodes[i,1]+1, 3, col = pathSpeed[pathNum])
      
      pathNum = pathNum + 1
    }
    if(nodes[i,2] != 3){
      segments(nodes[i,1],nodes[i,2], nodes[i,1]+1, 1, col = pathSpeed[pathNum])
      
      pathNum = pathNum + 1
    }
  }
}


# 43 possible routes 
# 17 with one less row

pathloss <- c()

for(i in 1:length(pathSpeed)){
  if(pathSpeed[i] == 3){
    pathloss[i] <- runif(1,.1,.5)
  } else if(pathSpeed[i] == 4){
    pathloss[i] <- runif(1,.3,.8)
  } else {
    pathloss[i] <- runif(1,.55,1)
  }
}

