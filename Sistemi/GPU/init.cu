#include <cstdio>


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


