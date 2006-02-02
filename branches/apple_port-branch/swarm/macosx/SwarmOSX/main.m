//
//  main.m
//  SwarmOSX
//
//  Created by Scott Christley on Sun Apr 21 2002.
//  Copyright (c) 2001 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <SwarmOSX/simtools.h>     // initSwarm () and swarmGUIMode
//#import <SwarmOSX/simtoolsgui.h>  // GUISwarm
//#import "HeatbugObserverSwarm.h"
#import "HeatbugBatchSwarm.h"

extern void mainSwarm(int argc, const char *argv[]);

extern int test_forwarding();

int main(int argc, const char *argv[])
{
  //mainSwarm(argc, argv);

  id theTopLevelSwarm;

  NSAutoreleasePool *pool = [NSAutoreleasePool new];

  // Swarm initialization: all Swarm apps must call this first.
  initSwarm (argc, argv);

//    test_forwarding();
//    return 0;
    
  // swarmGUIMode is set in initSwarm(). It's set to be NO if you typed
  // `heatbugs --batchmode' or `heatbugs -b'. Otherwise, it's set to YES.
//  if (swarmGUIMode == YES)
//    {
      // We've got graphics, so make a full ObserverSwarm to get GUI objects
//      theTopLevelSwarm = [HeatbugObserverSwarm createBegin: globalZone];
//      SET_WINDOW_GEOMETRY_RECORD_NAME (theTopLevelSwarm);
//      theTopLevelSwarm = [theTopLevelSwarm createEnd];
//    }
//  else
    // No graphics - make a batchmode swarm (using the key
    // `batchSwarm' from the default lispAppArchiver) and run it.
//    if ((theTopLevelSwarm = [lispAppArchiver getWithZone: globalZone 
//                                             key: "batchSwarm"]) == nil) 
//      raiseEvent(InvalidOperation, 
//                 "Can't find the parameters to create batchSwarm");

  theTopLevelSwarm = [HeatbugBatchSwarm createBegin: globalZone];
  [theTopLevelSwarm createEnd];
  [theTopLevelSwarm buildObjects];
  [theTopLevelSwarm buildActions];
  [theTopLevelSwarm activateIn: nil];
  [theTopLevelSwarm go];

  // theTopLevelSwarm has finished processing, so it's time to quit.
  return 0;
    
    //return NSApplicationMain(argc, argv);
}
