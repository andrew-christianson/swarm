ifeq ($(SWARMHOME),)
SWARMHOME=/usr
endif
APPLICATION=mousetrap
APPVERSION=2.1
BUGADDRESS=bug-swarm@swarm.org
OBJECTS=main.o Mousetrap.o MousetrapModelSwarm.o MousetrapObserverSwarm.o MousetrapBatchSwarm.o
DATAFILES = batch.scm

include $(SWARMHOME)/etc/swarm/Makefile.appl

main.o: main.m MousetrapObserverSwarm.h MousetrapBatchSwarm.h
Mousetrap.o: Mousetrap.m Mousetrap.h
MousetrapModelSwarm.o: MousetrapModelSwarm.m MousetrapModelSwarm.h
MousetrapObserverSwarm.o: MousetrapObserverSwarm.h MousetrapObserverSwarm.m
MousetrapBatchSwarm.o: MousetrapBatchSwarm.h MousetrapBatchSwarm.m
