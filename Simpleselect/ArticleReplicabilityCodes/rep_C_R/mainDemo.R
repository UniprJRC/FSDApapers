##################################
#         quickselectFS          #
################################## 

source('quickselectFS.R')

n = 10
k = 5

RNGkind("Mersenne-Twister")
myseed = 896
set.seed(myseed)

A = runif(n) # In MATLAB, use FSDA function A = mtR(n,0,myseed)

# 0.8293406 0.7133021 0.7141369 0.1802098 0.7933905 
# 0.8626241 0.7293147 0.8257157 0.4182991 0.1609702

out1 = quickselectFS(A,k)  
out2 = quickselectFS(A,k,k,TRUE)   

################################## 
#         quickselectFSw         # 
################################## 

source('quickselectFSw.R')

n = 10
p = 0.5

RNGkind("Mersenne-Twister")
set.seed(896)

D = runif(n)

# 0.8293406 0.7133021 0.7141369 0.1802098 0.7933905 
# 0.8626241 0.7293147 0.8257157 0.4182991 0.1609702

W = runif(n)

# 0.45924481 0.55344167 0.57121980 0.06907991 0.30869239 
# 0.67710048 0.20190217 0.77120541 0.57069109 0.50561533

outw1 = quickselectFSw(D,W/sum(W),p) 
outw2 = quickselectFSw(D,W/sum(W),p,TRUE) 
