
setwd("YOUR_PATH")

# install.packages("fda.usc")
require("fda.usc")
data(aemet)

# original analysis
nb=20 # Time consuming
out.trim<-outliers.depth.trim(aemet$temp,dfunc=depth.FM,nb=nb)
plot(aemet$temp,col=1,lty=1)
lines(aemet$temp[out.trim[[1]]],col=2)

# save data
dat = aemet$temp$data
write.csv(dat, "FDAtemp_raw.csv", row.names = F)
dat2 = matrix(t(dat), nrow = 73*365, ncol=1, byrow = F)
dat3 = cbind(rep(1:365, 73), dat2)
plot(dat3)
dim(dat3)
write.csv(dat3, "FDAtemp.csv", row.names = F)

###################
#  load result from MATLAB script
###################

sol = read.csv("FDAtempTKM.csv", header=F)
head(sol)

k = 365
out = rep(NA, 73)
for (i in 1:73) {
  out[i] = sum(sol[(k*i - k+1):(k*i), 3] == 0) > 365/3
}
out

plot(aemet$temp,col=1,lty=1)
lines(aemet$temp[out],col=2)
