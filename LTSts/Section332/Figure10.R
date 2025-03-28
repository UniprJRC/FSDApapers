library("seasonal") 
library("forecast")

# Import data
data <- read.csv("P87_KZ.csv",header=T)
Y <- data$Y
rm(data)

n <- 121 # number of data to use as training set

reps <- 10 # number of repetitions

y_full <- ts(data=Y,start=2010,frequency=12)

#### Without contamination ####

train <- Y[1:n]

x11()
plot(y_full,col='blue',ylim=c(0,500000),ylab='',lwd=2)

y_train <- ts(data=train,start=2010,frequency=12)
out <- seas(y_train,forecast.save="forecasts")
fore <- series(out, c("forecast.forecasts", "s12"))

lines(fore[,1],col='black')
lines(fore[,2],col="red")
lines(fore[,3],col="red")
lines(fore[,4],col="red")


#### With contamination ####

# random locations and signs of the contamination generated in Matlab (see code Figure10.m)
locations_noise <- c(39,108,72,16,18,57,3,89,64,66)
sign_noise <- c(-1,1,-1,-1,-1,-1,-1,-1,-1,-1)

for(i in 1:reps){
  
  train <- Y[1:n]
  train[locations_noise[i]] <- max( 0 , train[locations_noise[i]]+20000*sign_noise[i] )

  yi <- ts(data=train,start=2010,frequency=12)
  out <- seas(yi,forecast.save="forecasts")
  fore <- series(out, c("forecast.forecasts", "s12"))

  x11()
  plot(y_full,col='blue',ylim=c(0,500000),ylab='',lwd=2)
  lines(yi,col="deepskyblue",lwd=2);lines(y_train,col="blue",lwd=2)
  lines(fore[,1],col='black')
  lines(fore[,2],col="red")
  lines(fore[,3],col="red")
  lines(fore[,4],col="red")

}

