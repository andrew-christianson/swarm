#import <collections.h>
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
externvardef id Start=0,End=0,Between=0,Removed=0,Member=0;
externvardef id OffsetOutOfRange=0,NoMembers=0,
AlreadyAtEnd=0,AlreadyAtStart=0,InvalidIndexLoc=0,InvalidLocSymbol=0;
#endif
externvardef id ArchiverLiteral=0,ArchiverQuote=0,ArchiverEOL=0,ArchiverDot=0;

void *_collections_symbols[]={
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
0};

externvardef id Offsets=0;
externvardef id ForEach=0;
externvardef id ForEachKey=0;
externvardef id Index=0;
externvardef id PermutedIndex=0;
externvardef id SwarmCollection=0;
externvardef id DefaultMember=0;
externvardef id MemberBlock=0;
externvardef id Array=0;
externvardef id ListIndex=0;
externvardef id List=0;
externvardef id CompareFunction=0;
externvardef id KeyedCollection=0;
externvardef id KeyedCollectionIndex=0;
externvardef id MemberSlot=0;
externvardef id _Set=0;
externvardef id Set=0;
externvardef id OrderedSet=0;
externvardef id MapIndex=0;
externvardef id Map=0;
externvardef id OutputStream=0;
externvardef id InputStream=0;
externvardef id ArchiverKeyword=0;
externvardef id ArchiverArray=0;
externvardef id ArchiverValue=0;
externvardef id ArchiverPair=0;
externvardef id ArchiverList=0;
externvardef id ArchiverQuoted=0;
externvardef id String=0;
externvardef id ListShuffler=0;
externvardef id PermutationItem=0;
externvardef id Permutation=0;

void *_collections_types[]={
&Offsets,
&ForEach,
&ForEachKey,
&Index,
&PermutedIndex,
&SwarmCollection,
&DefaultMember,
&MemberBlock,
&Array,
&ListIndex,
&List,
&CompareFunction,
&KeyedCollection,
&KeyedCollectionIndex,
&MemberSlot,
&_Set,
&Set,
&OrderedSet,
&MapIndex,
&Map,
&OutputStream,
&InputStream,
&ArchiverKeyword,
&ArchiverArray,
&ArchiverValue,
&ArchiverPair,
&ArchiverList,
&ArchiverQuoted,
&String,
&ListShuffler,
&PermutationItem,
&Permutation,
0,
@protocol(Offsets),
@protocol(ForEach),
@protocol(ForEachKey),
@protocol(Index),
@protocol(PermutedIndex),
@protocol(Collection),
@protocol(DefaultMember),
@protocol(MemberBlock),
@protocol(Array),
@protocol(ListIndex),
@protocol(List),
@protocol(CompareFunction),
@protocol(KeyedCollection),
@protocol(KeyedCollectionIndex),
@protocol(MemberSlot),
@protocol(_Set),
@protocol(Set),
@protocol(OrderedSet),
@protocol(MapIndex),
@protocol(Map),
@protocol(OutputStream),
@protocol(InputStream),
@protocol(ArchiverKeyword),
@protocol(ArchiverArray),
@protocol(ArchiverValue),
@protocol(ArchiverPair),
@protocol(ArchiverList),
@protocol(ArchiverQuoted),
@protocol(String),
@protocol(ListShuffler),
@protocol(PermutationItem),
@protocol(Permutation),
0};

externvardef id id_Array_c=0;
externvardef id id_ArrayIndex_c=0;
externvardef id id_Collection_any=0;
externvardef id id_Index_any=0;
externvardef id id_PermutedIndex_c=0;
externvardef id id_InputStream_c=0;
externvardef id id_ArchiverKeyword_c=0;
externvardef id id_ArchiverArray_c=0;
externvardef id id_ArchiverValue_c=0;
externvardef id id_ArchiverPair_c=0;
externvardef id id_ArchiverList_c=0;
externvardef id id_ArchiverQuoted_c=0;
externvardef id id_List_any=0;
externvardef id id_ListIndex_any=0;
externvardef id id_List_linked=0;
externvardef id id_ListIndex_linked=0;
externvardef id id_List_mlinks=0;
externvardef id id_ListIndex_mlinks=0;
externvardef id id_ListShuffler_c=0;
externvardef id id_Map_c=0;
externvardef id id_MapIndex_c=0;
externvardef id id_OrderedSet_c=0;
externvardef id id_OrderedSetIndex_c=0;
externvardef id id_OutputStream_c=0;
externvardef id id_Set_c=0;
externvardef id id_SetIndex_c=0;
externvardef id id_PermutationItem_c=0;
externvardef id id_Permutation_c=0;
externvardef id id_String_c=0;

