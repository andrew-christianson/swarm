//
//  SwarmOSX_testActivity.m
//  SwarmOSX
//
//  Created by Nima Talebi on 6/08/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "SwarmOSX_testActivity.h"


@implementation SwarmOSX_testActivity

- (void) setUp {
	argc = 1;
  argv[0] = "./swarm";
	argv[1] = "";
	ok = YES;
	
	//. FIXME
	STFail(@"FIXME: `initSwarmBatch(argc, argv);'"); //initSwarmBatch(argc, argv);
}



- (void) test_ForEach {
	id actionGroupTest;
	id obj;
	id collection;
	int i;

	//. FIXME
	STFail(@"FIXME: `initModule(tactivity);'"); //initModule(tactivity);
	STFail(@"FIXME: `init_tables();'"); //init_tables();

	actionGroupTest = [ActionGroup_test createBegin: globalZone numberOfObjects: 6];
	for(i=0; i<5; i++)	{
		obj = [Responder create:globalZone];
		[actionGroupTest addObject: obj];
	}
	collection = [List createBegin:globalZone];
	collection = [collection createEnd];
	
	for(i=1; i<=5; i++) {
		//. FIXME
		STFail(@"FIXME: `[collection addLast: [Responder create: globalZone withId: i]];'");
		//[collection addLast: [Responder create: globalZone withId: i]];
	}
	
	[actionGroupTest addObject: collection];
	[actionGroupTest setDefaultOrder: Sequential];
	actionGroupTest = [actionGroupTest createEnd];
		
	[actionGroupTest createActionTo: [actionGroupTest getObjectAt: 0] message: M(m1)];
	[actionGroupTest createActionTo: [actionGroupTest getObjectAt: 1] message: M(m2)];
	[actionGroupTest createActionTo: [actionGroupTest getObjectAt: 2] message: M(m3)];	
	[actionGroupTest createActionTo: [actionGroupTest getObjectAt: 3] message: M(m4)];	
	[actionGroupTest createActionTo: [actionGroupTest getObjectAt: 4] message: M(m5)];	
	[actionGroupTest createActionForEach: [actionGroupTest getObjectAt: 5] message: M(mId)];  
	
	[[actionGroupTest activateIn: nil] run];
	 
	for(i=0; i<5; i++) {
		//. XXX: Why is it `i+1' (should be `i')?...
		if(!messages[i]) { STFail(@"Error in ActionGroupRandomized method m%d not called!", i+1); }
		if(!ids[i]) { STFail(@"Error in ForEachAction message not sent to member of "
												  "collection at index %d!", i); }
		if(ids[i] != i + 1) ok=NO;
	}
	STAssertTrue(ok, @"Error ForEachAction should not be randomized!");
}



- (void) test_ForEachRandomized {
	id actionGroupTest;
  id obj;
  id collection;
  int i;
  id forEachAction;
  
	//. FIXME
	STFail(@"FIXME: `initModule(tactivity);'"); //initModule(tactivity);
	STFail(@"FIXME: `init_tables();'"); //init_tables();
	
  actionGroupTest = [ActionGroup_test createBegin:globalZone numberOfObjects: 6];
  for (i=0; i<5; i++) {
		obj = [Responder create:globalZone];
		[actionGroupTest addObject: obj];
	}
  collection = [List createBegin: globalZone];
  collection = [collection createEnd];
  for (i=1; i<=5; i++) {
		//[collection addLast: [Responder create: globalZone withId: i]];
		STFail(@"FIXME: `[collection addLast: [Responder create: globalZone withId: i]];'");
	}
  
	[actionGroupTest addObject: collection];
  
  [actionGroupTest setDefaultOrder: Sequential];
  actionGroupTest = [actionGroupTest createEnd];
  
	[actionGroupTest createActionTo: [actionGroupTest getObjectAt: 0] message: M(m1)];
  [actionGroupTest createActionTo: [actionGroupTest getObjectAt: 1] message: M(m2)];
  [actionGroupTest createActionTo: [actionGroupTest getObjectAt: 2] message: M(m3)];	
  [actionGroupTest createActionTo: [actionGroupTest getObjectAt: 3] message: M(m4)];
  [actionGroupTest createActionTo: [actionGroupTest getObjectAt: 4] message: M(m5)];
  forEachAction = [actionGroupTest createActionForEach:[actionGroupTest getObjectAt:5]
																							 message: M(mId)];  
  [forEachAction setDefaultOrder: Randomized];
  
  [[actionGroupTest activateIn: nil] run];
  
	//. XXX: This logic is broken...
  ok=NO;
  for(i=0; i<5; i++) {
		if(!messages[i]) { STFail(@"Error in ActionGroup method m%d not called!", i+1); }
		if (!ids[i]) { STFail(@"Error in ForEachAction message not sent to member of "
													 "collection at index %d!", i); }
		if (ids[i] != i+1) ok=YES;
	}
  STAssertTrue(ok, @"Error ForEachAction should be randomized!");	
}



