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
Name:         DefClass.h
Description:  class with variables and/or methods defined at runtime 
Library:      defobj
*/

#import <objc/Object.h>

//
// type declarations
//
typedef struct classData *classData_t;

// include in Class_s for appropriate objc runtime
#ifdef SWARM_OSX
#import "DefClass_OSX.h"
#else
#import "DefClass_GNU.h"
#endif

//
// CreatedClass_s -- class with variables and/or methods defined at runtime 
// Does not conform to Serialization because class changes identity
// at createEnd time.
//

@interface CreatedClass_s (OSX_GNU) // Serialization
/*** methods in CreatedClass_s (inserted from .m file by m2h) ***/
+ createBegin: aZone;
- setName: (const char *)className;
- setClass: (Class)aClass;
- setSuperclass: aClass;
- lispInCreate: expr;
- hdf5InCreate: expr;
- (void)hdf5OutShallow: stream;
@end

//
// _obj_getClassData() -- function to get class data extension structure
//
extern classData_t _obj_getClassData (Class_s *class);

//
// _obj_initMethodInterfaces() -- generate chain of methods by interface
//
void _obj_initMethodInterfaces (Class_s *class);


@interface BehaviorPhase_s: CreatedClass_s
{
  @public
    Class_s *nextPhase; // class which implements next interface
    id filler;          //  pad to size of standard class (for customize)
    id morefiller;
}
/*** methods in BehaviorPhase_s (inserted from .m file by m2h) ***/
- (void)setNextPhase: aBehaviorPhase;
@end

//
// classData -- extension data for compiled class (accessed by class number)
//
struct classData {
  id *classID;                    // external id referring to class
  id owner;                       // module to which class belongs
  id typeImplemented;             // type implemented by class
  BehaviorPhase_s *initialPhase;  // class created for initial phase of type
  id metaobjects;                 // metaobject collections
};

//. vim: syntax=objc
