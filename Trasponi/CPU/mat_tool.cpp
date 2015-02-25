#include <stdio.h>
#include <cstdio>
#include <cstdlib>
#include <time.h>
#include <math.h>


void getMatrix(float* A,int NN){
        int indx=0;
        srand(time(NULL));
        for(int i=0; i<NN; i++) for(int k=0; k<NN; k++){
                indx=k+i*NN;
                A[indx]=rand()%32;
        }
}

void printMatrix(float* A,int NN){
        int index=0;
        for(int i=0; i<NN; i++ ){
                for(int k=0; k<NN; k++){
                        index=k+i*NN;
                        printf("%f\t",A[index]);
                }
                printf("\n");
        }
}

void trasponi(float* A, float* B, int DIM){
	for(int y=0; y<DIM; y++)
		for(int x=0; x<DIM; x++) 
			B[x*DIM+y] = A[x+y*DIM];
}