- (void) test_ActionGroup {
	id actionGroupTest;
	id obj;
	int i;

	//. FIXME
	STFail(@"FIXME: `initModule(tactivity);'"); //initModule(tactivity);
	STFail(@"FIXME: `init_tables();'"); //init_tables();
	
	actionGroupTest = [ActionGroup_test createBegin:globalZone numberOfObjects:5];
	for(i=0; i<5; i++) {
		obj = [Responder create:globalZone];
		[actionGroupTest addObject: obj];
	}
	[actionGroupTest setDefaultOrder: Sequential];
	actionGroupTest = [actionGroupTest createEnd];
		
	[actionGroupTest createActionTo: [actionGroupTest getObjectAt: 0] message: M(m1)];
	[actionGroupTest createActionTo: [actionGroupTest getObjectAt: 1] message: M(m2)];
	[actionGroupTest createActionTo: [actionGroupTest getObjectAt: 2] message: M(m3)];	
	[actionGroupTest createActionTo: [actionGroupTest getObjectAt: 3] message: M(m4)]; 
	[actionGroupTest createActionTo: [actionGroupTest getObjectAt: 4] message: M(m5)];
	[[actionGroupTest activateIn: nil] run];
	
	for (i=0; i<5; i++) {
		if (!messages[i]) { STFail(@"Error in ActionGroup method m%d not called!", i+1); }
		if (messages[i] != i + 1) ok=NO;
	}
		
	STAssertTrue(ok, @"Error ActionGroup should not be randomized!");
}



- (void) test_ActionGroupRandomized {
	id actionGroupTest;
  id obj;
  int i;
	
	//. FIXME
	STFail(@"FIXME: `initModule(tactivity);'"); //initModule(tactivity);
	STFail(@"FIXME: `init_tables();'"); //init_tables();
	
  actionGroupTest = [ActionGroup_test createBegin: globalZone numberOfObjects: 5];
  for (i=0; i<5; i++) {
		obj = [Responder create:globalZone];
		[actionGroupTest addObject: obj];
	}
	
  [actionGroupTest setDefaultOrder: Randomized];
  actionGroupTest = [actionGroupTest createEnd];
  
	[actionGroupTest createActionTo: [actionGroupTest getObjectAt: 0] message: M(m1)];
  [actionGroupTest createActionTo: [actionGroupTest getObjectAt: 1] message: M(m2)];
  [actionGroupTest createActionTo: [actionGroupTest getObjectAt: 2] message: M(m3)];	
  [actionGroupTest createActionTo: [actionGroupTest getObjectAt: 3] message: M(m4)]; 
  [actionGroupTest createActionTo: [actionGroupTest getObjectAt: 4] message: M(m5)]; 
  
  [[actionGroupTest activateIn: nil] run];
  
	//. XXX: This logic is broken...
  ok=NO;
  for (i=0; i<5; i++) {
		if(!messages[i]) { STFail(@"Error in ActionGroupRandomized method m%d not called!", i+1); }
		if(messages[i] != i+1) ok=YES;
	}
  
  STAssertTrue(ok, @"Error ActionGroupRandomized should be randomized!");
}



