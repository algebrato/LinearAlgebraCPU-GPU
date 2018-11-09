#include <stdio.h>
#include <cstdio>
#include <cstdlib>
#include <time.h>
#include <math.h>

//#define DIM 16000
//#define DIM 19200
//#define DIM 22400
//#define DIM 25600
#define DIM 16392
 
#define DIM_BLOC 32
#define DEVICE 0
void inizializza(int i){

        cudaDeviceProp prop;
        int count;

        cudaGetDeviceCount (&count);

        cudaGetDeviceProperties( &prop, i );
        printf("\n");
        printf("##############################################\n");
        printf("Device Name:\t\t %s\n",prop.name);
        printf("Shared Mem/block :\t %d\n",prop.sharedMemPerBlock);
        printf("Registri per blocco:\t %d\n",prop.regsPerBlock);
        printf("Warp size:\t\t %d\n",prop.warpSize);
        printf("Texature 1D :\t\t %d\n",prop.maxTexture1D);
        printf("MemPitch :\t\t %d\n",prop.memPitch);
        printf("##############################################\n");
        printf("\n");

}


__global__ void trasponi(float *out, float *idata, int larghezza, int altezza){
	__shared__ float SubMat[DIM_BLOC][DIM_BLOC];
	
	//Indice della matrice di input
	int xid = blockIdx.x * DIM_BLOC + threadIdx.x;
	int yid = blockIdx.y * DIM_BLOC + threadIdx.y;
	int indx_i = xid + yid*larghezza;
	
	//indice di quella di out ( con blocchi trasposti ) 
	int xxid = blockIdx.y * DIM_BLOC + threadIdx.x;
	int yyid = blockIdx.x * DIM_BLOC + threadIdx.y;
	int indx_o = xxid + yyid*altezza;


	for(int i=0; i<DIM_BLOC; i+=DIM_BLOC){
	       	SubMat[threadIdx.y+i][threadIdx.x] = idata[indx_i+i*larghezza];
	}

	__syncthreads();

	for(int i=0; i <DIM_BLOC; i+=DIM_BLOC){
		out[indx_o+i*altezza] = SubMat[threadIdx.x][threadIdx.y+i];
	}
	
}

__global__ void trasponiDiag(float *out, float *in, int larghezza, int altezza){
	
	__shared__ float SubMat[DIM_BLOC][DIM_BLOC+1];
	int BloccoX, BloccoY;
	
	BloccoY = blockIdx.x;
	BloccoX = (blockIdx.x+blockIdx.y)%gridDim.x;

	int xid = BloccoY * DIM_BLOC + threadIdx.x;
	int yid = BloccoX * DIM_BLOC + threadIdx.y;
	int index_i = xid +(yid)*larghezza;

	xid = BloccoY*DIM_BLOC + threadIdx.x;
	yid = BloccoX*DIM_BLOC + threadIdx.y;
	int index_o = xid + (yid)*altezza;

	for(int i=0; i<DIM_BLOC; i+=DIM_BLOC){
		SubMat[threadIdx.y+i][threadIdx.x] = in[index_i+i*larghezza];
	}
	__syncthreads();

	for(int i=0; i<DIM_BLOC; i+=DIM_BLOC){
		out[index_o+i*altezza]=SubMat[threadIdx.x][threadIdx.y+i];
	}


}



void getMatrixunitary(float* A, int NN){
	int indx=0;
	for(int i=0; i<NN; i++) for(int k=0; k<NN; k++){
		indx=k+i*NN;
		A[indx]=5.0;
	}
}



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

int main(){
	inizializza(DEVICE);

	float* h_mat = new float [DIM*DIM];
	float* h_out = new float [DIM*DIM];
	float* d_imat = new float [DIM*DIM];
	float* d_omat = new float [DIM*DIM];
	cudaEvent_t start, stop, T1,T2;
	cudaEventCreate(&start);
	cudaEventCreate(&stop);
	cudaEventCreate(&T1);
	cudaEventCreate(&T2);
		
	dim3 block((DIM)/DIM_BLOC,(DIM)/DIM_BLOC), threads(DIM_BLOC,DIM_BLOC); 
	//riempi la matrice

	cudaEventRecord(T1,0);

	getMatrix(h_mat,DIM);
	//printMatrix(h_mat,DIM);
	
	//Allocco memeoria 
	cudaMalloc((void**) &d_imat, DIM*DIM*sizeof(float));
	cudaMalloc((void**) &d_omat, DIM*DIM*sizeof(float));


	//copia della matrice H-->D
	cudaMemcpy(d_imat,h_mat,DIM*DIM*sizeof(float), cudaMemcpyHostToDevice);

	cudaEventRecord(start,0);
	trasponi<<<block, threads>>>(d_omat, d_imat, DIM, DIM);
	cudaEventRecord(stop,0);
	cudaEventSynchronize(stop);

	float TempoExe;
	cudaEventElapsedTime(&TempoExe,start,stop);

	printf("Tempo di Esecuzione: \t\t\t%f ms\n",TempoExe);

	cudaEventRecord(start,0);
	trasponiDiag<<<block, threads>>>(d_omat, d_imat, DIM, DIM);
	cudaEventRecord(stop,0);
	cudaEventSynchronize(stop);

	cudaEventElapsedTime(&TempoExe,start,stop);


	printf("Tempo di Esecuzione, No_CONFLICT: \t%f ms\n",TempoExe);


	cudaFree(d_imat);
	cudaFree(d_omat);
	free(h_mat);


	return 0;
}





