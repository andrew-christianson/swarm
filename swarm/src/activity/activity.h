// Swarm library. Copyright (C) 1996-1998 Santa Fe Institute.
// This library is distributed without any warranty; without even the
// implied warranty of merchantability or fitness for a particular purpose.
// See file LICENSE for details and terms of copying.

/*
Name:         activity.h
Description:  processing control over all levels of swarm execution 
Library:      activity
*/

//D: The activity library is responsible for scheduling actions to occur
//D: within a simulated world, and for making these actions actually happen
//D: at the right time in the right order.  It provides the foundation of
//D: dynamic, object-oriented simulation within Swarm.

//D: Actions consist of messages to objects, calls to functions, or groups
//D: of actions in some defined order.  The activity library guarantees
//D: that all these actions, and the state changes they produce, occur at
//D: predictable points in time.  Time is defined by the relative order of
//D: actions, and may also be indexed by the discrete values of a world
//D: clock.

#import <collections.h>

@deftype ProcessType
//S: ProcessType -- specification of a process

//D: ProcessType will eventually define support for parameterization of all
//D: processes.  A process is a uniquely identified course of events that
//D: conforms to a specification of external and internal behavior.
//
//D: Processes include both objects and executable actions.  Objects change
//D: their state and behavior based on a sequence of externally initiated
//D: actions.  An action, in contrast, typically has no external behavior
//D: other than to be executed in its entirety as a unit (yielding either an
//D: observable result or some change of state in a surrounding environment).

//D: Parameterization will be based a uniform framework that defines all input
//D: parameters, internal state variables, and/or final results, and that
//D: provides for binding of these data in a context of execution.  This
//D: parameterization framework is still being established, but ProcessType
//D: objects will eventually record the specification of any process, to the
//D: extent that this specification is defined.
@end

@deftype ActionType
//S: Specification of an executable process.

//D: An action type is a type of process that may be initiated as a unit of
//D: execution by an external request.  A typical action has a well-defined
//D: duration determined by a fixed set of actions that execute within it.
//D: Externally initiated interaction typically occurs only at the start or
//D: end of the overall process.  A typical action is executed in its
//D: entirety once an external request that initiates it has occurred.
//D: Some actions may also have internal events that cannot begin or
//D: complete until other actions from a containing environment have also
//D: begun or completed their execution.  Such ordering constraints can be
//D: defined either within an action type or as part of a dynamic context
//D: of execution.

//D: Executable actions include both actions compiled in a host language
//D: (such as C functions or Objective C messages) and compound actions
//D: built at runtime for interpretation by the Swarm abstract machine.

//D: (.. For now, the only subtype of ActionType is CompoundAction.  Types
//D: for compiled actions such as functions and messages have not been
//D: defined yet. ..)

//M: The activateIn: message is used to initialize a process for executing
//M: the actions of an ActionType.  This process is controlled by an object
//M: called an Activity.  The activateIn message initializes an activity to
//M: run under the execution context passed as the swarmContext argument,
//M: and return the activity object just created.  If the execution context
//M: is nil, an activity is returned that allows complete execution control
//M: by the caller.  Otherwise, the execution context must be either an
//M: instance of SwarmProcess or SwarmActivity.  (These objects are always
//M: maintained in one-to-one association with each other, either one of
//M: the pair is equivalent to the other as a swarmContext argument.)<p>

//M: If a top-level activity is created (swarmContext is nil), the created
//M: activity may be processed using activity processing commands such as
//M: run, step, etc.  If an activity is created to run under a swarm
//M: context, the swarm itself has responsibility for advancing the
//M: subactivity according to its requirements for synchronization and
//M: control among all its activities.  Activating a plan for execution
//M: under a swarm turns over control to the swarm to execute the
//M: subactivity as a more-or-less autonomous activity.
-		activateIn: swarmContext;
@end


@deftype DefaultOrder
//S: The DefaultOrder option indicates the ordering to be assumed among
//S: actions of the plan when no other explicit ordering has been assigned.

//D: The DefaultOrder option indicates the ordering to be assumed among
//D: actions of the plan when no other explicit ordering has been assigned.
//D: Beyond this initial ordering, additional ordering constraints can be
//D: added selectively using partial order specifications on individual
//D: actions.  (.. Partial order order constraints are not yet
//D: implemented.)

//D: The value for DefaultOrder is a symbol that may have one of the
//D: following values: Concurrent, Sequential, Randomized;

