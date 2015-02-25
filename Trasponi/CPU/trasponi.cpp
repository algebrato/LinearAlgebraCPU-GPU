#include <stdio.h>
#include <cstdio>
#include <cstdlib>
#include <ctime>
#include <math.h>

#include"mat_tool.h"


#define DIM 16000
//#define DIM 19200
//#define DIM 22400
//#define DIM 25600
//#define DIM 28800



int main(){
	float* A = new float [DIM*DIM];
	float* B = new float [DIM*DIM];
	
	clock_t T1;
	clock_t T2;


	getMatrix(A,DIM);
	//printMatrix(A,DIM);

	T1 = clock();
	trasponi(A,B,DIM);
	T2 = clock();

	float diff = ((float) (T2-T1))/CLOCKS_PER_SEC;

	//printf("\n");
	//printMatrix(B,DIM);


	printf("Tempo: %f\n",diff);
	
	delete[](A);
	delete[](B);

	return 0;

}



