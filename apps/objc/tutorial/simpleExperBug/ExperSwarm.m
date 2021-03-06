// ExperSwarm.m					simpleExperBug

#import "ExperSwarm.h"
#import <simtoolsgui.h>
#import <defobj.h> // Archivers
#include <misc.h> // unlink

@implementation ParameterManager

  // The ParameterManager handles the parameter manipulation for
  //     the series of models run during the experiment

- (void)initializeParameters
{
  // Create a probeDisplay to show the parameterManager

  CREATE_ARCHIVED_PROBE_DISPLAY (self);
}

- (void)initializeModel: theModel
{
  [theModel setWorldXSize: worldXSize YSize: worldYSize];
  [theModel setSeedProb: seedProb bugDensity: bugDensity];
}


- (BOOL)stepParameters
{
  seedProb += seedProbInc;
  bugDensity += bugDensityInc;
 
  if ((seedProb > seedProbMax) || (bugDensity > bugDensityMax))
    return NO;

  return YES;
}

- (void)printParameters: (id <Archiver>)archiver
                 number: (unsigned)number
                   time: (unsigned)theTime
{
  char buf[5 + DSIZE (unsigned) + 1];

  time = theTime;
  sprintf (buf, "model%03u", number);
  [archiver putShallow: buf object: self];
}

@end

@implementation ExperSwarm

  // ExperSwarm manages creating, running, analyzing, and dropping
  // a series of models throughout an experimental run.


+ createBegin: aZone
{
  ExperSwarm *obj;
  id <ProbeMap> theProbeMap;

  // invoke our superClass createBegin to allocate ourselves.
  // obj is the allocated ExperSwarm
  
  obj = [super createBegin: aZone];

  // Fill in the relevant parameters 

  obj->numModelsRun = 0;

  // Build a customized probe map for ExperSwarm

  theProbeMap = [EmptyProbeMap createBegin: aZone];
  [theProbeMap setProbedClass: [self class]];
  theProbeMap = [theProbeMap createEnd];

  [theProbeMap addProbe: [probeLibrary getProbeForVariable: "numModelsRun"
                                   inClass: [self class]]];

  [probeLibrary setProbeMap: theProbeMap For: [self class]];

  return obj;		// We return the newly created ExperSwarm
}


- _resultGraphDeath_
{
  [resultGraph drop];
  resultGraph = nil;
  return self;
}

- buildObjects
{
  // Create the objects used by the experiment swarm itself

  // First, let our superClass build any objects it needs 
 
  [super buildObjects];

  // Build the parameter manager, using the parameterManager data stored in
  // the `bug.scm' datafile.

  if ((parameterManager = 
       [lispAppArchiver getWithZone: self key: "parameterManager"]) == nil)
    raiseEvent(InvalidOperation,
               "Can't find the parameterManager parameters");
  
  [parameterManager initializeParameters];

  // Build a probeDisplay on ourself

  CREATE_ARCHIVED_PROBE_DISPLAY (self);

  // build the EZGraph for model results

  resultGraph = [EZGraph createBegin: self];
  SET_WINDOW_GEOMETRY_RECORD_NAME (resultGraph);
  [resultGraph setTitle: "Model Run Times"];
  [resultGraph setAxisLabelsX: "Model #" Y: "Run Time"];
  resultGraph = [resultGraph createEnd] ;

  [resultGraph enableDestroyNotification: self
               notificationMethod: @selector (_resultGraphDeath_)];

  // Create a sequence to track model run times.
  // Since we keep changing models, we feed from our own method
  // "getModelTime" which will probe the correct instance of 
  // ModelSwarm

  [resultGraph createSequence: "runTime"
                 withFeedFrom: self 
                  andSelector: M(getModelTime)];

  // Allow the user to alter experiment parameters

  [controlPanel setStateStopped];

#ifndef USE_LISP
  unlink ("output.hdf");
  archiver = [HDF5Archiver create: self setPath: "output.hdf"];
#else
  unlink ("output.scm");
  archiver = [LispArchiver create: self setPath: "output.scm"];
#endif

  return self;
}



- buildActions
{
// Create the actions necessary for the experiment. This is where
// the schedule is built (but not run!)

  // First, let our superclass build any actions

  [super buildActions];

  // Create an ActionGroup for experiment: a bunch of things that occur in
  // a specific order, but in the same step of simulation time. 

  experActions = [ActionGroup create: self];

  // Schedule up the methods to  build the model, run it, collect data,
  // display the data, log the results, and drop the model.  

  [experActions createActionTo: self	message: M(buildModel)];
  [experActions createActionTo: self	message: M(runModel)];
  [experActions createActionTo: self	message: M(doStats)];
  [experActions createActionTo: self	message: M(showStats)];
  [experActions createActionTo: self	message: M(logResults)]; 
  [experActions createActionTo: self	message: M(dropModel)];

 // Check to see if the experiment has ended (all the models have been run).

  [experActions createActionTo: self     message: M(checkToStop)];

  // Schedule the update of the probe display

  [experActions  createActionTo: probeDisplayManager message: M(update)];

  // Finally, schedule an update for the whole user interface code.

  [experActions createActionTo: actionCache          message: M(doTkEvents)];

  // Now make the experiment schedule. Note the repeat interval is 1
  
  experSchedule = [Schedule createBegin: self];
  [experSchedule setRepeatInterval: 1];
  experSchedule = [experSchedule createEnd];
  [experSchedule at: 0 createAction: experActions];

  return self;
}  



