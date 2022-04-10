quickselectFSw <- function(D,W,p,sortout){                                                       
  
  # 0. Input data size, sentinels and position as in quickselectFS              
  n        <- length(D)                                                         
  left     <- 1                                                                 
  right    <- n                                                                 
  position <- -1                                                                
  
  nargin <- length(as.list(match.call())) -1
  
  # 0. Default is to not return the left part of the array sorted                                
  if (nargin<4){
    sortout = FALSE
  }
  
  # 1. Default is to compute the weighted median                                
  if (nargin<3 | p<0 | p>1){                                                  
    p <- 0.5                                                                  
  } 
  
  # 2. Data values and weights collapse in a nx2 column vector and move in pairs
  D <- array(c(D , W), dim = c(n , 2))                                                           
  
  # 3. The pivot k is set to get elements partially ordered in D(1:k,:)         
  k <- ceiling(n*p)                                                                
  
  # 4. The external loop checks the condition on weights (point 6),             
  #    which generalises the ideas in Bleich and Overton (1983)                 
  BleichOverton <- TRUE                                                         
  while (BleichOverton){                                                        
    
    ## The internal loop is like in quickselectFS ##                          
    while ((position != k)){                                                 
      
      pivot     <- D[k,]                                                  
      D[k,]     <- D[right,]                                              
      D[right,] <- pivot                                                   
      
      position   <- left                                                    
      for (i in left:right){                                                
        if (D[i,1]<pivot[1]){                                             
          
          for (s in 1:2){                                               
            buffer <- D[i,s]                                          
            D[i,s] <- D[position,s]                                   
            D[position,s] <- buffer                                   
          }                                                             
          
          position <- position+1                                        
          
        }                                                                 
      }                                                                     
      
      D[right,]    <- D[position,]                                        
      D[position,] <- pivot                                                
      
      if  (position < k){                                                   
        left  <- position + 1                                             
      } else {                                                              
        right <- position - 1                                             
      }                                                                     
      
    }                                                                         
    
    ## Checks on weights extends Bleich-Overton ##                            
    
    # 5. The algebra of Bleich-Overton is re-written to check the             
    #    conditions on wheigts efficiently. When the conditions are           
    #    met, D is partially ordered and the optimal solution is reached.     
    
    Le <- sum(D[1:k-1,2])                                                     
    if (Le-p<=0 & p-Le-D[k,2]<=0){                                           
      # 6. The condition is met: stop computation.                          
      kD <- D[k,1]                                                          
      kW <- D[k,2]                                                          
      kstar <- k                                                            
      BleichOverton <- FALSE                                                
      
    } else {                                                                  
      # 7. The conditions not met: go back to quickselectFS with new        
      #    sentinels - (k,n) or (1,k) - and new order statistics -          
      #    k+1 or k-1 (see point 8 and 9.).                                 
      
      if ( D[k,2]<2*(p-Le)){                                                
        # 8. Need to add weight to reach the condition in point 5.        
        #    Add an element (weight and data) to the left part.           
        k     <- k+1                                                      
        left  <- k                                                        
        right <- n                                                        
      } else {                                                              
        # 9. Here, we have that D(k,2)> 2*(p-Le). Need to remove an       
        # element (weight and data) from the right part                   
        # in point 5.                                                     
        k     <- k-1                                                      
        left  <- 1                                                        
        right <- k                                                        
      }                                                                     
    }                                                                         
    position <- -1                                                            
  }                                                                             
  
  # Build output structure
  if (sortout == FALSE){  
    outw <- list(kD , kW , kstar)
  }
  else
  {
    # D[1:kstar-1,]  <- sortrows(D[1:kstar-1,])  
    D[,order(D[2,], decreasing = F)]
    outw <- list(kD , kW , kstar , D)                                                        
  }    
  
  return(outw)
}


