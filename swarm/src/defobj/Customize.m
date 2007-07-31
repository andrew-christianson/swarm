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
Name:         Customize.m
Description:  superclass to implement create-phase customization
Library:      defobj
*/

#import <defobj/Customize.h>
#import <defobj/Program.h>
#import <defobj/defalloc.h>
#import <defobj/DefClass.h>
#import <collections.h>
#import <objc/objc-api.h>
#import <misc.h> // strchr, stpcpy, strlen

extern void _obj_splitPhases (Class_s  *class);

extern id _obj_initZone;  // currently receives generated classes
//
// inline functions to save field in copy of class structure used as wrapper
//

static inline CreateBy_c *
getWrapperCreateBy (Class wrapper)
{
  return (CreateBy_c *) wrapper->version;
}

//
// inline functions to save field in copy of class structure used as wrapper
//
static inline void
setWrapperCreateBy (Class wrapper, CreateBy_c *createBy)
{
  #if SWARM_OSX
    //. Another do-nothing call.
  #else
    wrapper->version = (long) createBy;
  #endif
}

//
// initCustomizeWrapper -- common routine to set up customize wrapper
//
static void
initCustomizeWrapper (id aZone, id anObject)
{
  Class wrapper;
  CreateBy_c *createBy;

  // allocate wrapper class (copy of self class) for instance being customized

  wrapper = (Class) [aZone copyIVars: getClass (anObject)];
  wrapper->super_class = anObject->isa->super_class; //OSX Specific

#if SWARM_OSX
  wrapper->super_class = anObject->isa->super_class;
#endif
  wrapper->info |= _CLS_CUSTOMIZEWRAPPER;


  // allocate a new CreateBy instance and store id in wrapper

  createBy = (CreateBy_c *) [aZone allocIVars: [CreateBy_c self]];
  setMappedAlloc (createBy);
  setWrapperCreateBy (wrapper, createBy);

  // save original self class in CreateBy object until customizeEnd

  createBy->createReceiver = (id) getClass (anObject);  // save original class

  // save zone in CreateBy object until customizeEnd

  createBy->recustomize = aZone;

  // reset self class to point to the wrapper

  setClass (anObject, wrapper);
}

//
// Customize_s -- superclass to implement create-phase customization
//
@implementation Customize_s (OSX_GNU)

PHASE(Creating)

+ createBegin: aZone
{
  [self subclassResponsibility: @selector(createBegin:)];
  return nil; 
}


//
// customizeBegin: -- begin customization to define future create
//
+ customizeBegin: aZone
{
  id newObject;

  // allocate object at initial location using createBegin

  newObject = [self createBegin: [aZone getComponentZone]];

  // wrap instance for customization and return allocated object

  initCustomizeWrapper (aZone, newObject);
  return newObject;
}

//
// customizeEnd -- finalize a customization to define future create
//
- customizeEnd
{
  CreateBy_c *createBy;
  Class wrapper, selfClass;

  // check that customization in progress

  if (!_obj_customize (self))
    raiseEvent (CreateUsage,
                "> class %s: customizeEnd may only follow customizeBegin\n",
                [[self getClass] getName]);
  
  // get information from self before any possible changes by createEnd
  
  wrapper = getClass (self);
  createBy = getWrapperCreateBy (wrapper);
  selfClass = createBy->createReceiver;
  
  // execute createEnd to set subclass to handle future create
  
  [(id) self createEnd];  // rely on createEnd to set createBy action
  
  // check that a create selection was made 
  
  if ([getClass (createBy) superclass] != [CreateBy_c self])
    {
      raiseEvent (CreateSubclassing,
                  "> class %s: createEnd did not select a createBy action when called by\n"
                  "> customizeEnd to save a customization\n",
                  [selfClass getName]);
    }
  
  // free self if not retained and not required by CreateBy_c object
  
  if ((getClass (createBy) == [Create_bycopy self]
       || getClass (createBy) == [Create_byboth self])
      && createBy->createReceiver != self
      && (wrapper->info & _CLS_RETAINSELF))
    {
      memset (self, 0, wrapper->instance_size);    // wipe out all content
      [createBy->recustomize freeIVars: self];  // free from saved zone
      // !! should use [self dropFrom: createBy->recustomize] ??
    }
  // else keep self but reset class pointer if still pointing to wrapper
  else if (getClass (self) == wrapper)
    setClass (self, selfClass);
  
  // check for valid message selector and cache method for receiver  
  if (createBy->createMessage)
    {
      createBy->createMethod =
        getMethodFor (getClass (createBy->createReceiver),
                      createBy->createMessage);
      if (!respondsTo (createBy->createReceiver, createBy->createMessage))
        raiseEvent (CreateSubclassing,
                    "> class %s, setCreateByMessage: or setCreateByMessage:to:\n"
                    "> receiver object: %0#8x: %.64s\n"
                    "> message selector name: \"%s\"\n"
                    "> message selector not valid for receiver\n",
                    [[self getClass] getName],
                    createBy->createReceiver,
                    getClass (createBy->createReceiver)->name,
                    sel_get_name (createBy->createMessage));
    }
  
  // free wrapper class
  
  [createBy->recustomize freeIVars: wrapper];

  // reset recustomize field where zone was stored and return customization
  // (Subclass can reset recustomize field after default is set.)
  
  createBy->recustomize = nil;
  return createBy;
}

