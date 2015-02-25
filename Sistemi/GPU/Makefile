VERSION 	= 0
PATHLEVEL	= 1
SUBLEVEL	= 0
EXTRAVERSION 	= 
NAME		= Sistemi Lineari - Stefano Mandelli
DATE		= 03-April-2013

## Switch #######################################
#HOST		:=true
#CONDOR		:=true
DEVICE		:=true
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
FLAGS    	:= -Wall -O2 -g -Wunused-variable
else
FLAGS    	:= -Wall -O2 -Wunused-variable 
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
ESEGUIBILE	:= solver_gpu.x
OBJ		:= solver_gpu.o mat_tool_gpu.o init.o
ifdef DEBUGMODE
FLAGS 		:= -O2 -g -G --ptxas-options=-v
ARCH 		:= -arch=sm_20
else
FLAGS		:= -O2
ARCH		:= -arch=sm_20
endif
%.o : %.cu
	$(NVCC) ${FLAGS} ${ARCH} -c $< 

.PHONY:	${ESEGUIBILE}
${ESEGUIBILE}: ${OBJ}
	$(NVCC) ${FLAGS} ${ARCH} -o $@ $^

.PHONY:	clean
clean:
	rm -rf *.o *.x
endif

