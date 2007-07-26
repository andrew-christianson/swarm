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
Name:         DefClass_GNU.h
Description:  class with variables and/or methods defined at runtime 
Library:      defobj
*/

#import <objc/Object.h>
#import <objc/objc-api.h>

typedef struct methodDefs *methodDefs_t;

//
// Class_s -- portion of class object allocated for all created classes 
//
@interface Class_s: Object
{
  @public
    Class_s *superclass;    // object for [super ...] dispatch
    const char *name;       // character string name for class
    long version;           // for archiving (unused)
    unsigned long info;     // class number + info bits
    long instanceSize;      // size of instance in bytes
    void *ivarList;         // compiler-generated list of local ivars
    void *methodList;       // compiler-generated list of local methods
    struct sarray  *dtable; // dispatch table
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
- at: (SEL)aSel addMethod: (IMP)aMethod;
- createEnd;
- (void)lispOutShallow: stream;
@end


// info bit to mark as class created at runtime
#define _CLS_DEFINEDCLASS  0x100

//
// methodDefs -- methods of a class belonging to a named interface
//
struct methodDefs {
  methodDefs_t  next;
  id interfaceID;
  Method_t firstEntry;
  int count;
};

//. vim: syntax=objc
