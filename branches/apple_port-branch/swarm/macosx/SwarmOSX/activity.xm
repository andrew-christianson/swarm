#import <activity.h>
#import <objc/objc-api.h>

#if !SWARM_OSX /* TODO: GLOBALS */
externvardef id 
WarningMessage=0,
ResourceAvailability=0,
LibraryUsage=0,
DefaultAssumed=0,
ObsoleteFeature=0,
ObsoleteMessage=0;
externvardef id 
SourceMessage=0,
NotImplemented=0,
SubclassMustImplement=0,
InvalidCombination=0,
InvalidOperation=0,
InvalidArgument=0,
CreateSubclassing=0,
CreateUsage=0,
OutOfMemory=0,
InvalidAllocSize=0,
InternalError=0,
BlockedObjectAlloc=0,
BlockedObjectUsage=0,
ProtocolViolation=0,
LoadError=0,
SaveError=0;
externvardef id t_ByteArray=0,t_LeafObject=0,t_PopulationObject=0;
externvardef id ArchiverLiteral=0,ArchiverQuote=0,ArchiverEOL=0,ArchiverDot=0;
#endif

externvardef id Start=0,End=0,Between=0,Removed=0,Member=0;
externvardef id OffsetOutOfRange=0,NoMembers=0,
AlreadyAtEnd=0,AlreadyAtStart=0,InvalidIndexLoc=0,InvalidLocSymbol=0;
externvardef id Initialized=0,Running=0,Holding=0,Released=0,Stopped=0,
Terminated=0,Completed=0;
externvardef id Concurrent=0,Sequential=0,Randomized=0;
externvardef id HoldStart=0,HoldEnd=0;
externvardef id InvalidSwarmZone=0;

void *_activity_symbols[]={
&WarningMessage,
&ResourceAvailability,
&LibraryUsage,
&DefaultAssumed,
&ObsoleteFeature,
&ObsoleteMessage,
&SourceMessage,
&NotImplemented,
&SubclassMustImplement,
&InvalidCombination,
&InvalidOperation,
&InvalidArgument,
&CreateSubclassing,
&CreateUsage,
&OutOfMemory,
&InvalidAllocSize,
&InternalError,
&BlockedObjectAlloc,
&BlockedObjectUsage,
&ProtocolViolation,
&LoadError,
&SaveError,
&t_ByteArray,&t_LeafObject,&t_PopulationObject,
&Start,&End,&Between,&Removed,&Member,
&OffsetOutOfRange,&NoMembers,
&AlreadyAtEnd,&AlreadyAtStart,&InvalidIndexLoc,&InvalidLocSymbol,
&ArchiverLiteral,&ArchiverQuote,&ArchiverEOL,&ArchiverDot,
&Initialized,&Running,&Holding,&Released,&Stopped,
&Terminated,&Completed,
&Concurrent,&Sequential,&Randomized,
&HoldStart,&HoldEnd,
&InvalidSwarmZone,
0,
"0Warning",
"WarningMessage",
"ResourceAvailability",
"LibraryUsage",
"DefaultAssumed",
"ObsoleteFeature",
"ObsoleteMessage",
"0Error",
"SourceMessage",
"NotImplemented",
"SubclassMustImplement",
"InvalidCombination",
"InvalidOperation",
"InvalidArgument",
"CreateSubclassing",
"CreateUsage",
"OutOfMemory",
"InvalidAllocSize",
"InternalError",
"BlockedObjectAlloc",
"BlockedObjectUsage",
"ProtocolViolation",
"LoadError",
"SaveError",
"0Symbol","t_ByteArray","t_LeafObject","t_PopulationObject",
"0Symbol","Start","End","Between","Removed","Member",
"0Error","OffsetOutOfRange","NoMembers",
"AlreadyAtEnd","AlreadyAtStart","InvalidIndexLoc","InvalidLocSymbol",
"0Symbol","ArchiverLiteral","ArchiverQuote","ArchiverEOL","ArchiverDot",
"0Symbol","Initialized","Running","Holding","Released","Stopped",
"Terminated","Completed",
"0Symbol","Concurrent","Sequential","Randomized",
"0Symbol","HoldStart","HoldEnd",
"0Error","InvalidSwarmZone",
0};

