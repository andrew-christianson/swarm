extern void *_defobj_[];

externvar id DefinedObject;
externvar id Customize;
externvar id Create;
externvar id Drop;
externvar id SwarmZone;
externvar id GetName;
externvar id DefinedClass;
externvar id CreatedClass;
externvar id BehaviorPhase;
externvar id Copy;
externvar id GetOwner;
externvar id SetInitialValue;
externvar id Symbol;
externvar id SwarmEventType;
externvar id Warning;
externvar id Error;
externvar id Arguments;
externvar id Archiver;
externvar id LispArchiver;
externvar id HDF5Archiver;
externvar id HDF5;
externvar id HDF5CompoundType;
externvar id FArguments;
externvar id FCall;
externvar id Serialization;

#ifdef DEFINE_CLASSES
#if SWARM_OSX
#import <defobj_classes.h>
#else
#import <defobj/classes.h>
#endif
#endif
