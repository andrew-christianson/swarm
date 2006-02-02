//
//  SwarmTests.m
//  SwarmOSX
//
//  Created by Scott Christley on 1/20/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <SwarmOSX/simtools.h>     // initSwarm () and swarmGUIMode
#import <objectbase/Swarm.h>

extern int test_archiving();
extern int test_forwarding();

int main(int argc, const char *argv[])
{
	NSAutoreleasePool *pool = [NSAutoreleasePool new];

	// Swarm initialization: all Swarm apps must call this first.
	initSwarm (argc, argv);

	// run tests
	test_archiving();
	
	test_forwarding();
	
	[pool release];

	return 0;
}
