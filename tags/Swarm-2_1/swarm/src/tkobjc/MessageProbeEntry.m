// Swarm library. Copyright � 1996-2000 Swarm Development Group.
// This library is distributed without any warranty; without even the
// implied warranty of merchantability or fitness for a particular purpose.
// See file LICENSE for details and terms of copying.

#import <tkobjc/MessageProbeEntry.h>

#import <tkobjc/common.h>
#import <tkobjc/global.h>

static void
tkobjc_bindButton3ToBeUnhelpfulAndRefocus (id widget, id self)
{
  const char *widgetName = [widget getWidgetName];
  [globalTkInterp
    eval:
      "bind %s <Button-3> {focus %s; %s configure -highlightcolor red ;"
    "update ; bell ; update ; %s configure -highlightcolor black ;"
    "update ; focus %s ; update} ;",
    widgetName, widgetName, widgetName, widgetName,
    [self getWidgetName]];
}

@implementation MessageProbeEntry

PHASE(Creating)

- setArg: (int)theArg
{
  arg = theArg;
  return self;
}

- setIdFlag: (BOOL)theIdFlag
{
  idFlag = theIdFlag;
  return self;
}

+ createBegin: aZone
{
  MessageProbeEntry *obj = [super createBegin: aZone];
  
  obj->arg = -1;
  obj->idFlag = NO;
  return obj;
}
  
- createEnd
{
  BOOL argFlag = arg != -1;

  [super createEnd];
  if (idFlag)
    {
      [self setActiveFlag: NO];
      if (argFlag)
        {
          tkobjc_bindButton3ToArgSpawn (self, parent, arg);
          tkobjc_dragAndDropArg (self, parent, arg);
        }
      else
        {
          tkobjc_bindButton3ToSpawn (self, parent, 1);
          tkobjc_dragAndDrop (self, parent);
        }
    }
  else
    tkobjc_bindButton3ToBeUnhelpfulAndRefocus (self, parent);
  
  [self packFillLeft: argFlag];

  return self;
}

PHASE(Using)

@end