- activateIn: swarmContext
{
// activateIn: - activate the schedules so they're ready to run.
// The swarmContext argument has to do with what we were activated *in*.
// Typically an ExperimentSwarm is the top-level Swarm, so swarmContext
// is "nil". The model we run will be independent of our activity.
// We will activate it in "nil" when we build it later.

  // First, activate ourselves (just pass along the context).

  [super activateIn: swarmContext];

  // Now activate our schedule in ourselves. This arranges for the
  // execution of the schedule we built.

  [experSchedule activateIn: self];

  return [self getActivity];
}


// --- End of ExperSwarm buildObjects, buildActions, and activateIn ---


// Now that we've built the Experiment Swarm, here are the methods for
// building, running, examining, and dropping the modelSwarms


- buildModel
{
  // Here, we create an instance of the model that we're managing.
  // The model is a subswarm of the experiment. We create the model in
  // *within* the current ExperSwarm! - this creates a separate
  // segregated part of the current Zone. We can drop everything we
  // create in the modelSwarm later by just dropping the modelSwarm
  // itself. Note that this excludes any separately allocated memory
  // outside of the Zone mechanism and any GUI widgets.

  modelSwarm = [ModelSwarm create: self];

  // If this is the first model, create a custom probeMap for modelSwarm 
  // and construct a graph displaying model results

  if (numModelsRun == 0)
    {
      // Build a customized probe map for the class ModelSwarm
      
      modelProbeMap = [EmptyProbeMap createBegin: self];
      [modelProbeMap setProbedClass: [modelSwarm class]];
      modelProbeMap = [modelProbeMap createEnd];
      
      // Add in a bunch of variables, one per simulation parameter
      
      [modelProbeMap addProbe: [probeLibrary getProbeForVariable: "worldXSize"
                                             inClass: [modelSwarm class]]];
      [modelProbeMap addProbe: [probeLibrary getProbeForVariable: "worldYSize"
                                             inClass: [modelSwarm class]]];
      [modelProbeMap addProbe: [probeLibrary getProbeForVariable: "seedProb"
                                             inClass: [modelSwarm class]]];
      [modelProbeMap addProbe: [probeLibrary getProbeForVariable: "bugDensity"
                                             inClass: [modelSwarm class]]];
      // Now install our custom probeMap into the probeLibrary.
      
      [probeLibrary setProbeMap: modelProbeMap For: [modelSwarm class]];
      
    } 		// endif
  
  // Now, we invoke the parameterManager to initialize the model 
  
  [parameterManager initializeModel: modelSwarm];

  // Let the modelSwarm build its objects and actions and activate
  // it in "nil", giving us a new activity. We don't start it here...
  // we will start models from the ExperSwarm schedule.
  
  [modelSwarm buildObjects];
  [modelSwarm buildActions];
  [modelSwarm activateIn: nil];

  return self;
}  


- runModel
{
  // We have built the model and activated it - here is where we run it.
  // When it has terminated, control will return here.

  printf("\nStarting model %d \n", numModelsRun+1);

  [[modelSwarm getActivity] run];

  printf("Model %d is done \n", numModelsRun+1);

  numModelsRun++;               // increment count of models

  return self;
}


- doStats
{
  // Collect a datapoint on the model

  modelTime =  [modelSwarm getTime];
  printf("Length of this run = %d \n", modelTime);

  return self;
}


- (unsigned)getModelTime
{
  // This method feeds the EZGraph "runTime" sequence  
  // this always points to the current modelSwarm 

   return [modelSwarm getTime];
}


- logResults
{
  // have the parameterManager log its state
  [parameterManager printParameters: archiver
                    number: numModelsRun - 1
                    time: modelTime];
#ifdef USE_LISP
  [archiver sync];
#endif
  return self;
}

- showStats
{
  if (resultGraph)
    [resultGraph step];			// step the result Graph

  return self;
}


- dropModel
{
  // The model has finished and we've extracted the data we need from
  // it.  We drop the modelSwarm which drops of the objects built by modelSwarm
  [modelSwarm drop];

  return self;
}


- checkToStop
{
  // If all the models have run, time to quit!

  // If we step the parameterManager and it exceeds the parameter bounds,
  // it returns nil, so we have stepped through all the models and
  // we can quit the experiment. We first make sure that the
  // displays are updated, and set the controlPanel to "stop".

  if (!([parameterManager stepParameters]))
    {
      
      [probeDisplayManager update];
      [actionCache doTkEvents];
      
      printf("\n All the models have run!\n");

      [archiver drop];
      [controlPanel setStateStopped];
    }
  
  return self;
}


@end