externvardef id DefaultOrder=0;
externvardef id Activity=0;
externvardef id Action=0;
externvardef id ActionArgs=0;
externvardef id FAction=0;
externvardef id ActionTarget=0;
externvardef id ActionTo=0;
externvardef id ActionForEach=0;
externvardef id ActionForEachHomogeneous=0;
externvardef id FActionForEach=0;
externvardef id FActionForEachHeterogeneous=0;
externvardef id FActionForEachHomogeneous=0;
externvardef id ActionCall=0;
externvardef id ActionChanged=0;
externvardef id ActionConcurrent=0;
externvardef id FActionCreating=0;
externvardef id ActionCreatingCall=0;
externvardef id ActionCreatingTo=0;
externvardef id ActionCreatingForEach=0;
externvardef id FActionCreatingForEachHeterogeneous=0;
externvardef id FActionCreatingForEachHomogeneous=0;
externvardef id ActionCreating=0;
externvardef id ActivityIndex=0;
externvardef id ActionType=0;
externvardef id SynchronizationType=0;
externvardef id AutoDrop=0;
externvardef id CompoundAction=0;
externvardef id ActionGroup=0;
externvardef id RelativeTime=0;
externvardef id RepeatInterval=0;
externvardef id ConcurrentGroupType=0;
externvardef id SingletonGroups=0;
externvardef id Schedule=0;
externvardef id ScheduleActivity=0;
externvardef id SwarmActivity=0;
externvardef id ForEachActivity=0;
externvardef id SwarmProcess=0;
externvardef id GetSubactivityAction=0;
externvardef id ConcurrentGroup=0;
externvardef id ConcurrentSchedule=0;
externvardef id ActivationOrder=0;

void *_activity_types[]={
&DefaultOrder,
&Activity,
&Action,
&ActionArgs,
&FAction,
&ActionTarget,
&ActionTo,
&ActionForEach,
&FActionForEach,
&FActionForEachHeterogeneous,
&FActionForEachHomogeneous,
&ActionCall,
&ActionChanged,
&ActionConcurrent,
&FActionCreating,
&ActionCreatingCall,
&ActionCreatingTo,
&ActionCreatingForEach,
&FActionCreatingForEachHeterogeneous,
&FActionCreatingForEachHomogeneous,
&ActionCreating,
&ActivityIndex,
&ActionType,
&SynchronizationType,
&AutoDrop,
&CompoundAction,
&ActionGroup,
&RelativeTime,
&RepeatInterval,
&ConcurrentGroupType,
&SingletonGroups,
&Schedule,
&ScheduleActivity,
&SwarmActivity,
&ForEachActivity,
&SwarmProcess,
&GetSubactivityAction,
&ConcurrentGroup,
&ConcurrentSchedule,
&ActivationOrder,
0,
@protocol(DefaultOrder),
@protocol(Activity),
@protocol(Action),
@protocol(ActionArgs),
@protocol(FAction),
@protocol(ActionTarget),
@protocol(ActionTo),
@protocol(ActionForEach),
@protocol(FActionForEach),
@protocol(FActionForEachHeterogeneous),
@protocol(FActionForEachHomogeneous),
@protocol(ActionCall),
@protocol(ActionChanged),
@protocol(ActionConcurrent),
@protocol(FActionCreating),
@protocol(ActionCreatingCall),
@protocol(ActionCreatingTo),
@protocol(ActionCreatingForEach),
@protocol(FActionCreatingForEachHeterogeneous),
@protocol(FActionCreatingForEachHomogeneous),
@protocol(ActionCreating),
@protocol(ActivityIndex),
@protocol(ActionType),
@protocol(SynchronizationType),
@protocol(AutoDrop),
@protocol(CompoundAction),
@protocol(ActionGroup),
@protocol(RelativeTime),
@protocol(RepeatInterval),
@protocol(ConcurrentGroupType),
@protocol(SingletonGroups),
@protocol(Schedule),
@protocol(ScheduleActivity),
@protocol(SwarmActivity),
@protocol(ForEachActivity),
@protocol(SwarmProcess),
@protocol(GetSubactivityAction),
@protocol(ConcurrentGroup),
@protocol(ConcurrentSchedule),
@protocol(ActivationOrder),
0};

externvardef id id_CAction=0;
externvardef id id_PAction=0;
externvardef id id_PFAction=0;
externvardef id id_FAction_c=0;
externvardef id id_ActionCall_c=0;
externvardef id id_ActionTo_c=0;
externvardef id id_ActionForEach_c=0;
externvardef id id_ActionForEachHomogeneous_c=0;
externvardef id id_FActionForEachHeterogeneous_c=0;
externvardef id id_FActionForEachHomogeneous_c=0;
externvardef id id_ActionGroup_c=0;
externvardef id id_ConcurrentGroup_c=0;
externvardef id id_GroupActivity_c=0;
externvardef id id_GroupIndex_c=0;
externvardef id id_GroupPermutedIndex_c=0;
externvardef id id_ForEachActivity_c=0;
externvardef id id_ForEachIndex_c=0;
externvardef id id_ActionType_c=0;
externvardef id id_CompoundAction_c=0;
externvardef id id_Schedule_c=0;
externvardef id id_ActionConcurrent_c=0;
externvardef id id_ConcurrentSchedule_c=0;
externvardef id id_ActivationOrder_c=0;
externvardef id id_ScheduleActivity_c=0;
externvardef id id_ScheduleIndex_c=0;
externvardef id id_ActionChanged_c=0;
externvardef id id_CSwarmProcess=0;
externvardef id id_SwarmActivity_c=0;
externvardef id id_ActionMerge_c=0;
externvardef id id_Activity_c=0;