//D: The Concurrent value of the DefaultOrder option indicates that can
//D: actions be run in any order (including at the same time, if hardware
//D: and software to do this is available) without no impact on the net
//D: outcome of the actions.  The claim that action results are independent
//D: of their execution order gives the processing machinery explicit
//D: leeway to execute them in any order it chooses.  In the current
//D: implementation on a single, serial processor, actions are always
//D: processed sequentially even if marked concurrent, because that is the
//D: only way they can be.  In future versions, however, special runtime
//D: processing modes may be defined even for a serial processor, which
//D: would mix up execution order just to confirm the independence of model
//D: results.

//D: The Sequential value for the DefaultOrder option is the default.  It
//D: specifies that the actions must always be executed in the same order
//D: as they occur in the plan.  This order is ordinarily the same order in
//D: which actions are first created in the plan, unless actions are
//D: explicitly added elsewhere the collection that underlies a plan.  This
//D: option is always the safest to assure predictability of results, but
//D: it excludes the ability to run the actions in parallel.  To better
//D: understand and document a model design, it is worth annotating action
//D: plans with an explicit indication as to whether they do or do not
//D: depend on a Sequential order.

//D: The Randomized value for the DefaultOrder option specifies that the
//D: model results do depend on execution order, but that the order in
//D: which the actions were created or added has no special significance.
//D: Instead, the method of dealing with order dependence is to generate a
//D: random order each time a collection of same-time actions is processed.
//D: The random order will be generated from an random number generator
//D: internal to the processing machinery.
CREATING
- (void)setDefaultOrder: aSymbol;
USING
- getDefaultOrder;
@end

@deftype AutoDrop
//S: Specify that an action is dropped after being processed.

//D: The AutoDrop option specifies that as soon as any action been
//D: processed by a running activity, the action is removed from the plan
//D: and dropped so that it will never appear again.  This option is useful
//D: for plans that are created for a one-time use, never to be used again.
//D: This option is especially useful for a dynamic schedule that
//D: continually receives new actions to be executed at future times, but
//D: will never repeat actions that were previously scheduled.  Depending
//D: on the underlying implementation of the schedule, making sure the old
//D: actions get dropped using AutoDrop can considerably improve the
//D: performance of the schedule.

//D: When an option like AutoDrop is used, or whenever the contents of an
//D: action plan undergo a significant amount of dynamic update, the action
//D: plan would ordinarily be intended only for a single point of use.  If
//D: AutoDrop is specified, a restriction against multiple active
//D: references is enforced.  An error will be raised if two activities
//D: ever attempt to process a plan with AutoDrop enabled at the same time.
CREATING
- (void)setAutoDrop: (BOOL)autoDrop;
USING
- (BOOL)getAutoDrop;
@end

@deftype CompoundAction <ActionType, Collection, DefaultOrder, AutoDrop>
//S: A collection of actions to be performed in any order consistent with a
//S: set of ordering constraints.

//D: An compound action is the supertype of ActionGroup and Schedule.  A
//D: compound action defines an executable process that is composed from the
//D: execution of a set of actions in some defined order.

//D: CompoundAction is not directly creatable.  One of its subtypes must be
//D: created instead.  ActionPlan inherits the basic ability to be
//D: activated for execution from ActionType.
@end

// values for DefaultOrder
extern id <Symbol>  Concurrent, Sequential, Randomized;

@deftype ActionCreatingCall
//S: An action that calls a C function.

//D: The createActionCall: messages are similar to the createActionTo
//D: messages, except they specify the action to be performed as a binding
//D: of a C function to a list of argument values.  The correct number of
//D: arguments for the function pointer passed as the initial argument must
//D: be supplied.

- createActionCall: (func_t)fptr;
- createActionCall: (func_t)fptr : arg1;
- createActionCall: (func_t)fptr : arg1 : arg2;
- createActionCall: (func_t)fptr : arg1 : arg2 : arg3;
@end

@deftype ActionCreatingTo
//S: An action that sends a message to an object.

//D: A createActionTo: message specifies that the action to be performed is
//D: defined by an Objective C message selector to be performed on a
//D: receiving object plus any required arguments.  The message selector is
//D: specified by the message: argument and the receiving object is
//D: specified as the first argument, target.

//E: Given a variable aTurtle already initialized to a valid object, following
//E: is an example of a createActionTo message:

//E: [createActionTo: aTurtle message: M(print)];

//E: M() is a macro defined in defobj.h which is just a convenient
//E: shorthand for the Objective C expression @selector(message-name).  As
//E: in any selector, the message name must include all parts of the
//E: message including colons and subsequent argument portions.  An example
//E: of a message with one additional argument is the following:

//E: [createActionTo: aTurtle message: $m(move:) : (id)10];

