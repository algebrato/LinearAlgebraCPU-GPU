#include <iostream>
#include <cstdlib>
#include <stdlib.h>
#include <stdio.h>
#include <ctime>
#include <cstdlib>

#define N 1024
//#define N 2048
//#define N 4096
//#define N 8192
//#define N 16384

#define IDX(i,j,N) (i*N+j)

#include "mat_tool.h"



int main(){

	float* diff = new float[20];
	
	for(int ITER=0; ITER<20; ITER++){	

	//matrice dei coefficienti
	double *A = new double[N*N];
	for(int i = 0; i < N; ++i)
		for(int j=0; j<N;j++)
			A[IDX(i,j,N)] = 20 * drand48();

	double *B = new double[N];
	for(int i=0; i<N; i++) 
		B[i] = 20 * drand48();

	
	//Mi serve una copia di A
	
	double *A_C = new double[N*N];
	for(int i = 0; i < N; ++i)
		for(int j=0; j<N;j++)
			A_C[IDX(i,j,N)] = A[IDX(i,j,N)];



	double *A_inv = new double[N*N]; 
	double *res = new double[N];


	clock_t T1;
	clock_t T2;
	
	T1=clock();
	Inverti(A,B,A_inv,N);
	//prodotto(A_C,B,res,N);
	T2=clock();

	 diff[ITER]=(float) (T2-T1)/CLOCKS_PER_SEC;

	/*
	printMatrix(A_C,N);
	printf("\n");
	printMatrix(A,N);
	printf("\n");
	printMatrix(A_inv,N);
	*/
	
	delete[](A);
	delete[](B);
	delete[](A_inv);
	delete[](res);
	}

	float media=0;
	for(int i=0;i<20;i++) media+= diff[i];
	
	media/=20;

	printf("%i \t %f\n",N,media);


	return 0;




}