void *_activity_classes[]={
&id_CAction,
&id_PAction,
&id_PFAction,
&id_FAction_c,
&id_ActionCall_c,
&id_ActionTo_c,
&id_ActionForEach_c,
&id_FActionForEachHeterogeneous_c,
&id_FActionForEachHomogeneous_c,
&id_ActionGroup_c,
&id_ConcurrentGroup_c,
&id_GroupActivity_c,
&id_GroupIndex_c,
&id_GroupPermutedIndex_c,
&id_ForEachActivity_c,
&id_ForEachIndex_c,
&id_ActionType_c,
&id_CompoundAction_c,
&id_Schedule_c,
&id_ActionConcurrent_c,
&id_ConcurrentSchedule_c,
&id_ActivationOrder_c,
&id_ScheduleActivity_c,
&id_ScheduleIndex_c,
&id_ActionChanged_c,
&id_CSwarmProcess,
&id_SwarmActivity_c,
&id_ActionMerge_c,
&id_Activity_c,
0};

@class CAction;
@class PAction;
@class PFAction;
@class FAction_c;
@class ActionCall_c;
@class ActionTo_c;
@class ActionForEach_c;
@class FActionForEachHeterogeneous_c;
@class FActionForEachHomogeneous_c;
@class ActionGroup_c;
@class ConcurrentGroup_c;
@class GroupActivity_c;
@class GroupIndex_c;
@class GroupPermutedIndex_c;
@class ForEachActivity_c;
@class ForEachIndex_c;
@class ActionType_c;
@class CompoundAction_c;
@class Schedule_c;
@class ActionConcurrent_c;
@class ConcurrentSchedule_c;
@class ActivationOrder_c;
@class ScheduleActivity_c;
@class ScheduleIndex_c;
@class ActionChanged_c;
@class CSwarmProcess;
@class SwarmActivity_c;
@class ActionMerge_c;
@class Activity_c;

extern void _activity_implement(void);
extern void _activity_initialize(void);

void *_activity_[]=
{
0,
"activity",
(void *)_activity_implement,
(void *)_activity_initialize,
_activity_types,
_activity_symbols,
_activity_classes,
};


@interface Module_super_
+ self;
@end
@interface Module__activity_ : Module_super_
@end
@implementation Module__activity_
+ initialize
{
// initialize class id constants and link all classes into module
id_CAction=[CAction self];
id_PAction=[PAction self];
id_PFAction=[PFAction self];
id_FAction_c=[FAction_c self];
id_ActionCall_c=[ActionCall_c self];
id_ActionTo_c=[ActionTo_c self];
id_ActionForEach_c=[ActionForEach_c self];
id_FActionForEachHeterogeneous_c=[FActionForEachHeterogeneous_c self];
id_FActionForEachHomogeneous_c=[FActionForEachHomogeneous_c self];
id_ActionGroup_c=[ActionGroup_c self];
id_ConcurrentGroup_c=[ConcurrentGroup_c self];
id_GroupActivity_c=[GroupActivity_c self];
id_GroupIndex_c=[GroupIndex_c self];
id_GroupPermutedIndex_c=[GroupPermutedIndex_c self];
id_ForEachActivity_c=[ForEachActivity_c self];
id_ForEachIndex_c=[ForEachIndex_c self];
id_ActionType_c=[ActionType_c self];
id_CompoundAction_c=[CompoundAction_c self];
id_Schedule_c=[Schedule_c self];
id_ActionConcurrent_c=[ActionConcurrent_c self];
id_ConcurrentSchedule_c=[ConcurrentSchedule_c self];
id_ActivationOrder_c=[ActivationOrder_c self];
id_ScheduleActivity_c=[ScheduleActivity_c self];
id_ScheduleIndex_c=[ScheduleIndex_c self];
id_ActionChanged_c=[ActionChanged_c self];
id_CSwarmProcess=[CSwarmProcess self];
id_SwarmActivity_c=[SwarmActivity_c self];
id_ActionMerge_c=[ActionMerge_c self];
id_Activity_c=[Activity_c self];

// return module object
return (id)_activity_;
}
@end
