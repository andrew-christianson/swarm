// Swarm library. Copyright (C) 1996-1997 Santa Fe Institute.
// This library is distributed without any warranty; without even the
// implied warranty of merchantability or fitness for a particular purpose.
// See file LICENSE for details and terms of copying.

#import <string.h>

#import <simtools/SimpleProbeDisplay.h>
#import <objectbase.h>
#import <simtools/VarProbeWidget.h>
#import <simtools/MessageProbeWidget.h>
#import <simtools/global.h>

#import <tkobjc/control.h>

@implementation SimpleProbeDisplay

- setProbeMap: theProbeMap
{
  probeMap = theProbeMap;
  return self;
}

- getProbeMap
{  
  return probeMap;
}

// finalize creation: create widgets, set them up.
- createEnd
{
  int i;
  id index;
  id probe;
  id hideB;
  id top_top_Frame, raisedFrame;

  numberOfProbes = [probeMap getNumEntries];

  [super createEnd];

  top_top_Frame =  [Frame createParent: topFrame];  

  raisedFrame =  [Frame createParent: top_top_Frame];  
  setRelief (raisedFrame);

  myTitle = [Label createParent: raisedFrame];
  [myTitle setText: getId (probedObject)];
  
  setAnchorWest (myTitle);
  setColorBlue (myTitle);

  dragAndDrop (myTitle, self);

  configureButton3ForCompleteProbeDisplay (myTitle, probedObject, 
					   probeDisplayManager);
  configureWindowEntry (myTitle);
  configureWindowExit (myTitle);
  
  [myTitle pack];
  
  hideB = [Button createParent: top_top_Frame];

  configureHideButton (self, hideB, raisedFrame);

  middleFrame =  [Frame  createParent: topFrame] ;  
  leftFrame =  [Frame createParent: middleFrame];
  rightFrame = [Frame createParent: middleFrame];
  bottomFrame = [Frame createParent: topFrame];

  if (numberOfProbes > 0)
    widgets = (id *)
      [[self getZone] alloc: sizeof(id) * numberOfProbes];
  else
    widgets = 0;

  index = [probeMap begin: globalZone] ;

  i = 0 ;
  while ((probe = [index next]) != nil)
    {      
      if ([probe isKindOf: [VarProbe class]])
        {
          widgets[i] =	
            [[VarProbeWidget createBegin: [self getZone]]
              setParent: topFrame];
          [widgets[i]  setProbe: probe] ;
          [widgets[i] setObject: probedObject] ;
          [widgets[i]  setMyLeft:  leftFrame] ;
          [widgets[i]  setMyRight: rightFrame] ;
          widgets[i] = [widgets[i] createEnd] ;
          [widgets[i] pack];
          i++ ;
      }
    }
  
  [index drop];

  index = [probeMap begin: globalZone] ;

  // When I figure out how to 'rewind' I'll do just that...
  while ((probe = [index next]) != nil)
    {
      if ([probe isKindOf: [MessageProbe class]])
        {
          widgets[i] =	
            [[MessageProbeWidget createBegin: [self getZone]] 
              setParent: bottomFrame] ;
          [widgets[i]  setProbe: probe] ;
          [widgets[i] setObject: probedObject] ;
          widgets[i] = [widgets[i] createEnd] ;
          [widgets[i] pack] ;
          i++ ;
        }
    }
  
  [index drop];

  // This label is not being garbage collected!!!!!
  if (!i)
    {
      index = [Label createParent: topFrame] ;
      [index setText: "No Instance Variables or Messages."] ;
      [index pack] ;
    }

  packFill (top_top_Frame);
  packFillLeft (leftFrame, 0);
  packFillLeft (rightFrame, 1);

  [middleFrame pack];
  [bottomFrame pack];

  [self install];
  return self;
}

- update
{
  int i ;

  for (i = 0; i < numberOfProbes; i++)
    [widgets[i] update] ;
  
  return self;
}

- (void)drop
{
  int i ;

  [leftFrame drop] ;
  [rightFrame drop] ;
  [middleFrame drop] ;
  [bottomFrame drop] ;

  for(i = 0 ; i < numberOfProbes ; i++)
    [widgets[i] drop] ;

  if(numberOfProbes)
    [[self getZone] free: widgets] ;

  [topLevel drop] ;

  [probeDisplayManager removeProbeDisplay: self];

  if (removeRef)
    [probedObject removeRef: objectRef];
  
  [super drop] ;
}

- (const char *)package
{
  return packageName (probedObject);
}

- (const char *)getId
{
  return getId (probedObject);
}

@end
