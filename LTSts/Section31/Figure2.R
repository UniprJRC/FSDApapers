library("seasonal") 
library("forecast")

data <- read.csv("salmon.txt")

y_full <- ts(data=data$yP,start=2010,frequency=12)

n <- length(y_full)-12 # number of data to use as test set

#### Without contamination ####

train <- data$yP[1:n]

x11()
plot(y_full,col='blue',ylim=c(16,32),ylab='',lwd=2)

y_train <- ts(data=train,start=2010,frequency=12)
out <- seas(y_train,forecast.save="forecasts")
fore <- series(out, c("forecast.forecasts", "s12"))

lines(fore[,1],col='black')
lines(fore[,2],col="red")
lines(fore[,3],col="red")
lines(fore[,4],col="red")

#### Without contamination ####

train <- data$yP[1:n]
train[n] <- 23

x11()
plot(y_full,col='blue',ylim=c(16,32),ylab='',lwd=2)

y_train <- ts(data=train,start=2010,frequency=12)
out <- seas(y_train,forecast.save="forecasts")
fore <- series(out, c("forecast.forecasts", "s12"))

lines(fore[,1],col='black')
lines(fore[,2],col="red")
lines(fore[,3],col="red")
lines(fore[,4],col="red")
