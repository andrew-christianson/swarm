ifeq ($(SWARMHOME),)
SWARMHOME=/usr
endif

APPLICATION = conway1
OBJECTS = main.o ObserverSwarm.o  ConwayWorld.o

include $(SWARMHOME)/share/swarm/Makefile.appl
main.o: main.m ObserverSwarm.h 
ObserverSwarm.o: ObserverSwarm.m ObserverSwarm.h 
ConwayWorld.o: ConwayWorld.m ConwayWorld.h


