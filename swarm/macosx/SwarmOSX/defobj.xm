#import <defobj.h>
#import <objc/objc-api.h>

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
externvardef id LanguageCOM=0, LanguageJS=0, LanguageJava=0, LanguageObjc=0;

void *_defobj_symbols[]={
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
&LanguageCOM, &LanguageJS, &LanguageJava, &LanguageObjc,
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
"LanguageCOM", "LanguageJS", "LanguageJava", "LanguageObjc",
0};

externvardef id DefinedObject=0;
externvardef id Customize=0;
externvardef id Create=0;
externvardef id Drop=0;
externvardef id SwarmZone=0;
externvardef id GetName=0;
externvardef id DefinedClass=0;
externvardef id CreatedClass=0;
externvardef id BehaviorPhase=0;
externvardef id Copy=0;
externvardef id GetOwner=0;
externvardef id SetInitialValue=0;
externvardef id Symbol=0;
externvardef id SwarmEventType=0;
externvardef id Warning=0;
externvardef id Error=0;
externvardef id Arguments=0;
externvardef id Archiver=0;
externvardef id LispArchiver=0;
externvardef id HDF5Archiver=0;
externvardef id HDF5=0;
externvardef id HDF5CompoundType=0;
externvardef id FArguments=0;
externvardef id FCall=0;
externvardef id Serialization=0;

void *_defobj_types[]={
&DefinedObject,
&Customize,
&Create,
&Drop,
&SwarmZone,
&GetName,
&DefinedClass,
&CreatedClass,
&BehaviorPhase,
&Copy,
&GetOwner,
&SetInitialValue,
&Symbol,
&SwarmEventType,
&Warning,
&Error,
&Arguments,
&Archiver,
&LispArchiver,
&HDF5Archiver,
&HDF5,
&HDF5CompoundType,
&FArguments,
&FCall,
&Serialization,
0,
@protocol(DefinedObject),
@protocol(Customize),
@protocol(Create),
@protocol(Drop),
@protocol(Zone),
@protocol(GetName),
@protocol(DefinedClass),
@protocol(CreatedClass),
@protocol(BehaviorPhase),
@protocol(Copy),
@protocol(GetOwner),
@protocol(SetInitialValue),
@protocol(Symbol),
@protocol(SwarmEventType),
@protocol(Warning),
@protocol(Error),
@protocol(Arguments),
@protocol(Archiver),
@protocol(LispArchiver),
@protocol(HDF5Archiver),
@protocol(HDF5),
@protocol(HDF5CompoundType),
@protocol(FArguments),
@protocol(FCall),
@protocol(Serialization),
0};

externvardef id id_Archiver_c=0;
externvardef id id_Application=0;
externvardef id id_LispArchiver_c=0;
externvardef id id_Arguments_c=0;
externvardef id id_CreateDrop_s=0;
externvardef id id_CreateDrop=0;
externvardef id id_Customize_s=0;
externvardef id id_CreateBy_c=0;
externvardef id id_Create_bycopy=0;
externvardef id id_Create_bysend=0;
externvardef id id_Create_byboth=0;
externvardef id id_Class_s=0;
externvardef id id_CreatedClass_s=0;
externvardef id id_BehaviorPhase_s=0;
externvardef id id_Object_s=0;
#if HAVE_HDF5
externvardef id id_HDF5Archiver_c=0;
externvardef id id_HDF5CompoundType_c=0;
externvardef id id_HDF5_c=0;
#endif
externvardef id id_Type_c=0;
externvardef id id_ProgramModule_c=0;
externvardef id id_Module_super_=0;
externvardef id id_Symbol_c=0;
externvardef id id_SwarmEventType_c=0;
externvardef id id_Warning_c=0;
externvardef id id_Error_c=0;
externvardef id id_Zone_c=0;
externvardef id id_ComponentZone_c=0;
externvardef id id_FCall_c=0;
externvardef id id_FArguments_c=0;
externvardef id id_JavaProxy=0;
externvardef id id_JavaCollection=0;
externvardef id id_JavaCollectionIndex=0;