- createActionTo: target message: (SEL)aSel;
- createActionTo: target message: (SEL)aSel : arg1;
- createActionTo: target message: (SEL)aSel : arg1 : arg2;
- createActionTo: target message: (SEL)aSel : arg1 : arg2 : arg3;
@end

@deftype ActionCreatingForEach
//S: Send a message to every item in target, which is assumed to be a
//S: collection.

//D: The createActionForEach: messages define a message to be sent in the
//D: same way as the createActionTo messages, but they assume that the
//D: object passed as the target argument is a collection object.  They
//D: specify that each object available from that collection, using the
//D: standard messages of the Collection type in the collections library,
//D: is to receive the specified message.

- createActionForEach: target message: (SEL)aSel;
- createActionForEach: target message: (SEL)aSel : arg1;
- createActionForEach: target message: (SEL)aSel : arg1 : arg2;
- createActionForEach: target message: (SEL)aSel : arg1 : arg2 : arg3;
@end

@deftype ActionCreating <ActionCreatingCall, ActionCreatingTo, ActionCreatingForEach>
//S: Protocol shared by ActionGroup and Schedule.

//D: ActionCreating defines the createAction messages for ActionGroup just
//D: so that this protocol may be shared with Schedule, where they provide
//D: a convenience interface for the creation of actions in the schedule at
//D: time zero. 

//D: The createAction messages declare all arguments of the message to be
//D: of object id type, but you are free to cast other pointers and values
//D: up to the limits defined by the global portability assumptions.  These
//D: is not portable across all machine architectures, but is expected to
//D: be portable across the 32-bit and 64-bit architectures on which Swarm
//D: will be supported.  The message you send must still be declared to
//D: receive the type of argument you actually pass, before you cast it to
//D: the id type.

//D: (.. Alternative approaches to argument typing are currently in
//D: development, but these will supplement rather than replace the current
//D: forms of createAction messages.)

//D: Each of the createAction messages returns the action object which it
//D: creates.  Each different kind of createAction message returns a
//D: different type of Action object with a matching name.  These Action
//D: objects provide access to all the information with which the Action
//D: was initialized.  The complete set of Action object types is defined
//D: below together with the messages that may be used to access their
//D: contents.  (.. The implementation of the Action objects is currently
//D: undergoing change as the responsibility for parameter and return value
//D: typing gets taken over by ActionType in defobj.)

//M: The createAction: message specifies that processing of another action
//M: type is to be performed by the action.  The referenced action type is
//M: performed in its entirety, from start to finish, as the effect of the
//M: single created action.
- createAction: anActionType;

@end

@deftype ActionGroup <CompoundAction, ActionCreating, OrderedSet, CREATABLE>
//S: A collection of actions under total or partial order constraints.

//D: An action group is an action plan whose basic representation is a
//D: sequence of actions that have been created within it.  Even though a
//D: sequence is used to represent the actions of the collection, this does
//D: not necessarily mean that the execution machinery will process them in
//D: this order, since the permissible order of execution is still
//D: controlled by the DefaultOrder option inherited from ActionPlan.  This
//D: initial order may also be further constrained by partial order
//D: constraints among the actions.  (.. Partial order constraints are
//D: currently unimplemented.)

//D: An action group inherits its underlying representation from the
//D: OrderedSet type of the collections library.  All the members of the
//D: ordered set must consist only of actions that are created by one of
//D: the createAction messages defined on ActionGroup itself.  Once the
//D: actions are created, they may be accessed or traversed using standard
//D: messages of the OrderedSet type.  Partial orders on these actions are
//D: also established by inherited messages.  (.. Currently, partial orders
//D: are not implemented on either collections or action plans, but the
//D: messages inherited from OrderedSet will be the basic method for
//D: maintaining them once implemented.)

//D: The action objects are an integral, controlled component of the action
//D: plan in which they are created.  If they are removed from the action
//D: plan collection using a remove message, the only collection in which
//D: they may be reinserted is the same collection from which they came.
//D: It is permissible, however, to modify the base representation sequence
//D: by removing from one position and reinserting at another.

//D: The contents of the action objects would ordinarily be referenced only
//D: by general-purpose tools to display or analyze an action plan
//D: structure.  The action object id, however, can also be used to
//D: establish additional ordering constraints on any of the actions in a
//D: plan.  These constraints supplement any initial order constraints
//D: established by the DefaultOrder option.  Constraints may be
//D: established not only within the same plan, but between actions in
//D: different plans.  (.. Partial order constraints are not yet
//D: implemented.)
@end

