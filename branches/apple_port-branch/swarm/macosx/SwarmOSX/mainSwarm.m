//
//  mainSwarm.m
//  SwarmOSX
//
//  Created by Scott Christley on Sun Apr 28 2002.
//  Copyright (c) 2001 __MyCompanyName__. All rights reserved.
//

#import <simtools.h>

void mainSwarm(int argc, const char *argv[])
{
  id theTopLevelSwarm;

  // Swarm initialization: all Swarm apps must call this first.
  initSwarm (argc, argv);
  
  return;
}

#if 0
@implementation Object (SwarmAdditions)

+ self
{
    return self;
}
    
@end
#endif