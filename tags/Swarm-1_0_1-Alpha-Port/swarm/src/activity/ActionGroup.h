// Swarm library. Copyright (C) 1996-1997 Santa Fe Institute.
// This library is distributed without any warranty; without even the
// implied warranty of merchantability or fitness for a particular purpose.
// See file LICENSE for details and terms of copying.

/*
Name:         ActionGroup.h
Description:  collection of actions under partial order constraints
Library:      activity
*/

#import <collections/OrderedSet.h>
#import <activity/CompoundAction.h>
#import <activity/XActivity.h>

@interface ActionGroup_c : OrderedSet_c
{
@public
// variables for CompoundAction mixin inheritance (referenced by source inclusion)
  id  activityRefs;     // activities currently running this plan
}
/*** methods implemented in CompoundAction.m file ***/
- (void) setDefaultOrder: aSymbol;
- (void) setAutoDrop: (BOOL)autoDrop;
- getDefaultOrder;
- (BOOL) getAutoDrop;
- activate;
- activateIn: swarmContext;
- _activateIn_: swarmContext : activityClass : indexClass;
- (void) _performPlan_;
- _createActivity_: ownerActivity : activityClass : indexClass;
- (void) drop;
/*** methods in ActionGroup_c (inserted from .m file) ***/
- createEnd;
- _activateUnderSwarm_: activityClass : indexClass : swarmContext;
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
- (void) mapAllocations: (mapalloc_t)mapalloc;
@end

@interface ConcurrentGroup_c : ActionGroup_c
{
  CAction  *actionConcurrent;  // action that includes group in schedule
}
/*** methods in ConcurrentGroup_c (inserted from .m file) ***/
- createEnd;
- (void) _setActionConcurrent_: action;
- _getEmptyActionConcurrent_;
@end

@interface GroupActivity_c : Activity_c
/*** methods in GroupActivity_c (inserted from .m file) ***/
@end

@interface GroupIndex_c : ListIndex_mlinks
{
@public
  id <Activity>  activity;               // activity for which index created
}
/*** methods implemented in CompoundAction.m file ***/
- getHoldType;
/*** methods in GroupIndex_c (inserted from .m file) ***/
- nextAction: (id *)status;
- (void) dropAllocations: (BOOL)componentAlloc;
@end

@interface ForEachActivity_c : Activity_c
/*** methods in ForEachActivity_c (inserted from .m file) ***/
+ _create_: forEachAction : anActivity;
- getCurrentMember;
@end

@interface ForEachIndex_c : Object_s
{
@public
  id <Activity>    activity;       // activity for which index created
  id <Index>       memberIndex;    // index into target collection
  ActionForEach_0  *memberAction;  // local copy of original ForEach action
}
/*** methods in ForEachIndex_c (inserted from .m file) ***/
- nextAction: (id *)status;
- get;
- getLoc;
- getHoldType;
- (void) mapAllocations: (mapalloc_t)mapalloc;
@end