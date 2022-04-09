quickselectFS <- function(A,k,kiniindex,sortout){                                                 
  
  # Initialise the two sentinels                                                 
  left    <- 1                                                                   
  right   <- length(A)                                                            
  
  # if we know that element in position kiniindex is "close" to the desired order
  # statistic k, than swap A(k) and A(kiniindex).                                
  nargin <- length(as.list(match.call())) -1
  if (nargin<4){
    sortout = FALSE
  }
  if (nargin>2){                                                                 
    Ak    <- A[k]                                                              
    A[k]  <- A[kiniindex]                                                      
    A[kiniindex] <- Ak                                                         
  }                                                                              
  
  # pivot is chosen at fixed position k.                                         
  pivotIndex <- k                                                                
  
  # The original loop was:                                                       
  # while ((left < right) && (position ~= k))                                    
  # The (left < right) condition reduces the number of iterations, but the       
  # gain is not compensated by the cost of the additional check. Therefore,      
  # we just check that position ~= k.                                            
  position <- -999                                                               
  while ((position !=  k)){                                                    
    
    # Swap the right sentinel with the pivot                                   
    pivot    <- A[pivotIndex]                                                  
    A[k]     <- A[right]                                                       
    A[right] <- pivot                                                          
    
    position <- left                                                           
    for (i in left:right){                                                     
      if (A[i]<pivot){                                                       
        # Swap A(i) with A(position)                                       
        # A([i,position])=A([position,i]) is more elegant but slower       
        Ai          <- A[i]                                                
        A[i]        <- A[position]                                         
        A[position] <- Ai                                                  
        
        position <- position+1                                             
      }                                                                      
    }                                                                          
    
    # Swap A(right) with A(position)                                           
    A[right]    <- A[position]                                                 
    A[position] <- pivot                                                       
    
    if ( position < k){                                                        
      left  <- position + 1                                                  
    } else {# --> 'elseif pos > k' as pos == k cannot occur (see 'while')      
      right <- position - 1                                                  
    }                                                                          
    
  }                                                                              
  
  kE <- A[k]                                                                     
  
  if (sortout == TRUE)
  {
    A[1:k-1] <- sort(A[1:k-1])                                                 
    out <- list(kE,A)
  } 
  else
  {
    out = kE
  }
  
} 
