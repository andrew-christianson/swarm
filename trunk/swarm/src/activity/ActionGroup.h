// Swarm library. Copyright � 1996-1999 Santa Fe Institute.
// This library is distributed without any warranty; without even the
// implied warranty of merchantability or fitness for a particular purpose.
// See file LICENSE for details and terms of copying.

/*
Name:         ActionGroup.h
Description:  collection of actions under partial order constraints
Library:      activity
*/

#import <collections/OrderedSet.h>
#import <collections/Permutation.h>
#import <activity/CompoundAction.h>
#import <activity/XActivity.h>
#import <defobj/Zone.h>

@interface ActionGroup_c: OrderedSet_c <ActionGroup>
{
@public
   // variables for CompoundAction mixin inheritance
   // (referenced by source inclusion)
  id activityRefs; // activities currently running this plan
}
/*** methods implemented in CompoundAction.m file ***/
- (void)setAutoDrop: (BOOL)autoDrop;
- (BOOL)getAutoDrop;
- (void)setDefaultOrder: aSymbol;
- getDefaultOrder;
- activate;
- activateIn: swarmContext;
- _activateIn_: swarmContext : (Class)activityClass : (Class)indexClass: (Zone_c *)aZone;
- (void)_performPlan_;
- _createActivity_: (Activity_c *)ownerActivity : (Class)activityClass : (Class)indexClass : (Zone_c *)aZone;
- (void)drop;
- _createPermutedIndex_: aZone activity: activity;
/*** methods in ActionGroup_c (inserted from .m file by m2h) ***/
- createEnd;
- _activateUnderSwarm_: (Class)activityClass : (Class)indexClass : swarmContext: (Zone_c *)swarmZone;
- createFAction: call;
- createAction: anActionType;
- createActionCall: (func_t)fptr;
- createActionCall: (func_t)fptr : arg1;
- createActionCall: (func_t)fptr : arg1 : arg2;
- createActionCall: (func_t)fptr : arg1 : arg2 : arg3;
- createActionTo: target message: (SEL)aSel;
- createActionTo: target message: (SEL)aSel : arg1;
- createActionTo: target message: (SEL)aSel : arg1 : arg2;
- createActionTo: target message: (SEL)aSel : arg1 : arg2 : arg3;
- createActionForEach: target message: (SEL)aSel;
- createActionForEach: target message: (SEL)aSel : arg1;
- createActionForEach: target message: (SEL)aSel : arg1 : arg2;
- createActionForEach: target message: (SEL)aSel : arg1 : arg2 : arg3;
- (void)mapAllocations: (mapalloc_t)mapalloc;
- (void)describe: outputCharStream;
- (void)describeForEach: outputCharStream;
@end

@interface ConcurrentGroup_c: ActionGroup_c <ConcurrentGroup>
{
  CAction *actionConcurrent;  // action that includes group in schedule
}
/*** methods in ConcurrentGroup_c (inserted from .m file by m2h) ***/
- createEnd;
- (void)_setActionConcurrent_: action;
- _getEmptyActionConcurrent_;
- (void)mapAllocations: (mapalloc_t)mapalloc;
@end

@interface GroupActivity_c: Activity_c
/*** methods in GroupActivity_c (inserted from .m file by m2h) ***/
@end

@interface GroupIndex_c: ListIndex_mlinks
{
@public
  id <Activity> activity;               // activity for which index created
}
- setActivity: (id <Activity>)activity;
/*** methods implemented in CompoundAction.m file ***/
- getHoldType;
/*** methods in GroupIndex_c (inserted from .m file by m2h) ***/
- nextAction: (id *)status;
- (void)dropAllocations: (BOOL)componentAlloc;
@end

@interface GroupPermutedIndex_c: PermutedIndex_c
{
@public
  id <Activity> activity;
}
- setActivity: activity;
- getHoldType;
- nextAction: (id *)status;
- (void)dropAllocations: (BOOL)componentAlloc;

@end

@interface ForEachActivity_c: Activity_c <ForEachActivity>
/*** methods in ForEachActivity_c (inserted from .m file by m2h) ***/
+ _create_: forEachAction : anActivity;
+ _createRandom_: forEachAction: anActivity;
- getCurrentMember;
@end

@interface ForEachIndex_c: Object_s
{
@public
  id <Activity> activity;        // activity for which index created
  id <Index> memberIndex;        // index into target collection
  ActionForEach_c *memberAction; // local copy of original ForEach action
}
/*** methods in ForEachIndex_c (inserted from .m file by m2h) ***/
- nextAction: (id *)status;
- get;
- getLoc;
- getHoldType;
- (void)mapAllocations: (mapalloc_t)mapalloc;
@end