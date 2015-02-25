#define IDX(i,j,N) (i*N+j)
#include <cmath>
#include <cstdio>

#include "foo.h"


__global__ void pivoting(float *A, int k, int *pivrow, float *piv, int N){

	int it = threadIdx.x;
	int ib = blockIdx.x;

	int i = it + L_THREADS * ib;
	int passo = gridDim.x* L_THREADS;
		
	__shared__ float temp1[L_THREADS];
	__shared__ int temp2[L_THREADS];

	float temp;
	
	temp1[it] = 0.;
	temp2[it] = 0.;

	__syncthreads();
	
	//metto nella shared la matrice

	while(i<N){
		if(i>=k){
			temp = fabs(A[IDX(i,k,N)]);
			if(temp >= temp1[it]){
				temp1[it] = temp;
				temp2[it] = i;
			}
		}
		i +=passo;
	}
	__syncthreads();

		
	int l = blockDim.x / 2  ;
	
	//cerco il massimo 

	while(l != 0){
		if(it<l){
			if(temp1[it]<=temp1[it+l]){
				temp1[it] = temp1[it+l];
				temp2[it] = temp2[it+l];
			}
		}
		__syncthreads();
		l /= 2;
	}
	
	//il pivot sarà al posto zero di temp1
	if(it == 0){
		piv[ib] = temp1[0];
		pivrow[ib] = temp2[0];
	}

}

__global__ void pivoting3(float* A, int k, int* pivrow, float *piv, int N, const int N_BLOCKS){
	
		
	float temp=0;
	int temprow;
	for(int j=0; j < N_BLOCKS; j++){
		if(piv[j] >= temp ){
			temp = piv[j];
			temprow = pivrow[j];
		}
	}
	piv[0] = A[IDX(temprow,k,N)];
	pivrow[0] = temprow;
	return;
	
}


__global__ void scambio_riga(float* A, float* B, float* Ainv, int* pivrow, int k, int N){
	
	float temp1;
	float temp2;
	int j = threadIdx.x + blockDim.x*blockIdx.x;
	int passo = gridDim.x* blockDim.x;
	
	while(j < N){
		temp1 = A[IDX(pivrow[0],j,N)];
		A[IDX(pivrow[0],j,N)] = A[(IDX(k,j,N))];
		A[IDX(k,j,N)] = temp1;

		temp2 = Ainv[IDX(pivrow[0],j,N)];
		Ainv[IDX(pivrow[0],j,N)] = Ainv[IDX(k,j,N)];
		Ainv[IDX(k,j,N)] = temp2;

		j+=passo;
	}

	if(threadIdx.x + blockDim.x * blockIdx.x == 0){
		temp1 = B[pivrow[0]];
		B[pivrow[0]] = B[k];
		B[k] = temp1;
	}

	return;
}

__global__ void riscalamento(float* A, float* Ainv, float* B, int pivrow, int N, const float *piv){
	
	int j = threadIdx.x + blockDim.x*blockIdx.x;
	int passo = gridDim.x*blockDim.x;
	float pivot;
	pivot = 1/(*piv);

	while(j < N){
		A[IDX(pivrow,j,N)] *=pivot;
		Ainv[IDX(pivrow,j,N)] *= pivot;

		j += passo;
	}
	if(threadIdx.x + blockDim.x*blockIdx.x == 0)
		B[pivrow] *=pivot;
}

__global__ void Memorizzazione(float *A, float *app1, int N,int k){

	
	int i = threadIdx.x + blockDim.x*blockIdx.x;
	int passo = gridDim.x* blockDim.x;
	while(i < N){
		app1[i] = A[IDX(i,k,N)];
		i+=passo;
	}
	return;

}

__global__ void semplifico(float* A, float* Ainv, float* B, int pivrow, int N, float* app1 ){


	//cosa senza senso....
	int it = threadIdx.y;
	int jt = threadIdx.x;
	int jb = blockIdx.x;
	int ib = blockIdx.y;

	int i = it + THREADS*ib;
	int j = jt + THREADS*jb;
	//fine della cosa senza senso....

	if( i != pivrow ){
		A[IDX(i,j,N)] -=app1[i]*A[IDX(pivrow,j,N)];
		Ainv[IDX(i,j,N)] -= app1[i]*Ainv[IDX(pivrow,j,N)];
		if(j==0)
			B[i] -= app1[i]*B[pivrow];
	}
	return;


}
 
