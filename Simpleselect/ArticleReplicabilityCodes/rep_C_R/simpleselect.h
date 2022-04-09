// simpleselect.h contains the C-code of quickselectFS and quickselectFSw
// by Azzini, Perrotta and Torti (2022). These functions compute in linear 
// time order statistics and weighted percentiles with an iterative 
// algorithm equivalent to Hoare's Find. The original code is in MATLAB. 
// This C-translation is to simplify replication in other  development
// environments and comparison of performances with other algorithms.


// Functions prototype //
double  quickselectFS(double A[], int n, int k);
double* quickselectFSw(double D[], double p, double W[],int n);

// *********************************** //
// Functions definition: quickselectFS //
// *********************************** //

double quickselectFS(double A[], int n, int k)
{
    /* local variable declaration */
    int left=0;
    int right=n;

    int position=-1;

    double pivot;
    double buffer;

    // returned value
    double wE=-1;

    while ( position != k )
    {

        pivot=A[k];

        A[k]=A[right];
        A[right]=pivot;

        position=left;

        for (int i = left; i <= right; i++)
        {

            if(A[i]<pivot)
            {

                buffer=A[i];
                A[i]=A[position];
                A[position]=buffer;

                position=position+1;
            }
        }

        A[right]=A[position];
        A[position]=pivot;

        if  (position < k)
        {
            left  = position + 1;
        }

        else
        {
            right = position - 1;
        }

    }

    return wE=A[k];
}

// ************************************ //
// Functions definition: quickselectFSw //
// ************************************ //

double* quickselectFSw(double D[], double p, double W[],int n)
{

    // Output variable.
    double kD;
    double kW;
    int kstar;

    // Array contained the above variables.
    static double Kvalues[2];

    // Local variable declaration and initialization.
    int left            = 0;
    int right           = n-1;
    int position        = -1;
    int k               = ceil(n*p)-1;
    int BleichOverton   = 1;

    double pivotD;
    double pivotW;
    double buffer;
    double Le;

    while ( BleichOverton )
    {
        position=-1;

        //The internal loop is like in quickselectFS
        while ( position != k )
        {

            pivotD   = D[k];
            D[k]     = D[right];
            D[right] = pivotD;

            pivotW   = W[k];
            W[k]     = W[right];
            W[right] = pivotW;

            position = left;

            for (int i = left; i <= right; i++)
            {
                if(D[i]<pivotD)
                {
                    buffer = D[i];
                    D[i]   = D[position];
                    D[position] = buffer;

                    buffer = W[i];
                    W[i]   = W[position];
                    W[position] = buffer;

                    position=position+1;
                }
            }

            D[right]    = D[position];
            D[position] = pivotD;

            W[right]    = W[position];
            W[position] = pivotW;

            if  (position < k)
            {
                left  = position + 1;
            }
            else
            {
                right = position - 1;
            }

        }

        // Checks on weights extends Bleich-Overton
        double Le = 0;          // Le = sum(W(1:k-1));
        for(int j = 0; j < k; j++)
        {
            Le += W[j];
        }

        if ((Le-p<=0) && (p-Le-W[k]<=0))
        {
            // The condition is met: stop computation.
            kD    = D[k];
            kW    = W[k];
            kstar = k+1;
            BleichOverton = 0;
        }
        else
        //    The conditions not met: go back to quickselectFS with new
        //    sentinels - (k,n) or (1,k) - and new order statistics -
        //    k+1 or k-1 (see point 8 and 9.).
        {
            if  (W[k] < 2*(p-Le))
            {
                // Need to add weight to reach the condition in point 5.
                // Add an element (weight and data) to the left part.
                k     = k+1;
                left  = k;
                right = n-1;
            }
            else
            {
                // Here, we have that D(k,2)> 2*(p-Le). Need to remove an
                // element (weight and data) from the right part.
                k     = k-1;
                left  = 0;
                right = k;
            }
        }
    }

    // Return the values in output

    Kvalues[0]=kD;
    Kvalues[1]=kW;
    Kvalues[2]=kstar;

    return Kvalues;
}

