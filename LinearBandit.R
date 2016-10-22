


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
points(6,2,col=2,pch=15, cex = 2)

for(i in 1:(nrow(nodes)-1)){
  segments(nodes[i,1],nodes[i,2], nodes[i,1]+1, 2)
  if(i < 11){
    if(nodes[i,2] != 1){
      segments(nodes[i,1],nodes[i,2], nodes[i,1]+1, 3)
    }
    if(nodes[i,2] != 3){
      segments(nodes[i,1],nodes[i,2], nodes[i,1]+1, 1)
    }
  }
}






# Now set up reward structure for the 36 different paths
# 2 is slow (Red)
# 3 is fast (Green)
# 4 is average (Blue)

pathSpeed <- sample(2:4,27, replace = T)

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

legend(1, 3.5, legend=c("Slow", "Moderate", "Fast"),
       col=c("red", "blue", "Green"),lty = 1, cex=1)




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


# 43 possible routes 
# matrix of possible paths

routes <- matrix(0, nrow = 43, ncol = 27)

2,9,16,23,27
2,9,16,24,26
2,9,17,21,27
2,9,17,20,26
2,9,17,22,25
2,10,14,23,27
2,10,14,24,26
2,10,13,21,27
2,10,13,20,26
2,10,13,22,25
2,10,15,19,26
2,10,15,18,25
1,8,11,18,25
1,8,11,19,26
1,8,12,22,25
1,8,12,20,26
1,8,12,21,27
1,6,15,18,25
1,6,15,19,26
1,6,13,22,25
1,6,13,20,26
1,6,13,21,27
1,6,14,24,26
1,6,14,23,27
1,7,16,23,27
1,7,16,24,26
1,7,17,21,27
1,7,17,20,26
1,7,17,22,25
3,4,11,18,25
3,4,11,19,26
3,4,12,22,25
3,4,12,20,26
3,4,12,21,27
3,5,15,18,25
3,5,15,19,26
3,5,13,22,25
3,5,13,20,26
3,5,13,21,27
3,5,14,24,26
3,5,14,23,27







