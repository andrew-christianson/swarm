// Swarm library. Copyright (C) 1996-1998 Santa Fe Institute.
// This library is distributed without any warranty; without even the
// implied warranty of merchantability or fitness for a particular purpose.
// See file LICENSE for details and terms of copying.

#import <objectbase/SwarmObject.h>
#import <collections.h>

@interface GUIComposite: SwarmObject
{
  const char *baseWindowGeometryRecordName;
  id <Map> componentList;
}

- setWindowGeometryRecordName: (const char *)windowGeometryRecordName;
- setWindowGeometryRecordNameForComponent: (const char *)componentName
                                   widget: widget;
- enableDestroyNotification: notificationTarget
         notificationMethod: (SEL)notificationMethod;
- disableDestroyNotification;
@end