- (void) test_ConcurrentGroup {
  id concGroupTest;
  id obj;
  int i;
	
	//. FIXME
	STFail(@"FIXME: `initModule(tactivity);'"); //initModule(tactivity);
	STFail(@"FIXME: `init_tables();'"); //init_tables();
	
  concGroupTest = [ConcurrentGroup_test createBegin: globalZone numberOfObjects: 5];
  for (i=0; i<5; i++)	{
		obj = [Responder create:globalZone];
		[concGroupTest addObject: obj];
	}
  [concGroupTest setDefaultOrder: Sequential];
  concGroupTest = [concGroupTest createEnd];

  [concGroupTest createActionTo: [concGroupTest getObjectAt: 0] message: M(m1)];
  [concGroupTest createActionTo: [concGroupTest getObjectAt: 1] message: M(m2)];
  [concGroupTest createActionTo: [concGroupTest getObjectAt: 2] message: M(m3)];	
  [concGroupTest createActionTo: [concGroupTest getObjectAt: 3] message: M(m4)]; 
  [concGroupTest createActionTo: [concGroupTest getObjectAt: 4] message: M(m5)]; 
  [[concGroupTest activateIn: nil] run];
	
  for (i=0; i<5; i++) {
		if(!messages[i]) { STFail(@"Error in ConcurrentGroup method m%d not called!", i+1); }
		if(messages[i] != i + 1) ok=NO;
	}
  
	STAssertTrue(ok, @"Error ConcurrentGroup should not be randomized!");
}



- (void) test_ConcurrentGroupRandomized {
	id concGroupTest;
  id obj;
  int i;
  
	//. FIXME
	STFail(@"FIXME: `initModule(tactivity);'"); //initModule(tactivity);
	STFail(@"FIXME: `init_tables();'"); //init_tables();
  
  concGroupTest = [ConcurrentGroup_test createBegin:globalZone numberOfObjects:5];
  for(i=0; i<5; i++) {
		obj = [Responder create:globalZone];
		[concGroupTest addObject: obj];
	}
	
  [concGroupTest setDefaultOrder: Randomized];
  concGroupTest = [concGroupTest createEnd];
  
  [concGroupTest createActionTo: [concGroupTest getObjectAt: 0] message: M(m1)];
  [concGroupTest createActionTo: [concGroupTest getObjectAt: 1] message: M(m2)];
  [concGroupTest createActionTo: [concGroupTest getObjectAt: 2] message: M(m3)];	
  [concGroupTest createActionTo: [concGroupTest getObjectAt: 3] message: M(m4)]; 
  [concGroupTest createActionTo: [concGroupTest getObjectAt: 3] message: M(m5)]; 
  [[concGroupTest activateIn: nil] run];
  
	//. XXX: This logic is broken...
  ok=NO;
  for(i=0; i<5; i++) {
		if(!messages[i]) { STFail(@"Error in ActionGroupRandomized method m%d not called!", i+1); }
		if(messages[i] != i+1) ok=YES;
	}
  
  STAssertTrue(ok, @"Error ActionGroupRandomized should be randomized!");
}



- (void) test_DynamicSchedule {
	id theSwarm;
	
	//. FIXME
	STFail(@"FIXME: `theSwarm = [DSSwarm create:globalZone];'"); //theSwarm = [DSSwarm create:globalZone];
	STFail(@"FIXME: `[theSwarm buildActions];'"); //[theSwarm buildActions];
	STFail(@"FIXME: `[theSwarm activateIn: nil];'"); //[theSwarm activateIn:nil];
	STFail(@"FIXME: `[[theSwarm getActivity] run];'"); //[[theSwarm getActivity] run];
	
	ok=NO;
	STAssertTrue(ok, @"Error in Schedule, dynamic update failed, action added "
	                  "after the current time, but before first pending action "
										"in the Schedule not performed!");
}



