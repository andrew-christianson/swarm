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
Name:         Customize.h
Description:  superclass impleemntation of create-phase customization
Library:      defobj
*/

#import "DefClass.h" // BehaviorPhase_s
#import "DefObject.h"

//
// specific defined interfaces
//
externvar id Creating, Setting, Using, CreatingOnly, UsingOnly;

//
// interface marker for methods in class which implement an interface of a type
//
#define PHASE(phase_name) \
-(id)_I_##phase_name { return phase_name; } \
+(id)_C_##phase_name { return phase_name; }

//
// createByCopy, createByMessageTo, createByMessageToCopy, retainSelf --
//   macros to set future create action for current customization
//

// extended class info bits (bit masks for class->info) used by cust. wrapper

#define _CLS_CUSTOMIZEWRAPPER 0x200  // class created by customizeBegin
#define _CLS_RETAINSELF 0x300        // retain self even if unref by createBy

//
// _obj_customize() -- return true if customization in progress
//
extern inline BOOL
_obj_customize (id anObject)
{
  return (getClass (anObject)->info & _CLS_CUSTOMIZEWRAPPER) != 0;
}

#define createByCopy() \
(_obj_customize (self) ? ([(id) self _setCreateByCopy_], YES) : NO)

#define createByMessageTo(anObject, messageName) \
(_obj_customize (self) ? \
 ([(id) self _setCreateByMessage_ : @selector(messageName) to: (anObject)], YES) : NO)

#define createByMessageToCopy(anObject, messageName) \
(_obj_customize (self) ? \
([(id) self _setCreateByMessage_: @selector(messageName) toCopy: (anObject)], YES) : NO)

#define setRetainSelf() \
if (_obj_customize (self)) self->class_pointer->info |= _CLS_RETAINSELF

#define setRecustomize(recustomizeReceiver) \
if (_obj_customize(self)) [self _setRecustomize_: recustomizeReceiver]

//
// objects to save createBy actions generated customizeBegin/End
//
/*
@interface CreateBy_c: Object_s
//. FIXME: Would rather use this block, but had to move this over to the
//. FIXME: _GNU and _OSX splits.  Can this be fixed (as to not repeat 
//. FIXME: code?)
{
@public
  id implementedType; // type of object created by CreateBy object
  id createReceiver;  // receiver for message
  SEL createMessage;  // selector from setCreateMessage:, or nil
  IMP createMethod;   // cached method for createMessage selector
  id recustomize;     // object to handle further create, if any
}
@end
*/

//
// initCustomizeWrapper -- common routine to set up customize wrapper
//
static void initCustomizeWrapper (id aZone, id anObject);

//
// getNextPhase() -- return class which implements next phase of object
//
extern inline Class
getNextPhase (id aClass)
{
  return (Class) ((BehaviorPhase_s *) aClass)->nextPhase;
}

//
// setNextPhase() -- change behavior of object to next defined phase
//
extern inline void
setNextPhase (id anObject)
{
  *(Class *) anObject = (Class) (*(BehaviorPhase_s **) anObject)->nextPhase;
}

//XXX static void initCustomizeWrapper (id aZone, id anObject);
#ifdef SWARM_OSX
#import <defobj/Customize_OSX.h>
#else
#import <defobj/Customize_GNU.h>
#endif

//. FIXME: See above FIXMEs
@interface CreateBy_c (OSX_GNU)
- createBegin: aZone;
- customizeBegin: aZone;
- (void)mapAllocations: (mapalloc_t)mapalloc;
@end

static inline void setWrapperCreateBy (Class wrapper, CreateBy_c *createBy);

@interface Create_bycopy: CreateBy_c
- create: aZone;
@end

@interface Create_bysend: CreateBy_c
- create: aZone;
@end

//
// Create_byboth -- class to create instance by sending message to shallow copy
//
@interface Create_byboth (OSX_GNU)
@end

//
// Customize_s -- superclass impleemntation of create-phase customization
//
@interface Customize_s (OSX_GNU)
+ createBegin: aZone;
+ customizeBegin: aZone;
- customizeEnd;
- customizeCopy: aZone;
+ customizeBeginEnd: aZone;
- _setCreateBy_: (Class)subclass message: (SEL)messageSelector to: anObject;
- (void)_setCreateByCopy_;
- (void)_setCreateByMessage_: (SEL)messageSelector to: anObject;
- (void)_setCreateByMessage_: (SEL)messageSelector toCopy: anObject;
- (void)_setRecustomize_: anObject;
+ (void)setTypeImplemented: aType;
@end


//. vim: syntax=objc
