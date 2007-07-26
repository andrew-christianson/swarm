// Swarm library. Copyright © 1996-2000 Swarm Development Group.
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful, but
// WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
// General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
// USA
// 
// The Swarm Development Group can be reached via our website at:
// http://www.swarm.org/

/*
Name:         DefObject_OSX.h
Description:  top-level superclass to provide standard services
Library:      defobj
*/

#define DEFINE_CLASSES
#import "defobj.h"
#include "swarmconfig.h" // PTRUINT

@class ObjectEntry;

/******************************************************************************/
// macros for accessing bits at defined locations inside instance variables
#define getBit(word, bit) ((word) & bit)

#define setBit(word, bit, value)((value) \
 ? ((word) |= (PTRUINT) bit) \
 : ((word) &= ~((PTRUINT) bit)))
//((value) \
 ? ((word) |= bit) \
 : ((word) &= ~ bit))

#define setField(word, shift, value) (word) |= ((value) << shift)

#define getField(word, shift, mask) ((PTRUINT) ((word) & mask) >> shift)

// callMethodInClass() -- macro for method lookup in an alternate superclass
// This macro is similar to the macro CALL_METHOD_IN_CLASS in
// GNU libobjects-0.1.19/src/behavior.h, by Andrew McCallum.
// TODO: direct method call
// TODO: Need to lookup instance method, get the method imp and call it
#define callMethodInClass(aClass, aMessage, args...) \
  ({ Method aMethod= class_getInstanceMethod(aClass, (SEL)aMessage); \
     aMethod->method_imp (self, aMethod->method_imp , ## args); })

// getClass() -- macro to get class of instance
#define getClass(anObject) (*(Class *)(anObject))

// setClass() -- macro to set behavior of instance to compatible class
#define setClass(anObject, aClass) (*(Class *)(anObject) = (Class)(aClass))
/******************************************************************************/

#ifdef INHERIT_OBJECT
@interface Object_s: NSObject <DefinedClass, Serialization, GetName>
{
@public
  /* TODO: Memory */
  // if an Object_s is allocated which is actually a class structure
  // then enough filler must be in place so that the class structure
  // is complete and usable by the Apple ObjC runtime.  e.g. zbits
  // below was in the super_class field and Apple needs to use that
  // field for sending messages.
  struct objc_class _filler;
  // Word that contains zone in which object allocated, plus
  // additional bits about the memory allocations for the object.
  PTRUINT zbits;
  ObjectEntry *foreignEntry;
}
#else
@interface Object_s <DefinedClass, Serialization, GetName>
{
@public
   // Class that implements the behavior of an object
   Class isa;
   // Word that contains zone in which object allocated, plus
   // additional bits about the object.
   PTRUINT zbits;
   ObjectEntry *entry;
}
#endif
/*** methods in Object_s (inserted from .m file by m2h) ***/
+ (BOOL)conformsTo: (Protocol *)aProtocol;
+ (IMP)getMethodFor: (SEL)aSel;
#if 0 
//TODO...
- perform: (SEL)aSel;
- perform: (SEL)aSel with: anObject1;
- perform: (SEL)aSel with: anObject1 with: anObject2;
- perform: (SEL)aSel with: anObject1 with: anObject2 with: anObject3;
- forward: (SEL)aSel : (marg_list)argFrame;
#endif
- (void)lispOutVars: stream deep: (BOOL)deepFlag;
- (void)hdf5OutDeep: hdf5obj;
- (void)hdf5OutShallow: hdf5obj;
#if 0
- (NSMethodSignature*) methodSignatureForSelector: (SEL)aSelector;
- (void) forwardInvocation: (NSInvocation*)anInvocation;
#endif
@end

//
// respondsTo() -- function to test if object responds to message  
//
extern BOOL respondsTo (id anObject, SEL aSel);

//
// getMethodFor() --
//   function to look up the method that implements a message for an object
//
extern IMP getMethodFor (Class aClass, SEL aSel);

//. vim: syntax=objc
