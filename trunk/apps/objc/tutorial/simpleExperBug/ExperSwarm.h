// ExperSwarm.h					simpleExperBug

// The ExperSwarm is a swarm that manages multiple invocations of a
// model. 

#import "ModelSwarm.h"
#import <simtoolsgui/GUISwarm.h>
#import <objectbase/SwarmObject.h>
#import <objectbase.h>
#import <analysis.h>

// First, the interface for the ParameterManager

@interface ParameterManager: SwarmObject
{
  int worldXSize;
  int worldYSize;

  float seedProb;
  float bugDensity;

  float seedProbInc;
  float bugDensityInc;

  float seedProbMax;
  float bugDensityMax;

  id <ProbeMap> pmProbeMap;
}

- initializeParameters;
- initializeModel: theModel;
- stepParameters;
- printParameters: anOutFile;

@end




// Now, the Experiment Swarm Interface

@interface ExperSwarm: GUISwarm
{
  int modelTime;				// model run time
  int numModelsRun;				// number of models run

  id experActions;				// schedule data structs
  id experSchedule;

  ModelSwarm *modelSwarm;			// the Swarm we're iterating 

  ParameterManager *parameterManager; 		// An object to manage model
						// parameters

  id <OutFile> logFile;				// File to log run results

 // Display objects, widgets, etc.

  id <EZGraph> resultGraph;				// graphing widget
  id <ProbeMap> modelProbeMap;			// the ProbeMap for the modelSwarm
}

// Methods overriden to make the the Experiment Swarm

+ createBegin: aZone;
- createEnd;

- buildObjects;
- buildActions;
- activateIn: swarmContext;			// Context is self (ObserverSwarm).

@end