//
// timeval_t, TimebaseMax --
//   type of a time value, and maximum value of a value of type timeval_t
//
#ifndef DEFINED_timeval_t
#define DEFINED_timeval_t

//D: Values of this type are used as keys when inserting actions into a
//D: schedule at a particular time, or for querying the current time value
//D: of a swarm or schedule during its execution.  (The shorter name time_t
//D: has already been taken by one the standard C libraries.)

//D: For very long running models using finely divided units of time, it is
//D: quite possible that a 32-bit unsigned time value could overflow.
//D: Special messages are provided in the execution machinery to reset all
//D: times to a different base value if a danger of overflow exists.  If
//D: this machinery is exercised, all times of all referenced action plans
//D: are reset to a different base value in unison, which makes the shift
//D: as transparent as possible.  Separate support is also available to
//D: declare time values that are subunits of the discrete clock values in
//D: a containing schedule or swarm.  (.. Currently, all this extended time
//D: unit support is unsupported, though there is an example of scheduling
//D: at subunit times in a GridTurtle test program.)
typedef unsigned long timeval_t;
#endif
extern const timeval_t  TimebaseMax;


@deftype RelativeTime
//S: Specifies that time is relative to when the schedule started.

//D: The RelativeTime option specifies that all the times in the schedule
//D: are relative to the time when processing of the entire schedule
//D: begins.  Otherwise, the times are assumed to be absolute times, with
//D: their base in the starting time of the entire model.
CREATING
- create: aZone setRelativeTime: (BOOL)relativeTime;
SETTING
- (void)setRelativeTime: (BOOL)relativeTime;
USING
- (BOOL)getRelativeTime;
@end

@deftype RepeatInterval
//S: Reschedule actions after a period of time.

//D: The RepeatInterval option specifies that as soon as all actions in the
//D: schedule have completed, it is to be rescheduled at a time computed as
//D: the time at which the schedule was last started, plus the value
//D: specified as the RepeatInterval argument.  This option overrides the
//D: normal default that times are considered absolute, as if the
//D: RelativeTime option had also been specified at the same time.  All
//D: scheduled times must be less than the specified repeat interval, or an
//D: error will be raised.  The RepeatInterval option can continue to be
//D: reassigned to different values after a schedule has been created, but
//D: the interval value must always be greater than the scheduled times of
//D: any actions which it contains.
//D: (.. This option is currently supported only on schedule, not swarms.)

CREATING
- create: aZone setRepeatInterval: (timeval_t)repeatInterval;
SETTING
- (void)setRepeatInterval: (timeval_t)repeatInterval;
USING
- (timeval_t)getRepeatInterval;
@end

@deftype ConcurrentGroupType
//S: Handle actions schedule at same time value.

//D: The ConcurrentGroupType option is used to control handling of multiple
//D: actions which end up being scheduled at the same time value.  As far
//D: the schedule representation is concerned, these actions are assumed by
//D: default to be concurrently executable, and the processing machinery is
//D: free to process them as such if no ConcurrentGroupType option is
//D: specified.

//D: If a different interpretation of actions at the same time step is
//D: needed, the ConcurrentGroupType option may be specified.  The argument
//D: of this option must be an object that when given a standard create:
//D: message will return an object having all the structure of a standard
//D: ActionGroup object.

//E: For example, if you want to specify that actions at the same time step
//E: are to be processed in random order, you could use the following
//E: procedure:

//E: concurrentGroupType = [ActionGroup customizeBegin: aZone];
//E: [concurrentGroupType setDefaultOrder: Random];
//E: concurrentGroupType = [concurrentGroupType customizeEnd];

//E: aSchedule = [Schedule createBegin: aZone];
//E: [aSchedule setConcurrentGroupType: concurrentGroupType];
//E: aSchedule = [aSchedule createEnd];

//D: Note that instead of using the normal createBegin/End sequence to
//D: create an instance, the concurrentGroupType is initialized using the
//D: customizeBegin/End sequence to customize a type without creating an
//D: instance.  For more information, see the defobj library
//D: documentation.

//D: In addition to overriding the standard ActionGroup type, the
//D: concurrent group type may be implemented by a custom subclass of the
//D: ActionGroup implementation which you supply yourself.  A custom
//D: subclass is free to implement custom rules for how to combine all the
//D: actions which happen to arrive at the same time value.  For example,
//D: it could decide that some actions are not to be executed at all, or it
//D: could create entirely new actions to be executed instead of or in
//D: addition to those which were originally scheduled.

//D: (.. Specific rules for writing a custom ActionGroup subclass will be
//D: documented at a future time, but all the apparatus to do so is present
//D: today.  A concurrent action group is currently used to maintain the
//D: proper order of execution among subswarms of an owner swarm.)
SETTING
- (void)setConcurrentGroupType: groupType;
USING
- getConcurrentGroupType;
@end

