#import <objectbase.h>
#import <activity.h>
#import <collections.h>
#import "FEntity.h"
#import "FNet.h"

@interface BankModelSwarm : Swarm {
  int population ;
  int averageIncome ;
  double probIOP ;
  double probIOPSuccess ;
  double IOPmultiplier ;
  double probEncounter ;

  id modelActions;
  id modelSchedule;

  id graphCanvas;
  id theFNet;
  id entityList;
}

+createBegin: (id) aZone;
-createEnd;		

-(double) getProbEncounter ;	
-(double) getProbIOP ;	
-(double) getProbIOPSuccess ;	
-(double) getIOPmultiplier ;	
-getRandomFEntity ;
-getTheFNet ;
-getEntityList ;

-setGraphCanvas: aCanvas;
-buildObjects;
-buildActions;
-activateIn: (id) swarmContext;

@end
