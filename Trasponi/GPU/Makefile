VERSION 	= 0
PATHLEVEL	= 1
SUBLEVEL	= 0
EXTRAVERSION 	= 
NAME		= Tasposizione Matrici Quadrate - Stefano Mandelli
DATE		= 02-April-2013

## Switch #######################################
#HOST		:=true
DEVICE		:=true
DEBUGMODE	:= true
#################################################


#Host makefile ##################################

ifdef HOST
CC		:= g++ 
ESEGUIBILE 	:= trasponi_host.x
OBJ		:= trasponi.o
ifdef DEBUGMODE
FLAGS    	:= -Wall -O2 -g -Wunused-variable
else
FLAGS    	:= -O2 -Wunused-variable 
endif

%.o : %.cpp
	$(CC) ${FLAGS} -c $< 

.PHONY: ${ESEGUIBILE}
${ESEGUIBILE}: ${OBJ}
	$(CC) ${FLAGS} -o $@ $^

.PHONY: clean
clean:
	rm -rf *.o *.x
endif


#Makefile for the Device ########################

ifdef DEVICE
NVCC		:= nvcc
ESEGUIBILE	:= trasponi_gpu.x
OBJ		:= trasponi_gpu.o
ifdef DEBUGMODE
FLAGS 		:= -O2 -g --ptxas-options=-v
#ARCH 		:= -arch=sm_20
else
FLAGS		:= -O2
#ARCH		:= -arch=sm_20
endif
%.o : %.cu
	$(NVCC) ${FLAGS} ${ARCH} -c $< 

.PHONY: ${ESEGUIBILE}
${ESEGUIBILE}: ${OBJ}
	$(NVCC) ${FLAGS} ${ARCH} -o $@ $^	

.PHONY: clean
clean:
	rm -rf *.o *.x
endif

