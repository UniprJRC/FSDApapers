#include "mex.h"

/* Some sample C code for the quickselect algorithm, 
   taken from Numerical Recipes in C. */

#define SWAP(a,b) temp=(a);(a)=(b);(b)=temp;

void quickselect(double *arr, int n, int k) {
  unsigned long i,ir,j,l,mid;
  double a,temp;

  l=0;
  ir=n-1;
  for(;;) {
    if (ir <= l+1) { 
      if (ir == l+1 && arr[ir] < arr[l]) {
	SWAP(arr[l],arr[ir]);
      }
      // return arr[k];
      return;
    }
    else {
      mid=(l+ir) >> 1; 
      SWAP(arr[mid],arr[l+1]);
      if (arr[l] > arr[ir]) {
	SWAP(arr[l],arr[ir]);
      }
      if (arr[l+1] > arr[ir]) {
	SWAP(arr[l+1],arr[ir]);
      }
      if (arr[l] > arr[l+1]) {
	SWAP(arr[l],arr[l+1]);
      }
      i=l+1; 
      j=ir;
      a=arr[l+1]; 
      for (;;) { 
	do i++; while (arr[i] < a); 
	do j--; while (arr[j] > a); 
	if (j < i) break; 
	SWAP(arr[i],arr[j]);
      } 
      arr[l+1]=arr[j]; 
      arr[j]=a;
      if (j >= k) ir=j-1; 
      if (j <= k) l=i;
    }
  }
}


/* The gateway routine */
void mexFunction(int nlhs, mxArray *plhs[],
        int nrhs, const mxArray *prhs[])
{
    double *arr;
    int n;
    int k;
    
    
    /* Create a pointer to the input vector A. */
    arr = mxGetPr(prhs[0]);
    
    /* Get the integer input n. */
    n = mxGetScalar(prhs[1]);
    
    /* Get the integer input k. */
    k = mxGetScalar(prhs[2]);
    
    
    /* Call the timestwo_alt subroutine. */
    quickselect(arr,n,k);
}