//
// customizeCopy: -- copy an object being customized to define future create
//
- customizeCopy: aZone
{
  CreateBy_c *createBy;
  id newObject;

  // check that customization in progress

  if (_obj_customize (self))
    raiseEvent (CreateUsage,
                "> class %s: customizeCopy must follow customizeBegin\n",
                [[self getClass] getName]);
  
  // make shallow copy of self with original class restored
  
  createBy = getWrapperCreateBy (getClass (self));
  newObject = [aZone copyIVars: self];
  setClass (newObject, createBy->createReceiver);
  
  // save zone in new wrapper
  
  initCustomizeWrapper (aZone, newObject);
  createBy = getWrapperCreateBy (getClass (newObject));
  createBy->recustomize = aZone;
  return newObject;
}

//
// customizeBeginEnd: -- customize to defaults but with recustomization enabled
//
+ customizeBeginEnd: aZone
{
  id newObject;
  CreateBy_c *createBy;

  newObject = [self customizeBegin: aZone];
  createBy = (CreateBy_c *) [newObject customizeEnd];
  createBy->recustomize = self;
  return createBy;
}

//
// _setCreateBy_: common routine used by setCreateBy_c methods below
//
- _setCreateBy_: (Class)subclass message: (SEL)messageSelector to: anObject
{
  Class wrapper;
  CreateBy_c *createBy;

  // check that customization in progress

  if (!_obj_customize (self))
    raiseEvent (CreateUsage,
                "> class %s: customizeEnd must follow customizeBegin\n"
                "> (If classes coded properly, error raised by a createBy... macro\n"
                "> in a createEnd method.)\n", 
                [[self getClass] getName]);
  
  // install subclass as class of CreateBy instance
  
  wrapper  = getClass (self);
  createBy = getWrapperCreateBy (wrapper);
  setClass (createBy, subclass);
  
  // if requested, set values for message send in create data block
  
  if (messageSelector)
    {
      createBy->createReceiver = anObject;
      createBy->createMessage = messageSelector;
    }
  return createBy; 
}

//
// _setCreateByCopy_ -- create by shallow copy of self
//
- (void)_setCreateByCopy_
{
  CreateBy_c *createBy;

  // start with standard checks 

  createBy = (CreateBy_c *)
    [self _setCreateBy_: [Create_bycopy self] message: (SEL)NULL to: nil];
  
  // set values for shallow copy in create data block
  
  createBy->createReceiver = self;
}

//
// _setCreateByMessage_:to: -- create by message to object
//
- (void)_setCreateByMessage_: (SEL)messageSelector to: anObject
{
  CreateBy_c *createBy;
  const char *messageName;
  
  // install wrapper class
  
  createBy = (CreateBy_c *) [self _setCreateBy_: [Create_bysend self]
                                  message: messageSelector
                                  to: anObject];
  
  // confirm valid message selector and return customization wrapper class
  
  messageName = (const char *) sel_get_name (messageSelector);
  if (!messageName
      || !strchr (messageName, ':')
      || ((unsigned)(strchr (messageName, ':') - messageName)
	  != strlen (messageName) - 1))
    raiseEvent (CreateSubclassing,
                "> class %s: setCreateByMessage:to: message selector name: \"%s\"\n"
                "> message selector must accept one argument (for create zone)\n",
                [[self getClass] getName]);
}