@deftype SingletonGroups
//S: Indicates that an action group should be created for every time
//S: value which is present.

//D: The SingletonGroups option indicates that an action group should be
//D: created for every time value which is present, even when only a single
//D: action is present at the time value.

//D: Ordinarily, a concurrent action group is created to process actions at
//D: the same timestep only if more than one action is scheduled at that
//D: timestep.  The overhead of these action groups is relatively low,
//D: because it just creates a single new object to which actions are
//D: directly linked, but it is still faster to avoid creating them if only
//D: one action is present at a timestep.  If a custom subclass is being
//D: provided however, it may need to examine the actions at a timestep
//D: even if there is only one.
SETTING
- (void)setSingletonGroups: (BOOL)singletonGroups;
USING
- (BOOL)getSingletonGroups;
@end

@deftype Schedule <CompoundAction, ActionCreating, Map, CREATABLE, RelativeTime, RepeatInterval, ConcurrentGroupType, SingletonGroups>
//S: A collection of actions ordered by time values.

//D: A schedule is compound action whose basic representation is a sorted
//D: Map of actions that have been created within it.  The key value
//D: associated with each of these actions is an unsigned integer value for
//D: which the typedef timeval_t is supplied.

//D: A schedule inherits its underlying representation from the Map type of
//D: the collections library.  All the members of the ordered set must
//D: consist only of actions that are created by one of the createAction
//D: messages defined on Schedule itself.  Once the actions are created,
//D: they may be accessed or traversed using standard messages of the Map
//D: type.  The key values of this collection, however, must be cast to and
//D: from the id type defined for key values by the Map type.  Partial
//D: orders on these actions can also established by messages inherited
//D: from Map.  (.. Currently, partial orders are not implemented on either
//D: collections or action plans, but the inherited messages will be the
//D: basic method for maintaining them once implemented.)

//D: The messages to create actions within a schedule are essentially the
//D: same as those for ActionGroup, except for the presence of an initial
//D: at: argument indicating the time at which an action is to be
//D: performed.  Except for the time associated with each action, meaning
//D: of the createAction messages is the same as for ActionGroup.

//D: When multiple actions are all scheduled at the same time, they are all
//D: inserted into a concurrent action group created for that time value.
//D: The ConcurrentGroupType option may be used to override the default
//D: action group for these concurrent actions by a custom user-defined
//D: subclass.  (.. Details of doing this are not yet documented, but there
//D: are examples.)

USING
- at: (timeval_t)tVal createAction: anActionType;

- at: (timeval_t)tVal createActionCall: (func_t)fptr;
- at: (timeval_t)tVal createActionCall: (func_t)fptr:arg1;
- at: (timeval_t)tVal createActionCall: (func_t)fptr:arg1:arg2;
- at: (timeval_t)tVal createActionCall: (func_t)fptr:arg1:arg2:arg3;

- at: (timeval_t)tVal createActionTo: target message: (SEL)aSel;
- at: (timeval_t)tVal createActionTo: target message: (SEL)aSel:arg1;
- at: (timeval_t)tVal createActionTo: target message: (SEL)aSel:arg1:arg2;
- at: (timeval_t)tVal createActionTo: target message: (SEL)aSel:arg1:arg2:arg3;

- at: (timeval_t)tVal createActionForEach: target message: (SEL)aSel;
- at: (timeval_t)tVal createActionForEach: target message: (SEL)aSel:arg1;
- at: (timeval_t)tVal createActionForEach: target message: (SEL)aSel:arg1:arg2;
- at: (timeval_t)tVal createActionForEach: target message: (SEL)aSel:
                                                                arg1:arg2:arg3;
@end

@deftype SynchronizationType
//D: Synchronization type sets the type of schedule which is used
//D: internally by the swarm to synchronize subschedules.  Its default is a
//D: schedule with a concurrent group of ActivationOrder.

//D: The default value for the SynchronizationType option is not a generic
//D: action group, but a special predefined subtype of ActionGroup called
//D: ActivationOrder.  This concurrent group type guarantees that actions
//D: scheduled to occur at the same time from different action plans
//D: running in the same swarm are executed in the same order in which the
//D: action plans were first activated.

CREATING
- (void)setSynchronizationType: aScheduleType;
USING
- getSynchronizationType;
@end

