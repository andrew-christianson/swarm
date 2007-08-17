//
//  SwarmOSX_testActivity.h
//  SwarmOSX
//
//  Created by Nima Talebi on 6/08/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>


//. ForEach
#import <simtools.h>
#import <tactivity.h>
#import "Responder.h"

#import "ActionGroup_test.h"
#import "ConcurrentGroup_test.h"

#import "ActionGroup.h"

@interface SwarmOSX_testActivity : SenTestCase {
	int argc;
  const char* argv[0];
}
- (void) test_ForEach;
- (void) test_ActivityGroup;

@end
