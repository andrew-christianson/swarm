// Swarm library. Copyright � 1996-2000 Swarm Development Group.
// This library is distributed without any warranty; without even the
// implied warranty of merchantability or fitness for a particular purpose.
// See file LICENSE for details and terms of copying.

// List of display probes that are in the system, used to update
// them in the schedule.

#import <simtoolsgui.h> // ProbeDisplayManager
#import <objectbase/SwarmObject.h>

@interface ProbeDisplayManager: SwarmObject <ProbeDisplayManager>
{
  id probeList;
  BOOL dropImmediatelyFlag;
}

- (void)setDropImmediatelyFlag: (BOOL)dropImmediatelyFlag;
- (BOOL)getDropImmediatelyFlag;

- createEnd;

- createProbeDisplayFor                 : anObject;
- createArchivedProbeDisplayFor         : anObject
                            variableName: (const char *)variableName;
- createDefaultProbeDisplayFor          : anObject;
- createArchivedDefaultProbeDisplayFor  : anObject
                            variableName: (const char *)variableName;
- createCompleteProbeDisplayFor         : anObject;
- createArchivedCompleteProbeDisplayFor : anObject
                            variableName: (const char *)variableName;

- addProbeDisplay: probeDisplay;
- dropProbeDisplaysFor: anObject;
- removeProbeDisplay: probeDisplay;
- update;
@end