// Swarm library. Copyright (C) 1996-1998 Santa Fe Institute.
// This library is distributed without any warranty; without even the
// implied warranty of merchantability or fitness for a particular purpose.
// See file LICENSE for details and terms of copying.

#import <objectbase/Swarm.h>
#import <objectbase.h>

@implementation Swarm

// Override this to let your Swarm create the objects that it contains.
- buildObjects
{
  return self;
}

// Override this to let your Swarm build its actions.
- buildActions
{
  return self;
}

// Override this to activate any actions you built in buildActions.
// Note, you must activate yourself first before you can activate actions
// inside you. Example subclass method:
//   [super activateIn: swarmContext];
//   [myFancySchedule activateIn: self];
//   return [self getSwarmActivity];
- activateIn:  swarmContext
{
  [super activateIn: swarmContext];
  return [self getSwarmActivity];
}


// These methods are needed to support probing of Swarms. Normally they
// comes from SwarmObject, but Swarm is not a subclass of SwarmObject.
// Multiple inheritance by cut and paste :-)

- getProbeMap
{
  return [probeLibrary getProbeMapFor: [self class]] ;
}

- getCompleteProbeMap
{
  return [probeLibrary getCompleteProbeMapFor: [self class]] ;
}

- getProbeForVariable: (const char *)aVariable
{
  return [probeLibrary getProbeForVariable: aVariable inClass: [self class]];
}

@end