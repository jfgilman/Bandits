
################################################################################
# OMD
################################################################################

poss <- seq(from = 50, to = 500, by = 50)
arms <- expand.grid(poss, poss, poss, poss, poss)
arms$sum <- arms[,1] + arms[,2] + arms[,3] + arms[,4] + arms[,5]
arms <- arms[which(arms$sum == 1000), 1:5]
arms <- arms/1000

legendre <- function(x){
  val <- 0
  for(i in 1:length(x)){
    val <- val + x[i]*log(x[i]) - x[i]
  }
  return(val)
}

GL <- function(x) log(x) + 1 - 5

GL.inv <- function(x) exp(x + 5 -1)

breg <- function(y){
  return(legendre(w) - legendre(y) - t(w - y)%*%GL(y))
}

store <- function(m, food, foodPlus, foodMinus){
  dropPoint <- rbinom(1, 1000, m/1000)
  
  if(food < dropPoint){
    sales <- food
  } else {
    sales <- dropPoint + 10 - 10*exp(-.1*(food))
  }
  loss <- (1000 - sales) / 1000
  
  if(foodPlus < dropPoint){
    salesP <- foodPlus
  } else {
    salesP <- dropPoint + 10 - 10*exp(-.1*(foodPlus))
  }
  loss <- (1000 - sales) / 1000
  
  if(foodMinus < dropPoint){
    salesM <- foodMinus
  } else {
    salesM <- dropPoint + 10 - 10*exp(-.1*(foodMinus))
  }
  loss <- (1000 - sales) / 1000
  
  lossP <- (1000 - salesP) / 1000
  lossM <- (1000 - salesM) / 1000
  
  return(list(sales =  sales,
              loss = loss,
              lossP = lossP,
              lossM = lossM))
}

n <- 100

x <- matrix(0, nrow = 5, ncol = n)

x[,1] <- as.numeric(arms[sample(1:3246, 1),])
fd <- x[,1]*1000

ms <- c(500,150,100,200,50)

nu <- sqrt(log(3246)/(3*n*5))
delta <- nu*5


for(j in 2:n){
  
  totalLoss <- 0
  ltP <- 0
  ltM <- 0
  for(i in 1:5){
  
    results <- store(ms[i], fd[i], fd[i] + delta, fd[i] - delta)
  
    totalLoss <- totalLoss + results$loss
  
    ltP <- ltP + results$lossP
    ltM <- ltM + results$lossM
  }

  S <- rexp(5,.1)
  S <- S/sum(S)

  gtil <- (5/(2*delta))*(ltP - ltM)*S

  w <<- GL.inv(GL(x[,j-1]) - nu*gtil)

  val <- c()
  for(i in 1:3246){
    val[i] <- breg(as.numeric(arms[i,]))
  }

  x[,j] <- as.numeric(arms[which(val == min(val)),])
  fd <- x[,j]*1000

}

x[,c(1:5,90:95)]

GL(x[,1])
legendre(GL.inv(GL(x[,1]) - nu*gtil))
legendre(GL.inv(GL(x[,2]) - nu*gtil))
