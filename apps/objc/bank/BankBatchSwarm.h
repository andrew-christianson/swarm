// Copyright � 1996-2000 Swarm Development Group.
#import "BankModelSwarm.h"
#import <objectbase/Swarm.h>

@interface BankBatchSwarm: Swarm
{
  int displayFrequency;

  id displayActions;	
  id displaySchedule;
  id stopSchedule;

  BankModelSwarm *bankModelSwarm;
#if 0
  Averager *unhappinessAverager;	
#endif
  FILE *outputFile;			
}

+ createBegin: aZone;
- buildObjects;
- buildActions;
- activateIn: swarmContext;
- go;

// special message on ourselves to stop running.
- stopRunning;

// special data write method
- writeData;

@end