//
// _setCreateByMessage_:toCopy: -- create by message to shallow copy
//
- (void) _setCreateByMessage_: (SEL)messageSelector toCopy: anObject
{
  CreateBy_c *createBy;
  const char *messageName;

  // install subclass as wrapper

  createBy = (CreateBy_c *) [self _setCreateBy_: [Create_byboth self]
                                  message: (SEL)messageSelector
                                  to: anObject];

  // confirm valid message selector and return customization wrapper class

  messageName = (const char *) sel_get_name( messageSelector );
  if (!messageName ||
      (strchr (messageName, ':')
       && ((unsigned)(strchr (messageName, ':') - messageName)
	   != strlen (messageName) - 1)))
    raiseEvent (CreateSubclassing,
                "> class %s: setCreateByMessage:to: message selector name: \"%s\"\n"
                "> message selector must accept at most one argument\n",
                [[self getClass] getName]);
}

//
// _setRecustomize_: -- set receiver for any more customize/createBegin messages
//
- (void)_setRecustomize_: anObject
{
  Class wrapper;
  CreateBy_c *createBy;

  if (!respondsTo (anObject, M(createBegin:)))
    raiseEvent (InvalidArgument,
                "> setRecustomize receiver argument does not respond to createBegin:\n");
  
  // install subclass as class of CreateBy instance
  
  wrapper  = getClass (self);
  createBy = getWrapperCreateBy (wrapper);
  createBy->recustomize = anObject;
}

//
// setTypeImplemented: -- implement type using split-phase classes
//
+ (void)setTypeImplemented: aType
{
  [super setTypeImplemented: aType];
  _obj_splitPhases ((Class_s *) self);
}

@end  // end of Create superclass


//
// CreateBy_c -- superclass of customized create action
//

@implementation CreateBy_c (OSX_GNU)

- createBegin: aZone
{
  // send message to recustomization class, if any

  if (!recustomize)
    raiseEvent (CreateUsage,
                "> class %s: createBegin not supported after customization already\n"
                "> completed a first time by customizeBegin/End\n",
                [[self getClass] getName]);
  
  return [recustomize createBegin: aZone];
}

- customizeBegin: aZone
{
  // send message to recustomization class, if any
  
  if (!recustomize)
    raiseEvent (CreateUsage,
                "> class %s: customizeBegin not supported after customization already\n"
                "> completed a first time by customizeBegin/End\n",
                [[self getClass] getName]);
  
  return [recustomize customizeBegin: aZone];
}

//
// mapAllocations: -- standard method to map internal allocations
//
- (void)mapAllocations: (mapalloc_t)mapalloc
{
  mapObject (mapalloc, createReceiver);
}

@end

//
// Create_bycopy -- class to create instance by making a shallow copy
//

@implementation Create_bycopy

- create: aZone
{
  // Create new instance by copying previously customized instance.

  return [aZone copyIVars: createReceiver];
}

@end

//
// Create_bysend -- class to create instance by sending a message to an object
//

@implementation Create_bysend

- create: aZone
{

  // Create new instance by sending message to receiver.

  return [createReceiver perform: createMessage with: aZone];
  // return createMethod (createReceiver, createMessage, aZone);
}

@end


//
// Create_byboth -- class to create instance by sending message to shallow copy
//
@implementation Create_byboth (OSX_GNU)
@end

//
// _obj_customize() -- return true if customization in progress
//
BOOL
_obj_customize (id anObject)
{
  return (getClass (anObject)->info & _CLS_CUSTOMIZEWRAPPER) != 0;
}

//
// compiled versions of extern inline functions
//

//
// getNextPhase() -- return class which implements next phase of object
//
Class
getNextPhase (id aClass)
{
  return (Class) ((BehaviorPhase_s *) aClass)->nextPhase;
}

//
// setNextPhase() -- change behavior of object to next succeeding phase
//
void
setNextPhase (id anObject)
{
  *(Class *) anObject = (Class) (*(BehaviorPhase_s **) anObject)->nextPhase;
}
