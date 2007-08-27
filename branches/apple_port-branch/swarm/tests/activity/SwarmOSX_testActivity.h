//
//  SwarmOSX_testActivity.h
//  SwarmOSX
//
//  Created by Nima Talebi on 6/08/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

#import <simtools.h>
#import <tactivity.h>
#import "Responder.h"

#import "ActionGroup_test.h"
#import "ConcurrentGroup_test.h"

#import "ActionGroup.h"

#import "DSSwarm.h"
#import "DSRSwarm.h"

//#import "ESSwarm.h"

@interface SwarmOSX_testActivity : SenTestCase {
	int argc;
  char *argv[2];
	BOOL ok;
}

- (void) test_ForEach;
- (void) test_ForEachRandomized;
- (void) test_ActionGroup;
- (void) test_ActionGroupRandomized;
- (void) test_ConcurrentGroup;
- (void) test_ConcurrentGroupRandomized;
- (void) test_DynamicSchedule;
- (void) test_DynamicScheduleRepeat;
- (void) test_Schedule;
//- (void) test_ScheduleEmpty;

@end
