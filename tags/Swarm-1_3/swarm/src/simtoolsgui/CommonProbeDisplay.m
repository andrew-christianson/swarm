// Swarm library. Copyright (C) 1996-1998 Santa Fe Institute.
// This library is distributed without any warranty; without even the
// implied warranty of merchantability or fitness for a particular purpose.
// See file LICENSE for details and terms of copying.

#import <simtoolsgui/CommonProbeDisplay.h>
#import <simtoolsgui/global.h> // probeDisplayManager
#import <gui.h>

@implementation CommonProbeDisplay

PHASE(Creating)

- setWindowGeometryRecordName: (const char *)theName
{
  windowGeometryRecordName = theName;
  return self;
}

- createEnd
{
  id <Frame> c_Frame;
  
  topLevel = [Frame createBegin: [self getZone]];
  [topLevel setWindowGeometryRecordName: windowGeometryRecordName];
  topLevel = [topLevel createEnd];
  [topLevel enableDestroyNotification: self
            notificationMethod: @selector (markForDrop)];
  [topLevel withdraw];
  c_Frame =  [Frame createParent: topLevel]; 

  canvas = [ProbeCanvas createBegin: [self getZone]];
  [canvas setParent: c_Frame];
  [canvas setHorizontalScrollbarFlag: horizontalScrollbarFlag];
  canvas = [canvas createEnd];
  
  [c_Frame pack];

  topFrame =  [Frame createParent: canvas];
  [topFrame setBorderWidth: 0];
  [topFrame assertPosition];

  markedForDropFlag = NO;
  return self;
}

PHASE(Using)

- (void)markForDrop
{
  [topLevel disableDestroyNotification];
  if ([probeDisplayManager getDropImmediatelyFlag])
    [self drop];
  else
    markedForDropFlag = YES;
}

- (BOOL)getMarkedForDropFlag
{
  return markedForDropFlag;
}

- install
{
  [topLevel deiconify];
  [topFrame assertGeometry];

  [probeDisplayManager addProbeDisplay: self];

  return self;
}

- (void)drop
{
  [topFrame drop];
  [canvas drop];
  [topLevel drop];
  [super drop];
}

@end