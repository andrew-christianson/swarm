// Swarm library. Copyright � 1996-1999 Santa Fe Institute.
// This library is distributed without any warranty; without even the
// implied warranty of merchantability or fitness for a particular purpose.
// See file LICENSE for details and terms of copying.

// place holder for a map of probes. This will be replaced with the
// generic Map class. Given a class, build an array of probe objects that
// work on that class (one per variable).

#import <objectbase/CustomProbeMap.h>

@interface EmptyProbeMap: CustomProbeMap <EmptyProbeMap>
{
}
+ create: aZone forClass: (Class)aClass;
@end

