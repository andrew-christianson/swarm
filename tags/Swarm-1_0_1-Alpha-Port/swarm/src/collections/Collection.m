// Swarm library. Copyright (C) 1996-1997 Santa Fe Institute.
// This library is distributed without any warranty; without even the
// implied warranty of merchantability or fitness for a particular purpose.
// See file LICENSE for details and terms of copying.

/*
Name:         Collection.m
Description:  generic supertype for collections   
Library:      collections
*/

#import <collections/Collection.h>
#import <collections/Set.h>


@implementation Collection_any

PHASE(Creating)

- (void) setReplaceOnly: (BOOL)replaceOnly
{
  setBit( bits, Bit_ReplaceOnly, replaceOnly );
}

- (void) setIndexFromMemberLoc: (long)byteOffset  // belongs elsewhere...
{
  if ( byteOffset > -2044L && byteOffset <= 2048L ) {
    setField( bits, IndexFromMemberLoc_Shift,
              byteOffset - IndexFromMemberLoc_Min );
    bits |= Bit_IndexFromMemberLoc;
  } else {
    raiseEvent( InvalidArgument,
       "> IndexFromMemberLoc must be within range of -2044 to +2048\n"
       "> value specified: %ld\n", byteOffset );
  }
}

PHASE(Using)

- (BOOL) getReadOnly
{
  return bits & Bit_ReadOnly;
}

- (BOOL) getReplaceOnly
{
  return bits & Bit_ReplaceOnly;
}

- (int) getIndexFromMemberLoc
{
  return getField( bits, IndexFromMemberLoc_Shift, IndexFromMemberLoc_Mask ) -
         2044;
}

- (int) getCount
{
  return count;
}

- (int) count
{
  return count;
}

static id indexAtOffset( Collection_any *self, int offset )
{
  id   index;

  if ( offset < 0 || offset >= self->count )
    raiseEvent( OffsetOutOfRange, nil );
  for ( index = [(id)self begin: scratchZone]; offset >= 0; offset-- )
    [index next];
  return index;
}

- atOffset: (int)offset
{
  id index, member;

  index = indexAtOffset( self, offset );
  member = [index get];
  [index drop];
  return member;
}

- atOffset: (int)offset put: anObject
{
  id index, member;

  index = indexAtOffset( self, offset );
  member = [index replace: anObject];
  [index drop];
  return member;
}

- getFirst
{
  return [self atOffset: 0];
}

- first
{
  return [self atOffset: 0];
}

- getLast
{
  return [self atOffset: ( count - 1 )];
}

- last
{
  return [self atOffset: ( count - 1 )];
}

- (BOOL) contains: aMember
{
  id  index, member;

  index = [(id)self begin: scratchZone];
  while ( (member = [index next]) && member != aMember );
  [index drop];
  return member != nil; 
}

- remove: aMember
{
  id  index, member;

  index = [(id)self begin: scratchZone];
  while ( (member = [index next]) && member != aMember );
  if ( member ) [index remove];
  [index drop];
  return member; 
}

- (void) removeAll
{
  id  index;

  index = [(id)self begin: scratchZone];
  while ( [index next] ) [index remove];
  [index drop];
}

- (void) deleteAll
{
  id  index, member;

  index = [(id)self begin: scratchZone];
  while ( (member = [index next]) ) {
    [index remove];
    [member drop];
  }
  [index drop];
}

- (void) forEach: (SEL)aSelector
{
  id       index, member;

  index = [(id)self begin: scratchZone];
  while ( (member = [index next]) ) {
    [member perform: aSelector];
  }
  [index drop];
}

- (void) forEach: (SEL)aSelector : arg1
{
  id       index, member;

  index = [(id)self begin: scratchZone];
  while ( (member = [index next]) ) {
    [member perform: aSelector with: arg1];
  }
  [index drop];
}

- (void) forEach: (SEL)aSelector : arg1 : arg2
{
  id       index, member;

  index = [(id)self begin: scratchZone];
  while ( (member = [index next]) ) {
    [member perform: aSelector with: arg1 with: arg2];
  }
  [index drop];
}

- (void) forEach: (SEL)aSelector : arg1 : arg2 : arg3
{
  id       index, member;

  index = [(id)self begin: scratchZone];
  while ( (member = [index next]) ) {
    [member perform: aSelector with: arg1 with: arg2 with: arg3];
  }
  [index drop];
}

//
// describe: -- standard method to generate debug description object
//
- (void) describe: outputCharStream
{
  char  buffer[100];

  [super describe: outputCharStream];
  sprintf( buffer, "> number of members: %d\n", count );
  [outputCharStream catC: buffer];
}

//
// xfprint -- message to execute xprint on each member of a collection
//
- (void) xfprint
{
  id  index, member;

  index = [(id)self begin: scratchZone];
  while ( (member = [index next]) ) [member xfprint];
  [index drop];
}

//
// xfprintid -- message to execute xid on each member of a collection
//
- (void) xfprintid
{
  id  index, member;

  index = [(id)self begin: scratchZone];
  while ( (member = [index next]) ) [member xprintid];
  [index drop];
}

@end


// Index_any: index for any Collection

@implementation Index_any

- getCollection
{
  return collection;
}

- findNext: anObject
{
  id member;

  while ( [(id)self getLoc] != End ) {
    member = [(id)self next];
    if ( member == anObject ) return member;
  }
  return NULL;
}

- findPrev: anObject
{
  id member;

  while ( [(id)self getLoc] != Start ) {
    member = [(id)self prev];
    if ( member == anObject ) return member;
  }
  return NULL;
}

@end
