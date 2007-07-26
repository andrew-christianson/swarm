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
Name:         DefClass_OSX.h
Description:  class with variables and/or methods defined at runtime 
Library:      defobj
*/

#import <objc/Object.h>
#import <objc/objc-runtime.h>

typedef struct methodDefs *methodDefs_t;

//
// Class_s -- portion of class object allocated for all created classes 
//
@interface Class_s: Object
{
  @public
    struct objc_class *superclass;	
    const char *name;		
    long version;
    long info;
    long instanceSize;
    struct objc_ivar_list *ivars;
    struct objc_method_list **methodLists;
    struct objc_cache *cache;
    struct objc_protocol_list *protocols;
    Class classPointer;
}

/*** methods in Class_s (inserted from .m file by m2h) ***/
@end

@interface CreatedClass_s: Class_s // Serialization
{
  @public
    Class_s *definingClass; // compiled class defining ivar structure
    id metaobjects;
}
- setDefiningClass: aClass;
- (void)addInstanceMethodList: (methodDefs_t)methodDefs;
- (void)addClassMethodList: (methodDefs_t)methodDefs;
- at: (SEL)aSel addMethod: (IMP)aMethod withTypes: (const char *)theTypes;
- at: (SEL)aSel addMethod: (IMP)aMethod;
- createEnd;
- (void)lispOutShallow: stream;
@end

//
// _obj_printMethods() -- function to print instance and class methods for a class
//
void _obj_printMethods(char *className);

//
// _obj_createClass() -- function to add new class to Mac OSX ObjC runtime
//
void _obj_createClass(Class_s *aClass);

void _obj_addInstanceMethodList(methodDefs_t methodDefs, char *name);

void _obj_addClassMethodList(methodDefs_t methodDefs, char *name);

// info bit to mark as class created at runtime
#define _CLS_DEFINEDCLASS  0x400

#ifndef HOST_BITS_PER_LONG
#define HOST_BITS_PER_LONG  (sizeof(long)*8)
#endif 

#define __SWARMCLS_VERSION(cls) ((cls)->version)
#define __SWARMCLS_SETVERSION(cls, mask) (__SWARMCLS_VERSION(cls) |= mask)

#define SWARMCLS_GETNUMBER(cls) (__SWARMCLS_VERSION(cls) >> (HOST_BITS_PER_LONG/2))
#define SWARMCLS_SETNUMBER(cls, num) \
  ({ (cls)->version <<= (HOST_BITS_PER_LONG/2); \
     (cls)->version >>= (HOST_BITS_PER_LONG/2); \
     __SWARMCLS_SETVERSION(cls, (((unsigned long)num) << (HOST_BITS_PER_LONG/2))); })

//
// methodDefs -- methods of a class belonging to a named interface
//
struct methodDefs {
  methodDefs_t  next;
  id interfaceID;
  Method firstEntry;
  int count;
  Method firstClassEntry;
  int classCount;
};

//. vim: syntax=objc
