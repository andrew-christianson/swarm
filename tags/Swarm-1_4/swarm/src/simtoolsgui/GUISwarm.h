// Swarm library. Copyright (C) 1996-1998 Santa Fe Institute.
// This library is distributed without any warranty; without even the
// implied warranty of merchantability or fitness for a particular purpose.
// See file LICENSE for details and terms of copying.

#import <simtools.h>
#import <objectbase/Swarm.h>

// a GUISwarm is a Swarm with some support for graphical interface. In
// particular, it creates a control panel for you and also provides a
// "go" method that handles the user hitting buttons like "stop" and
// "step". When using this, you still need to be sure to schedule
// calls to the controlPanels' doTkEvents method.

@interface GUISwarm : Swarm
{
  id controlPanel;
  id actionCache;
  const char *baseWindowGeometryRecordName;
}

- setWindowGeometryRecordName: (const char *)windowGeometryRecordName;
- setWindowGeometryRecordNameForComponent: (const char *)componentName
                                   widget: aWidget;
- buildObjects;
- go;				   // returns Completed or ControlStateQuit
- (void)drop;
@end