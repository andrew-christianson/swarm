// Swarm library. Copyright � 1996-2000 Swarm Development Group.
// This library is distributed without any warranty; without even the
// implied warranty of merchantability or fitness for a particular purpose.
// See file LICENSE for details and terms of copying.

#import <objectbase/DefaultProbeMap.h>
#import <collections.h>
#import <objc/objc-api.h>
#import <defobj.h> // Warning
#import <defobj/defalloc.h> // getZone
#include <swarmconfig.h>
#ifdef HAVE_JDK
#import "../defobj/java.h" // SD_JAVA_FIND_OBJECT_JAVA
#endif

#import "local.h"

@implementation DefaultProbeMap
PHASE(Creating)
- createEnd
{
  if (SAFEPROBES)
    if (probedClass == 0)
      {
        raiseEvent (WarningMessage,
                    "DefaultProbeMap object was not properly initialized\n");
        return nil;
      }
  
  probes = [Map createBegin: getZone (self)];
  [probes setCompareFunction: &p_compare];
  probes = [probes createEnd];
	
  if (probes == nil)
    return nil;
#ifdef HAVE_JDK
  if ([probedClass respondsTo: M(isJavaProxy)])
    { 
      classObject = SD_JAVA_FIND_OBJECT_JAVA (probedClass);
      if (!classObject)
	raiseEvent (SourceMessage,
		    "Java class to be probed can not be found!\n");      
      
      [self addJavaFields: classObject];
      return self;
    }
#endif
  [self addObjcFields: probedClass];
  return self;
}
PHASE(Using)
@end

