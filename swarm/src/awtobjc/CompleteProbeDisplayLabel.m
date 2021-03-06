// Swarm library. Copyright (C) 1996-1998, 2000 Swarm Development Group.
// This library is distributed without any warranty; without even the
// implied warranty of merchantability or fitness for a particular purpose.
// See file LICENSE for details and terms of copying.

#import <awtobjc/CompleteProbeDisplayLabel.h>

@implementation CompleteProbeDisplayLabel

- setProbedObject: theProbedObject
{
  probedObject = theProbedObject;
  return self;
}

- setProbeDisplay: theProbeDisplay
{
  probeDisplay = theProbeDisplay;
  return self;
}

- setProbeDisplayManager: theProbeDisplayManager
{
  probeDisplayManager = theProbeDisplayManager;
  return self;
}

- createEnd
{
  [super createEnd];
  
  printf ("CompleteProbeDisplayLabel\n");

  return self;
}

@end

