// Swarm library. Copyright (C) 1996-1997 Santa Fe Institute.
// This library is distributed without any warranty; without even the
// implied warranty of merchantability or fitness for a particular purpose.
// See file LICENSE for details and terms of copying.

/*
Name:         Collection.h
Description:  generic supertype for collections   
Library:      collections
*/

#import <defobj/Create.h>
#import <collections.h>

@interface Collection_any : CreateDrop_s
{
@public
  int             count;     // number of members in collection
  unsigned        bits;      // bit allocations
#define  Bit_ReadOnly              (1 << 0)
#define  Bit_ReplaceOnly           (1 << 1)
#define  Bit_MemberAlloc           (1 << 2)  // Array
#define  Bit_DefaultMember         (1 << 3)  // Array
#define  Bit_IndexFromMemberLoc    (1 << 4)  // List...
#define  Bit_CountSet              (1 << 6)  // Array, during create only
#define  Bit_InitialValueSet       (1 << 7)  // Collection, during create only
#define  IndexFromMemberLoc_Shift  20
#define  IndexFromMemberLoc_Mask   (0xfff << IndexFromMemberLoc_Shift)
#define  IndexFromMemberLoc_Min    -2044
}
/*** methods in Collection_any (inserted from .m file) ***/
- (void) setReplaceOnly: (BOOL)replaceOnly;
- (void) setIndexFromMemberLoc: (long)byteOffset;
- (BOOL) getReadOnly;
- (BOOL) getReplaceOnly;
- (int) getIndexFromMemberLoc;
- (int) getCount;
- (int) count;
- atOffset: (int)offset;
- atOffset: (int)offset put: anObject;
- getFirst;
- first;
- getLast;
- last;
- (BOOL) contains: aMember;
- remove: aMember;
- (void) removeAll;
- (void) deleteAll;
- (void) forEach: (SEL)aSelector;
- (void) forEach: (SEL)aSelector : arg1;
- (void) forEach: (SEL)aSelector : arg1 : arg2;
- (void) forEach: (SEL)aSelector : arg1 : arg2 : arg3;
- (void) describe: outputCharStream;
- (void) xfprint;
- (void) xfprintid;
@end

@interface Index_any : Object_s
{
@public
  Collection_any  *collection;  // base collection on which index created
}
/*** methods in Index_any (inserted from .m file) ***/
- getCollection;
- findNext: anObject;
- findPrev: anObject;
@end
