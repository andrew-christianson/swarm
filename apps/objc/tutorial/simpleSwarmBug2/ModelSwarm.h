// ModelSwarm.h					SimpleBug App

#import "Bug.h"
#import "FoodSpace.h"
#import <objectbase/Swarm.h>
#import <space.h>

@interface ModelSwarm: Swarm
{
  int worldXSize, worldYSize;
  float seedProb;
  float bugDensity;

  FoodSpace *food;
  id <Grid2d> world;
  Bug *reportBug;

  id bugList;
  id modelActions;
  id modelSchedule;
}

+ createBegin: aZone;
- createEnd;
- buildObjects;
- buildActions;
- (id <Activity>)activateIn: swarmContext;

@end


