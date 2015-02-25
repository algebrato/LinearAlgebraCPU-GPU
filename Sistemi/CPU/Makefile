VERSION 	= 0
PATHLEVEL	= 1
SUBLEVEL	= 0
EXTRAVERSION 	= 
NAME		= Sistemi Lineari - Stefano Mandelli
DATE		= 03-April-2013

## Switch #######################################
HOST		:=true
#CONDOR		:=true
#DEVICE		:=true
#DEBUGMODE	:=true
#################################################


#Host makefile ##################################

ifdef HOST
ifdef CONDOR
CC		:= condor_compile g++
else
CC		:= g++
endif
ESEGUIBILE 	:= solver.x
OBJ		:= system_solver.o mat_tool.o
ifdef DEBUGMODE
FLAGS    	:= -Wall -O3 -g -Wunused-variable
else
FLAGS    	:= -Wall -O3 -Wunused-variable 
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
OBJ		:= trasponi.cu
ifdef DEBUGMODE
FLAGS 		:= -Wall -O2 -g --ptxas-options=-v
ARCH 		:= -arch=sm_20
else
FLAGS		:= -Wall -O2
ARCH		:= -arch=sm_20
endif
%.o : %.cpp
	$(NVCC) ${FLAGS} ${ARCH} -c $< 

${ESEGUIBILE}:
	$(NVCC) ${FLAGS} ${ARCH} -o $@ $^

clean:
	rm -rf *.o *.x
endif