@deftype InternalTimeMultiplier
//D: (.. This option will be used in the future to support an internal time
//D: unit within the swarm that can be more fine-grained than the context
//D: in which the swarm is included. ..)
CREATING
- (void)	setInternalTimeMultiplier: (timeval_t)multiplier;
USING
- (timeval_t)	getInternalTimeMultiplier;
@end

@deftype SwarmProcess <ActionType, Zone, CREATABLE, SynchronizationType, InternalTimeMultiplier>
//S: An object that holds a collection of concurrent subprocesses.

//D: SwarmProcess inherits the messages of both ActionType and Zone.
//D: Inheritance of zone behavior means that a swarm can be used as the
//D: argument of a create: or createBegin: message, for creation of an
//D: object within the internal zone of a swarm.

//D: Unlike other action types, swarms and swarm activities always exist in
//D: a one-to-one relationship, provided that the swarm has been activated.
//D: This restriction to a single activity enables the swarm to do
//D: double-duty as a custom object that provides its own interface to the
//D: activities running within the swarm.

CREATING
//M: The InternalZoneType option sets the type of zone which is created by
//M: the swarm to hold objects created within the swarm.  If set to nil, no
//M: internal zone is created within the swarm, and all use of the swarm as
//M: if it were a zone raises an error.  The default of this option is
//M: standard Zone type.  (.. Since there is no other Zone type yet,
//M: there's no reason to set this option yet except to turn off the
//M: internal zone. ..)
- setInternalZoneType: aZoneType;

USING

//M: getInternalZone returns a Zone object that is used by the swarm to
//M: hold its internal objects.  Even though the swarm itself inherits from
//M: Zone and can be used as a Zone for nearly all purposes, this message
//M: is also provided so that the zone itself can be obtained independent
//M: of all zone behavior.
- getInternalZone;

//M: getActivity returns the activity which is currently running of
//M: subactivities within the swarm.  This activity is the same as the
//M: value returned by activateIn: when the swarm was first activated.  It
//M: returns nil if the swarm has not yet been activated.
- getActivity;
@end


@deftype Action <GetOwner>
//S: An action type that has been customized for direct execution by an
//S: action interpreter.

//D: Action is a common supertype of all action types which may be created
//D: within an action plan.  Each action is always controlled by a single
//D: action plan to which it belongs.  This action plan is referred to as
//D: its owner.  Given the action object, its owner plan may be obtained
//D: using the inherited getOwner message.

//D: Actions are allocated in the same zone as their owner plan, and may be
//D: created only using one of the createAction messages on an ActionGroup
//D: or Schedule.  Each of these messages returns the action that was
//D: created as its return value.  Actions in an action plan may also be
//D: obtained by processing the plan using any of its messages inherited
//D: from its underlying collection.  Actions may also be removed from an
//D: action plan using a remove message on the underlying collection.

//D: (.. Note: currently, an action cannot be removed while it is currently
//D: being executed.  This means that the function or message called by an
//D: action cannot itself remove that same action from its action plan.
//D: This restriction will be removed in the future.)

//D: No matter what the type of action, the default ordering constraints
//D: established by its membership in an owning plan may be supplemented by
//D: explicit specification.  These specifications are made directly
//D: between actions in the same plan, or between actions in different
//D: plans if they are suitably qualified.  Given any action belonging to
//D: any plan, the set of specific explicit ordering constraints in which
//D: it participates may be obtained by one of the messages getSuccessors,
//D: getPredecessors, getCostarts, and Coends inherited from the <a
//D: KeyedCollection type.

//D: Separate subtypes of Action are defined for each of the various forms
//D: of createAction messages that create them.  The current representation
//D: of these actions will be undergoing change as support for their
//D: parameter and return types is migrated into more basic support from
//D: the defobj library.  Each action type provides messages to retrieve
//D: and set the values of all argument values bound into the action.
//D: These capabilities will remain, but different messages will
//D: eventually be supported.  This documentation will be completed once
//D: the messages supported on Action types are finalized.

//M: Get action type of action being performed by activity.
- getActionType;
@end

@deftype ActionArgs <Action>
//S: Supertype of ActionCall, ActionTo, and ActionForEach.

//D: The ActionArgs subtypes all implement a specific, hard-coded method
//D: for binding an action type to a fixed number of arguments.  All the
//D: arguments must have types compatible with id type.  Eventually, more
//D: generic methods for binding an action type to any number and types of
//D: arguments and return values will also be provided.

- (int)getNArgs;
- (void)setArg1: arg1;
- getArg1;
- (void)setArg2: arg2;
- getArg2;
- (void)setArg3: arg3;
- getArg3;
@end

@deftype ActionCall <ActionArgs>
//S: An action defined by calling a C function.