void *_collections_classes[]={
&id_Array_c,
&id_ArrayIndex_c,
&id_Collection_any,
&id_Index_any,
&id_PermutedIndex_c,
&id_InputStream_c,
&id_ArchiverKeyword_c,
&id_ArchiverArray_c,
&id_ArchiverValue_c,
&id_ArchiverPair_c,
&id_ArchiverList_c,
&id_ArchiverQuoted_c,
&id_List_any,
&id_ListIndex_any,
&id_List_linked,
&id_ListIndex_linked,
&id_List_mlinks,
&id_ListIndex_mlinks,
&id_ListShuffler_c,
&id_Map_c,
&id_MapIndex_c,
&id_OrderedSet_c,
&id_OrderedSetIndex_c,
&id_OutputStream_c,
&id_Set_c,
&id_SetIndex_c,
&id_PermutationItem_c,
&id_Permutation_c,
&id_String_c,
0};

@class Array_c;
@class ArrayIndex_c;
@class Collection_any;
@class Index_any;
@class PermutedIndex_c;
@class InputStream_c;
@class ArchiverKeyword_c;
@class ArchiverArray_c;
@class ArchiverValue_c;
@class ArchiverPair_c;
@class ArchiverList_c;
@class ArchiverQuoted_c;
@class List_any;
@class ListIndex_any;
@class List_linked;
@class ListIndex_linked;
@class List_mlinks;
@class ListIndex_mlinks;
@class ListShuffler_c;
@class Map_c;
@class MapIndex_c;
@class OrderedSet_c;
@class OrderedSetIndex_c;
@class OutputStream_c;
@class Set_c;
@class SetIndex_c;
@class PermutationItem_c;
@class Permutation_c;
@class String_c;

extern void _collections_implement(void);
extern void _collections_initialize(void);

void *_collections_[]=
{
0,
"collections",
(void *)_collections_implement,
(void *)_collections_initialize,
_collections_types,
_collections_symbols,
_collections_classes,
};


@interface Module_super_
+ self;
@end
@interface Module__collections_ : Module_super_
@end
@implementation Module__collections_
+ initialize
{
// initialize class id constants and link all classes into module
id_Array_c=[Array_c self];
id_ArrayIndex_c=[ArrayIndex_c self];
id_Collection_any=[Collection_any self];
id_Index_any=[Index_any self];
id_PermutedIndex_c=[PermutedIndex_c self];
id_InputStream_c=[InputStream_c self];
id_ArchiverKeyword_c=[ArchiverKeyword_c self];
id_ArchiverArray_c=[ArchiverArray_c self];
id_ArchiverValue_c=[ArchiverValue_c self];
id_ArchiverPair_c=[ArchiverPair_c self];
id_ArchiverList_c=[ArchiverList_c self];
id_ArchiverQuoted_c=[ArchiverQuoted_c self];
id_List_any=[List_any self];
id_ListIndex_any=[ListIndex_any self];
id_List_linked=[List_linked self];
id_ListIndex_linked=[ListIndex_linked self];
id_List_mlinks=[List_mlinks self];
id_ListIndex_mlinks=[ListIndex_mlinks self];
id_ListShuffler_c=[ListShuffler_c self];
id_Map_c=[Map_c self];
id_MapIndex_c=[MapIndex_c self];
id_OrderedSet_c=[OrderedSet_c self];
id_OrderedSetIndex_c=[OrderedSetIndex_c self];
id_OutputStream_c=[OutputStream_c self];
id_Set_c=[Set_c self];
id_SetIndex_c=[SetIndex_c self];
id_PermutationItem_c=[PermutationItem_c self];
id_Permutation_c=[Permutation_c self];
id_String_c=[String_c self];

// return module object
return (id)_collections_;
}
@end