- (void) test_DynamicScheduleRepeat {
	id theSwarm;
  
	//. FIXME
	STFail(@"FIXME: `theSwarm = [DSRSwarm create:globalZone];'"); //theSwarm = [DSRSwarm create:globalZone];
	STFail(@"FIXME: `[theSwarm buildActions];'"); //[theSwarm buildActions];
	STFail(@"FIXME: `[theSwarm activateIn: nil];'"); //[theSwarm activateIn:nil];
	STFail(@"FIXME: `[[theSwarm getActivity] run];'"); //[[theSwarm getActivity] run];
  
  if(stimes[0] != 1) STFail(@"Error dynamic update failed, action added after "
														 "current time but before first action in the schedule "
														 "never was performed!");

  if(stimes[1] != 11) STFail(@"Error dynamic update failed, action added in previous "
														  "repeat cycle never performed!");
	
  if(stimes[2] != 15) STFail(@"Error dynamic update failed, action added in previous "
														  "repeat cycle before current time, never performed in "
														  "last repeat cycle!");

  if(stimes[3] != 21) STFail(@"Error dynamic update failed, action added two repeat "
														  "cycles ago, that was performed in previous cycle never "
														  "performed in last repeat cycle!");

  if (stimes[4] != 25) STFail(@"Error dynamic update failed, action added before current "
															 "time two repeat cycles ago, that was performed in "
															 "previous cycle never performed in last repeat cycle");
}



- (void) test_Schedule {
	id array;
  id obj;
  int i;
  id schedule;
  
	//. FIXME
	STFail(@"FIXME: `init_tables();'"); //init_tables();

  array = [Array create: globalZone setCount: 5];
  for (i=0; i<5; i++) {
		obj = [Responder create:globalZone];
		[obj setId: i + 1];
		[array atOffset: i put: obj];
	}
	
  schedule = [Schedule createBegin: globalZone];
  [schedule setAutoDrop: YES];
  schedule = [schedule createEnd];
  
  [schedule at: 0 createActionTo: [array atOffset: 0] message: M(mTimeId)];
  [schedule at: 1 createActionTo: [array atOffset: 0] message: M(mTimeId)];
  [schedule at: 1 createActionTo: [array atOffset: 1] message: M(mTimeId)];
  [schedule at: 10 createActionTo: [array atOffset: 2] message: M(mTimeId)];	
  [schedule at: 10 createActionTo: [array atOffset: 3] message: M(mTimeId)]; 
  [schedule at: 100 createActionTo: [array atOffset: 4] message: M(mTimeId)];
  [schedule at: 100 createActionTo: [array atOffset: 4] message: M(mTimeId)];
  [[schedule activateIn: nil] run];
  
  if(ids[0] != 1)
		STFail(@"Error in Schedule, action scheduled for time: 0 not performed!");
	
	if (ids[1] != 1 || ids[2] != 2 || rtimes[1] != 1 || rtimes[2] != 1)
		STFail(@"Error in Schedule, two concurrent actions scheduled for time: 1 not performed!");
  
	if (ids[3] != 3 || ids[4] != 4 || rtimes[3] != 10 || rtimes[4] != 10)
		STFail(@"Error in Schedule, two concurrent actions scheduled for time: 10 not performed!");
  
	if (ids[5] != 5 || ids[6] != 5 || rtimes[5] != 100 || rtimes[6] != 100)
		STFail(@"Error in Schedule, two concurrent actions scheduled for time: 100 not performed!");
}


/*
- (void) test_ScheduleEmpty {
	id theSwarm;

	//. FIXME
  //theSwarm = [ESSwarm create: globalZone];
  //[theSwarm buildActions];
  //[theSwarm activateIn: nil];
  //[[theSwarm getActivity] run];
  
	ok=NO;
	STAssertTrue(ok, @"Error in Schedule, action added to an empty schedule never "
							      "performed, although setKeepEmpty was set to YES!");
}
*/

@end
