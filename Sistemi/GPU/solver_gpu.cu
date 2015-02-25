#include <cstdlib>
#include <cstdio>
#include <ctime>
#include <iostream>

#include "mat_tool_gpu.h"
#include "foo.h"
#include "init.h"


#define H_D cudaMemcpyHostToDevice 
#define D_H cudaMemcpyDeviceToHost

#define CUDA_COPIA(a,b,c,d) cudaMemcpy(a,b,c,d)



#define N_or 1024
//#define N_or 2048
//#define N_or 4096
//#define N_or 8192
//#define N_or 16384





#define IDX(i,j,N) (i*N+j)
#define DEV 0

#define imin(a,b) (a<b)?a:b


int main(){
	
	inizializza(DEV);


	cudaSetDevice(DEV);

        int N = N_or;
        //const int N_BLOCKS = imin(32,(N+ L_THREADS-1)/L_THREADS );
	
	const int N_BLOCKS = N/16;	

	std::cout<<N_BLOCKS<<std::endl;

	float* A_h = new float[N*N];
	float* B_h = new float[N];
	float* Ainv_h = new float[N*N];
	

	
	float *A_dev, *B_dev, *Ainv_dev;

	//Matrice A
	for(int i=0; i<N; i++)
		for(int j=0; j<N; j++)
			A_h[IDX(i,j,N)] = 20*(drand48()-0.5);

	//Matrice Ainv= Id
	for(int i=0; i<N; i++)
		for(int j=0; j<N; j++){
			if(i == j) 
				Ainv_h[IDX(i,j,N)] = 1.;
			else
				Ainv_h[IDX(i,j,N)] = 0.;
		}

	//Termini Noti B
	for(int i=0; i<N; i++)
		B_h[i] = 20*(drand48()-0.5);
	

	cudaEvent_t T1, T2;
	cudaEventCreate(&T1);
	cudaEventCreate(&T2);
	cudaEventRecord(T1,0);

	//Allocazione di memoria sulla scheda
	cudaMalloc((void**)&A_dev, N*N*sizeof(float));
	cudaMalloc((void**)&B_dev, N*N*sizeof(float));
	cudaMalloc((void**)&Ainv_dev, N*N*sizeof(float));
	


	//Trasferimento dati
	//cudaMemcpy(A_dev, A_h, N*N*sizeof(float), cudaMemcpyHostToDevice);

	CUDA_COPIA(A_dev,A_h,N*N*sizeof(float),H_D);
	cudaMemcpy(Ainv_dev, Ainv_h, N*N*sizeof(float), cudaMemcpyHostToDevice);
	cudaMemcpy(B_dev, B_h, N*sizeof(float), cudaMemcpyHostToDevice);
	//dim3 threads(THREADS,THREADS);
	//dim3 blocks((N+THREADS-1)/THREADS,(N+THREADS-1)/THREADS);
	
	dim3 threads(THREADS,THREADS);
	dim3 blocks(N/THREADS,N/THREADS);


	int* pivrow_dev;
	float* piv_dev;
	float* app1_dev;
	
	cudaMalloc((void**)&pivrow_dev,N_BLOCKS*sizeof(int));
	cudaMalloc((void**)&piv_dev,N_BLOCKS*sizeof(float));
	cudaMalloc((void**)&app1_dev,N*sizeof(float));
	
	for(int i=0; i<N; i++){
		/*
		pivoting<<<N_BLOCKS,L_THREADS>>>(A_dev, i, pivrow_dev, piv_dev, N);
		pivoting3<<<1,1>>>(A_dev, i, pivrow_dev, piv_dev, N, N_BLOCKS);
		scambio_riga<<<(N+L_THREADS-1)/L_THREADS, L_THREADS>>>(A_dev, B_dev, Ainv_dev, pivrow_dev, i, N);
		riscalamento<<<(N+L_THREADS-1)/L_THREADS, L_THREADS>>>(A_dev, Ainv_dev, B_dev, i, N, piv_dev);
		Memorizzazione<<<(N+L_THREADS-1)/L_THREADS,L_THREADS>>>(A_dev, app1_dev, N, i);
		semplifico<<<blocks,threads>>>(A_dev, Ainv_dev, B_dev, i, N, app1_dev);
		*/
	
		
		pivoting<<<N/L_THREADS,L_THREADS>>>(A_dev, i, pivrow_dev, piv_dev, N);
                pivoting3<<<1,1>>>(A_dev, i, pivrow_dev, piv_dev, N, N_BLOCKS);
                scambio_riga<<<N/L_THREADS, L_THREADS>>>(A_dev, B_dev, Ainv_dev, pivrow_dev, i, N);
                riscalamento<<<N/L_THREADS, L_THREADS>>>(A_dev, Ainv_dev, B_dev, i, N, piv_dev);
                Memorizzazione<<<N/L_THREADS,L_THREADS>>>(A_dev, app1_dev, N, i);
                semplifico<<<blocks,threads>>>(A_dev, Ainv_dev, B_dev, i, N, app1_dev);
	
	}
	
	cudaFree(pivrow_dev);
	cudaFree(piv_dev);
	cudaFree(app1_dev);
	
	//A_dev --> Id
	//Ainv_dev --> inversa di A
	//B_dev --> soluzione
	

	cudaMemcpy(A_h, A_dev, N*N*sizeof(float), cudaMemcpyDeviceToHost);
	cudaMemcpy(Ainv_h, Ainv_dev, N*N*sizeof(float), cudaMemcpyDeviceToHost);

	cudaEventRecord(T2,0);
	cudaEventSynchronize(T2);

	float diff_time;
	
	cudaEventElapsedTime(&diff_time,T1,T2);

	printf("%i\t%f\n",N,diff_time/1000.);

/*	
	for(int i=0; i<N; i++){
		for(int j=0; j<N; j++)
			printf("%f\t",A_h[j+i*N]);
		printf("\n");
	}
*/	

	cudaEventDestroy(T1);
	cudaEventDestroy(T2);
	cudaFree(A_dev);
	cudaFree(B_dev);
	cudaFree(Ainv_dev);
	
	delete[](A_h);
	delete[](B_h);
	delete[](Ainv_h);
	
	return 0;
}