void *_defobj_classes[]={
&id_Archiver_c,
&id_Application,
&id_LispArchiver_c,
&id_Arguments_c,
&id_CreateDrop_s,
&id_CreateDrop,
&id_Customize_s,
&id_CreateBy_c,
&id_Create_bycopy,
&id_Create_bysend,
&id_Create_byboth,
&id_Class_s,
&id_CreatedClass_s,
&id_BehaviorPhase_s,
&id_Object_s,
#if HAVE_HDF5
&id_HDF5Archiver_c,
&id_HDF5CompoundType_c,
&id_HDF5_c,
#endif
&id_Type_c,
&id_ProgramModule_c,
&id_Module_super_,
&id_Symbol_c,
&id_SwarmEventType_c,
&id_Warning_c,
&id_Error_c,
&id_Zone_c,
&id_ComponentZone_c,
&id_FCall_c,
&id_FArguments_c,
&id_JavaProxy,
&id_JavaCollection,
&id_JavaCollectionIndex,
0};

@class Archiver_c;
@class Application;
@class LispArchiver_c;
@class HDF5Archiver_c;
@class Arguments_c;
@class CreateDrop_s;
@class CreateDrop;
@class Customize_s;
@class CreateBy_c;
@class Create_bycopy;
@class Create_bysend;
@class Create_byboth;
@class Class_s;
@class CreatedClass_s;
@class BehaviorPhase_s;
@class Object_s;
@class HDF5CompoundType_c;
@class HDF5_c;
@class Type_c;
@class ProgramModule_c;
@class Module_super_;
@class Symbol_c;
@class SwarmEventType_c;
@class Warning_c;
@class Error_c;
@class Zone_c;
@class ComponentZone_c;
@class FCall_c;
@class FArguments_c;
@class JavaProxy;
@class JavaCollection;
@class JavaCollectionIndex;

extern void _defobj_implement(void);
extern void _defobj_initialize(void);

void *_defobj_[]=
{
0,
"defobj",
(void *)_defobj_implement,
(void *)_defobj_initialize,
_defobj_types,
_defobj_symbols,
_defobj_classes,
};


@interface Module_super_
+ self;
@end
@interface Module__defobj_ : Module_super_
@end
@implementation Module__defobj_
+ initialize
{
// initialize class id constants and link all classes into module
id_Archiver_c=[Archiver_c self];
id_Application=[Application self];
id_LispArchiver_c=[LispArchiver_c self];
id_Arguments_c=[Arguments_c self];
id_CreateDrop_s=[CreateDrop_s self];
id_CreateDrop=[CreateDrop self];
id_Customize_s=[Customize_s self];
id_CreateBy_c=[CreateBy_c self];
id_Create_bycopy=[Create_bycopy self];
id_Create_bysend=[Create_bysend self];
id_Create_byboth=[Create_byboth self];
id_Class_s=[Class_s self];
id_CreatedClass_s=[CreatedClass_s self];
id_BehaviorPhase_s=[BehaviorPhase_s self];
id_Object_s=[Object_s self];
#if HAVE_HDF5
id_HDF5Archiver_c=[HDF5Archiver_c self];
id_HDF5CompoundType_c=[HDF5CompoundType_c self];
id_HDF5_c=[HDF5_c self];
#endif
id_Type_c=[Type_c self];
id_ProgramModule_c=[ProgramModule_c self];
id_Module_super_=[Module_super_ self];
id_Symbol_c=[Symbol_c self];
id_SwarmEventType_c=[SwarmEventType_c self];
id_Warning_c=[Warning_c self];
id_Error_c=[Error_c self];
id_Zone_c=[Zone_c self];
id_ComponentZone_c=[ComponentZone_c self];
id_FCall_c=[FCall_c self];
id_FArguments_c=[FArguments_c self];
id_JavaProxy=[JavaProxy self];
id_JavaCollection=[JavaCollection self];
id_JavaCollectionIndex=[JavaCollectionIndex self];

// return module object
return (id)_defobj_;
}
@end
