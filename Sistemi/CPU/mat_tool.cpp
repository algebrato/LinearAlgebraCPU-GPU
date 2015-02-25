#include <iostream>
#include <cmath>
#include <cstdlib>
#include <cstdio>
#include <ctime>
#include <time.h>
#define IDX(i,j,N) (i*N+j)


void SWAP(double &a, double &b){
	
	double temp;
	temp=a;
	a=b;
	b=temp;
	
	return;
}



void Inverti(double* A, double* B, double *A_inv, int N){

	double temp;
	double piv;
	int pivrow;
	double pivinv;

	//A_inv = Id
	for(int i=0; i<N; i++)
		for(int j=0; j<N; j++){
			if(i==j)
				A_inv[IDX(i,j,N)] = 1.;
			else
				A_inv[IDX(i,j,N)] = 0.;
		}
	for(int i=0; i<N; i++){
		piv=0;
		for(int j=0; j<N ; j++){
			temp = fabs(A[IDX(i,j,N)]);
			if(temp > piv){
				piv = temp;
				pivrow = j;
			}
		}
		piv = A[IDX(pivrow,i,N)];

		//scambio la riga pivrow con quella i;

		for(int j=0; j<N; j++){
			SWAP(A[IDX(i,j,N)],A[IDX(pivrow,j,N)]);
			SWAP(A_inv[IDX(i,j,N)],A_inv[IDX(pivrow,j,N)]);
		
		}
		SWAP(B[i],B[pivrow]);

		//riscalo
		pivinv = 1./piv;
		for(int j=0; j<N; j++){
			 A[IDX(i,j,N)] *= pivinv;
			 A_inv[IDX(i,j,N)] *= pivinv;
		}
		B[i] *= pivinv;

		//eseguo la sottrazione;
		

		for(int j=0; j<N; j++)
			if(j != i){
				temp = A[IDX(j,i,N)];
				for(int k=0; k<N; k++){
					A[IDX(j,k,N)] -= temp*A[IDX(i,k,N)];
					A_inv[IDX(j,k,N)] -= temp*A_inv[IDX(i,k,N)];

				}
				B[j] -= temp*B[i];
			}
	}
}

void getMatrix(double* A,int NN){
        int indx=0;
        srand(time(NULL));
        for(int i=0; i<NN; i++) for(int k=0; k<NN; k++){
                indx=k+i*NN;
                A[indx]=rand()%32;
        }
}

void printMatrix(double* A,int NN){
        int index=0;
        for(int i=0; i<NN; i++ ){
                for(int k=0; k<NN; k++){
                        index=k+i*NN;
                        printf("%f\t",A[index]);
                }
                printf("\n");
        }
}

void trasponi(double* A, double* B, int DIM){
        for(int y=0; y<DIM; y++)
                for(int x=0; x<DIM; x++)
                        B[x*DIM+y] = A[x+y*DIM];
}