- (void)setFunctionPointer: (func_t)fptr;
- (func_t)getFunctionPointer;
@end

@deftype ActionTo <ActionArgs>
//S: An action defined by sending an Objective C message.

- (void)setTarget: target;
- getTarget;
- (void)setMessageSelector: (SEL)aSel;
- (SEL)getMessageSelector;
@end

@deftype ActionForEach <ActionTo>
//S: An action defined by sending a message to every member of a collection.
@end


@deftype Activity <DefinedObject, Drop>
//S: A level of processing by the interpreter of an action type.

//D: A object of type Activity implements the processing of actions within
//D: an action plan.  Each subtype of action plan has a corresponding
//D: subtype of Activity that implements processing of its respective type
//D: of plan.

//D: The Activity types are part of the virtual processing machinery of an
//D: action plan interpreter.  All the important elements of this
//D: machinery, including their current state of processing, are exposed to
//D: aid in development of general-purpose tools such as debuggers.  Except
//D: for applications that need to create and run their own reflective
//D: activities, direct use of activity types by a modeling application
//D: should be rare.

//D: A new activity object is created by each activateIn: message sent to
//D: an action type.  activateIn: initializes a new activity object and
//D: prepares it for processing, but does not itself execute any actions.
//D: Subsequent messages, such as run, must be used to initiate processing
//D: within an activity.  If an activity is activated to run under a swarm
//D: context, the owning swarm itself controls all processing within the
//D: subactivity.

//D: An Activity type holds a tree of currently running, or a potentially
//D: runnable, subactivities.  Each activity object represents a state of
//D: processing within a single action plan.  The structure is a tree
//D: because multiple activities could be running or eligible to run at the
//D: same time.  This occurs whenever two activities are specified as
//D: concurrent, either because are being performed by concurrent actions
//D: in some other plan, or because they were started for autonomous
//D: execution under the same swarm.  When parallel processing machinery is
//D: present, each activity could also be advancing its own state
//D: independent of those of any other activity.

//D: The current implementation supports only a single serial processor.
//D: Under serial execution, only one activity may be active at one time.
//D: This means that the current state of processing may be represented by
//D: a single stack of current activities that traces a path to a single
//D: leaf of the runnable activity tree.  When running in serial mode,
//D: messages are available to obtain the currently running leaf activity
//D: or useful context information such as the current time available from it.

//M: The run message continue processing of an activity from any state in
//M: which its execution has been suspended.  An error is raised if the
//M: activity is already running.  run returns either a Stopped or
//M: Completed status that the activity has when it is no longer eligible
//M: to be run further.
- run;

//M: The stop message causes the a currently running tree of activities to
//M: stop further processing and return a Stopped status.  
- stop;

//M: Terminate also
//M: stops a running tree of activities, but sets all activities within the
//M: tree to a status of Completed whenever the tree is next run.
//M: terminate may be used on either a running or stopped tree of
//M: activities.  It is the standard way to terminate schedule that is
//M: endlessly repeating under the RepeatInterval option.
- (void)terminate;

//M: The next executes actions within a single compound action while
//M: skipping over all processing of any complete action plans executed by
//M: those actions.
- next;

//M: The step message executes a single action within a tree of activities. 
- step;

//M: The stepEntry message executes multiple actions within a single
//M: currently runnable activity, but stops the activity when a new level
//M: of action plan has just been started within the tree of activities.
- stepEntry;

//M: stepExit executes multiple actions in the same action plan until the
//M: activity for that action plan has completed, or cannot otherwise be
//M: run further.
- stepExit;

//M: The getStatus message returns one of the following codes for the current
//M: run status of a particular activity:
//M: Initialized, Running, Stopped, Holding, Released, Terminated, Completed.
- getStatus;

//M: The getHoldType returns a code for the particular hold constraint
//M: under which an activity is currently holding (HoldStart or HoldEnd).
//M: It returns nil if the
//M: basic status of the activity is not Holding. 

//M: (.. Currently no hold
//M: constraints other than merging within a swarm are supported, and this
//M: message always returns nil.)
- getHoldType;

//M: Get action containing parameter bindings for the local activity.
- getAction;

//M: Get action type of action being performed by activity.
- getActionType;

//M: Change owner from one swarm activity to another.
- (void)setOwnerActivity: ownerActivity;

//M: Return activity under which this activity is running.
- getOwnerActivity;

//M: Return set of subactivities pending to be run.
- getSubactivities;

//M: Return activity that issued current run request on top-level activity.
- getControllingActivity;

//M: Return top of activity tree running the local activity.
- getTopLevelActivity;

