__global__ void pivoting(float * A, int k, int *pivrow, float *piv, int N);

__global__ void pivoting3(float* A, int k, int* pivrow, float *piv, int N, const int N_BLOCKS);

__global__ void scambio_riga(float* A, float* B, float* Ainv, int* pivrow, int k, int N);

__global__ void riscalamento(float* A, float* Ainv, float* B, int pivrow, int N, const float *piv);

__global__ void semplifico(float* A, float* Ainv, float* B, int pivrow, int N, float* app1 );

__global__ void Memorizzazione(float *, float *, int ,int ); 
