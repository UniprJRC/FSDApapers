// main.c demonstrates the use of quickselectFS and quickselectFSw
// for the computation of order statistics and weighted percentiles.
// It can be compiled in any platform and requires the following h-files:
//
// - simpleselect.h, which contains the c-code of quickselectFS and quickselectFSw. 
//   The same code is also available in separate files in folder ./C_individual.
//
// - mersenne.h, which is used to generate random numbers according to the
//   Mersenne Twister algorithm. This is done to facilitate the execution  
//   of consistency checks with the original functions in MATLAB. 
//   mersenne.h is a third party framework, taken from: 
//   http://www.math.sci.hiroshima-u.ac.jp/m-mat/MT/MT2002/CODES/mt19937ar.c

// Example with n=10, k=5, p=0.5.

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <math.h>

#include "simpleselect.h"
#include "mersenne.h"

int main()
{
    while (1) {
        
    // Select quickselectFS or quickselectFSw ... 

    int FSoFRw;

    printf("\n");
    printf("\n");
    printf("Digit 1 for : quickselectFS or 2 for quickselectFSw (3 to close the program) ");
    scanf("%d", &FSoFRw);

  // 1.

    // Generates random numbers using Mersenne Twister.
    // In order to replicate the numbers in MATLAB, for example with seed
    // 896, run first
    // RandStream.setGlobalStream(RandStream.create('mt19937ar','seed',896));
    // or 
    // myseed = 896; rng(myseed , 'twister');
    // and then the desired distribution, e.g.
    // mydata = rand(100,1);

   if ( FSoFRw == 1 )
    {
        int n;
        int k;

        printf("\n");
        printf("Digit n (Input lenght) = ");
        scanf("%d",&n);
        printf("\n");
        printf("Digit k (<=n) = ");
        scanf("%d",&k);

        printf("\n");
        printf("\n");
        printf(" ... n is  %d and k is %d",n,k);

        printf("\n");
        printf("\n");

        // Random numbers generation with Mersenne Twister.

        double D [n];
        uint32_t seed = 896;

        init_genrand(seed);

        for (int i = 0; i < n; ++i) {
            D[i] = genrand_res53();
         // printf("%.5f \n",D[i]);
        }


     double wE =quickselectFS(D,n,k-1);

     printf("quickselectFS result ...\n");

     printf("\n");
     printf("%f\n", wE);
     printf("\n");

    }

   else if ( FSoFRw == 2 )

    {
        int n;
        double p;

        printf("\n");
        printf("Digit n (Input lenght) = ");
        scanf("%d",&n);
        printf("\n");
        printf("We consider the first n numbers as D and the others 2+n (after normalization) as W\n");
        printf("\n");
        printf("Digit the oder statistic index (p) = ");
        scanf("%lf",&p);

        printf("\n");
        printf("\n");
        printf(" ... n is  %d and p is %lf",n,p);

        printf("\n");
        printf("\n");

        // Random numbers generation with Mersenne Twister.
        // Here we use same distribution for D and W, that is, we assign 
        // the first n numbers of MTn to D and the others 2+n (after 
        // normalization)to W.

        double MTn[2*n];
        uint32_t seed = 896;

        init_genrand(seed);

        for (int i = 0; i < 2*n; ++i) {
            MTn[i] = genrand_res53();
          // printf("%.5f \n",MTn[i]);
        }

        double D[n];
        double W[n];
        double sum=0;

         for (int i = 0; i < n; ++i) {
            D[i] = MTn[i];
           // printf("%.5f \n",D[i]);
        }

        for (int i = 0; i < n; ++i) {
            W[i] = MTn[n+i];
            sum = sum + W[i];
           // printf("%.5f \n",W[i]);
        }

        // normalization of W.
        for(int i = 0; i < n; i++){
         W[i]= W[i]/sum;
         // printf("%.5f \n",W[i]);
        }

         double* Kvalues=quickselectFSw(D,p,W,n);

         printf("\n");
         printf("quickselectFSw results ...\n");
         printf("\n");
         printf("kD is  %lf,\nkW is  %lf,\nand kstar is %lf\n",Kvalues[0],Kvalues[1],Kvalues[2]);
         printf("\n");
         printf("------------------------------------------------------------------------------\n");
    }

        else if ( FSoFRw == 3 )
            break;


    // 2.
    // Another simple example with data selected by the user.

   /*
    int n=10;
    int k=5;

    double D[n]={3,2,7,1,10,4,9,6,5,8};
    double p=0.9;
    double W[n]={0.0880,0.1126,0.0719,0.0429,0.0253,0.0264,0.0204,0.0448,0.1708,0.3968};

    double wE =quickselectFS(D,n,k-1);
    printf("quickselectFS result ...\n");

    printf("%f\n", wE);

    printf("\n");
    printf("\n");

    double* Kvalues=quickselectFSw(D,p,W,n);
    printf("quickselectFSw results ...\n");

    for(int i=0; i<3; i++) {
        printf("%f\n", Kvalues[i]);
    } 
   */

}
    return 0;
}