//M: Return most immediately containing Swarm activity.
- getSwarmActivity;

//M: Return most immediately containing Schedule activity.
- getScheduleActivity;

//M: Set serial execution mode.
- setSerialMode: (BOOL)serialMode;

//M: Return indicator for serial execution mode.
- (BOOL)getSerialMode;

//M: Get running subactivity or next subactivity to run.
- getCurrentSubactivity;  // serial mode only
@end

// values returned by getStatus and getHoldType

extern id <Symbol>  Initialized, Running, Holding, Released,
                    Stopped, Terminated, Completed;
extern id <Symbol>  HoldStart, HoldEnd;


@deftype ForEachActivity <Activity>
//S: State of execution within a ForEach action.

- getCurrentMember;
@end

@deftype ScheduleActivity <Activity>
//S: State of execution within a Schedule.

#if 0
- setTerminateAtEnd: (BOOL)terminateAtEnd;
- (BOOL)getTerminateAtEnd;

- (void)setSynchronizedMode: (BOOL)synchronizedMode;
- getSynchronizedMode;
- (int)getCurrentTimebase;
#endif

//M: Get current time of activity (pending time if holding).
- (timeval_t)getCurrentTime;

//M: Advance activity until requested time has been reached.
- stepUntil: (timeval_t)tVal;
@end

@deftype SwarmActivity <ScheduleActivity>
//S: A collection of started subactivities.

//M: Return swarm object containing this swarm activity, if any.
- getSwarm;

- getSynchronizationSchedule;
@end

//
// Macros to access to the current context in which an action is executing
//

#define getCurrentSwarm() \
({ id swarmActivity; \
( _activity_current && \
  (swarmActivity = [_activity_current getSwarmActivity]) ? \
[swarmActivity getActionType] : \
_activity_context_error( "getCurrentSwarm" ) ); })

#define getCurrentSchedule() \
({ id scheduleActivity; \
( ( _activity_current & \
    (scheduleActivity = [_activity_current getScheduleActivity]) ) ? \
[scheduleActivity getActionType] : \
_activity_context_error( "getCurrentSchedule" ) ); })

#define getCurrentTime() \
({ id scheduleActivity; \
( _activity_current && \
  (scheduleActivity = [_activity_current getScheduleActivity]) ? \
[scheduleActivity getCurrentTime] : \
(timeval_t)_activity_context_error( "getCurrentTime" ) ); })

#define getTopLevelActivity() \
( _activity_current ? [_activity_current getTopLevelActivity] : \
_activity_context_error( "getTopLevelActivity" ) )

#define getCurrentSwarmActivity() \
( _activity_current ? [_activity_current getSwarmActivity] : \
_activity_context_error( "getCurrentSwarmActivity" ) )

#define getCurrentScheduleActivity() \
( _activity_current ? [_activity_current getScheduleActivity] : \
_activity_context_error( "getCurrentScheduleActivity" ) )

#define getCurrentOwnerActivity() \
( _activity_current ? _activity_current : \
_activity_context_error( "getCurrentOwnerActivity" ) )

#define getCurrentAction() \
( _activity_current ? [_activity_current _getSubactivityAction_] : \
_activity_context_error( "getCurrentAction" ) )

@deftype GetSubactivityAction
-	_getSubactivityAction_;  // internal method for getCurrentAction()
@end

#define getCurrentActivity() \
( _activity_current ? [_activity_current getCurrentSubactivity] : nil )

//
// _activity_current, _activity_context_error() --
//   internal definitions used by current context macros
//
extern id  _activity_current;
extern id  _activity_context_error (const char *macroName);


@deftype ConcurrentGroup <ActionGroup, CREATABLE>
//S: Default type used as concurrent group of a schedule.
@end

@deftype ConcurrentSchedule <ActionGroup, CREATABLE>
//S: Time-based map usable for concurrent group.
@end

@deftype ActivationOrder <ActionGroup, CREATABLE>
//S: Default type used as concurrent group of a swarm.
@end

//
// error symbols
//
extern id <Error>  InvalidSwarmZone;

//
// _activity_zone -- global variable for zone in which activity objects created
//
extern id  _activity_zone;

//
// _activity_trace --
//   global variable for function to be called on every change in the
//   activity tree
//
// Note: support for any specific form of this trace facility is not guaranteed
// in future versions.  Some form of trace facility will remain for debug
// purposes, however, at least until a full form of event history logging has
// been implemented as an integral part of the Activity type.
// 
extern BOOL (*_activity_trace)(id);  // trace function for activity execution

//
// include automatically generated definitions for activity package
//
#import <activity/types.h>
