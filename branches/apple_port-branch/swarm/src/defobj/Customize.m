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

#include <misc.h> // strchr, stpcpy, strlen

extern void _obj_splitPhases (Class_s  *class);

extern id _obj_initZone;  // currently receives generated classes

//
// inline functions to save field in copy of class structure used as wrapper
//

static inline void
setWrapperCreateBy (Class wrapper, CreateBy_c *createBy)
{
//#if !SWARM_OSX
  wrapper->version = (long) createBy;
//#endif
}

static inline CreateBy_c *
getWrapperCreateBy (Class wrapper)
{
  return (CreateBy_c *) wrapper->version;
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

@implementation Customize_s

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

//
// _obj_splitPhases -- split defining class into class object for each phase
//
void
_obj_splitPhases (Class_s *class)
{
  classData_t classData, superclassData = 0;
  BehaviorPhase_s *classCreating, *classUsing;
  char *classNameBuf;
  methodDefs_t mdefs;
#if SWARM_OSX /* DONE */
  Method mnext;
#else
  Method_t mnext;
#endif

  // return if classes have already been created
  classData = _obj_getClassData (class);
  if (classData->initialPhase)
    return;
  
  // split classes for superclass if not done already
  if ((id) class != id_Customize_s)
    {
      superclassData = _obj_getClassData (class->superclass);
      if (!superclassData->initialPhase)
        _obj_splitPhases (class->superclass);
    }
  
  // generate chain of contiguous methods by interface
  _obj_initMethodInterfaces (class);  // (creates temporary chain of
                                      // defs in classData->metaobjects)

  // create class for methods in Creating phase
  classCreating = nil;
  if (!(classData->metaobjects
        && ((methodDefs_t) classData->metaobjects)->interfaceID == UsingOnly))
    {
      classCreating = [id_BehaviorPhase_s createBegin: _obj_initZone];
      
      classNameBuf = _obj_initAlloc (strlen (class->name) + 10);
      stpcpy (stpcpy (classNameBuf, class->name), ".Creating");
      printf("Alloc %s (%p)\n", classNameBuf, classCreating);
      
      [(id) classCreating setName: classNameBuf];
      [(id) classCreating setClass: getClass (class)];
      [(id) classCreating setDefiningClass: class];
    }
  
  // create class for methods in Using phase
  classUsing = nil;
  if (!(classData->metaobjects
        && (((methodDefs_t) classData->metaobjects)->interfaceID ==
            CreatingOnly)))
    {
      classUsing = [id_BehaviorPhase_s createBegin: _obj_initZone];
      
      classNameBuf = _obj_initAlloc (strlen (class->name) + 7);
      stpcpy (stpcpy (classNameBuf, class->name), ".Using");
      printf("Alloc %s (%p)\n", classNameBuf, classUsing);

      [(id) classUsing setName: classNameBuf];
      //[(id) classUsing setName: class->name];
      [(id) classUsing setClass: getClass (id_Object_s)];
      [(id) classUsing setDefiningClass: class];
    }
  
  if (class == id_Customize_s)
    {
      if (classCreating)
        [(id) classCreating setSuperclass: id_Object_s];
      if (classUsing)
        [(id) classUsing setSuperclass: id_Object_s];
      
    }
  else
    {
      if (classCreating)
        {
          if (superclassData->initialPhase->nextPhase == UsingOnly)
            {
              do {
                superclassData = 
                  _obj_getClassData (superclassData->initialPhase->superclass);
              }
              while (superclassData->initialPhase->nextPhase == UsingOnly);
              
              [(id) classCreating setSuperclass: superclassData->initialPhase];
              superclassData = _obj_getClassData (class->superclass);
            }
          else
            [(id) classCreating setSuperclass: superclassData->initialPhase];
        }
      if (classUsing)
        {
          if (superclassData->initialPhase->nextPhase == CreatingOnly)
            do {
              superclassData =
                _obj_getClassData (superclassData->initialPhase->superclass);
            }
            while (superclassData->initialPhase->nextPhase == CreatingOnly);
          
          if (superclassData->initialPhase->nextPhase == UsingOnly)
            [(id) classUsing setSuperclass: superclassData->initialPhase];
          else
            [(id) classUsing setSuperclass: superclassData->initialPhase->nextPhase];
        }
    }
  
#if SWARM_OSX
    // Add the Creating and Using classes to the ObjC runtime
    if (classCreating) {
        Class c;        

        // check superclass
        if (c = (Class)objc_lookUpClass(classCreating->superclass->name))
            printf("Found superclass (%s, %p) in objc runtime\n", c->name, c);
        else
            printf("Not Found superclass (%s)\n", classCreating->superclass->name);

        // add the class to the next runtime?
        if (c = (Class)objc_lookUpClass(classCreating->name))
            printf("Found (%s, %p) in objc runtime\n", c->name, c);
        else
            printf("Not Found (%s)\n", classCreating->name);

        //objc_addClass((Class)classCreating);
        _obj_createClass(classCreating);
        //classCreating->classPointer = objc_lookUpClass(classCreating->name);
        //[(id) classCreating setClass: objc_lookUpClass(classCreating->name)];
        if (c = (Class)objc_lookUpClass("Customize_s"))
            printf("Found (%s, %p) in objc runtime\n", c->name, c);
        else
            printf("Not Found\n");
        if (c = (Class)objc_lookUpClass(classCreating->name))
            printf("Found (%s, %p) in objc runtime\n", c->name, c);
        else
            printf("Not Found\n");
    }
    if (classUsing) {
        Class c;
        // add the class to the next runtime?
        if (c = (Class)objc_lookUpClass(classUsing->name))
            printf("Found (%s, %p) in objc runtime\n", c->name, c);
        else
            printf("Not Found (%s)\n", classUsing->name);
        _obj_createClass(classUsing);
        //classUsing->classPointer = objc_lookUpClass(classUsing->name);
        //[(id) classUsing setClass: objc_lookUpClass(classUsing->name)];
        if (c = (Class)objc_lookUpClass(classUsing->name))
            printf("Found (%s, %p) in objc runtime\n", c->name, c);
        else
            printf("Not Found\n");
    }
#endif

#if SWARM_OSX
  if (classCreating) {
    printf("_obj_splitPhases (before): classCreating\n");
    _obj_printMethods(classCreating->name);
  } else {
    printf("_obj_splitPhases (before): NO classCreating\n");
  }
  if (classUsing) {
    printf("_obj_splitPhases (before): classUsing\n");
    _obj_printMethods(classUsing->name);
  } else {
    printf("_obj_splitPhases (before): NO classUsing\n");
  }
#endif

  // install methods in whichever phase each method belongs
  
  for (mdefs = (methodDefs_t) classData->metaobjects; mdefs; 
       mdefs = mdefs->next)
    {
      if ( mdefs->interfaceID == Creating
           || (mdefs->interfaceID == CreatingOnly &&
               mdefs == (methodDefs_t) classData->metaobjects))
        {
#if SWARM_OSX
          _obj_addInstanceMethodList(mdefs, classCreating->name);
          _obj_addClassMethodList(mdefs, classCreating->name);
          //[(id) classCreating addInstanceMethodList: mdefs];
          //[(id) classCreating addClassMethodList: mdefs];
#else
          for (mnext = mdefs->firstEntry;
               mnext < mdefs->firstEntry + mdefs->count; mnext++)
            [(id) classCreating at: mnext->method_name addMethod: mnext->method_imp];
#endif          
        }
      else if (mdefs->interfaceID == Using
               || (mdefs->interfaceID == UsingOnly &&
                   mdefs == (methodDefs_t) classData->metaobjects))
        {
#if SWARM_OSX
          _obj_addInstanceMethodList(mdefs, classUsing->name);
          _obj_addClassMethodList(mdefs, classUsing->name);
          //[(id) classUsing addInstanceMethodList: mdefs];
          //[(id) classUsing addClassMethodList: mdefs];
#else
          for (mnext = mdefs->firstEntry;
               mnext < mdefs->firstEntry + mdefs->count; mnext++)
            [(id) classUsing at: mnext->method_name addMethod: mnext->method_imp];
#endif          
        }
      else if (mdefs->interfaceID == CreatingOnly ||
               mdefs->interfaceID == UsingOnly)
        {
          raiseEvent (SourceMessage,
                      "> setTypeImplemented: class %s: cannot specify any other phase\n"
                      "> in combination with CreatingOnly or UsingOnly\n");
          
        }
      else if (mdefs->interfaceID == Setting)
        {
#if SWARM_OSX
          _obj_addInstanceMethodList(mdefs, classCreating->name);
          _obj_addClassMethodList(mdefs, classCreating->name);
          _obj_addInstanceMethodList(mdefs, classUsing->name);
          _obj_addClassMethodList(mdefs, classUsing->name);
          //[(id) classUsing addInstanceMethodList: mdefs];
          //[(id) classUsing addClassMethodList: mdefs];
#else
          for (mnext = mdefs->firstEntry;
               mnext < mdefs->firstEntry + mdefs->count; mnext++)
            {
              [(id) classCreating at: mnext->method_name addMethod: mnext->method_imp];
              [(id) classUsing    at: mnext->method_name addMethod: mnext->method_imp];
            }
#endif          
        }
      else
        {
          raiseEvent (SourceMessage,
                      "> setTypeImplemented: invalid phase marker in class %s\n",
                      class->name);
        }        
    }

#if SWARM_OSX
  if (classCreating) {
    printf("_obj_splitPhases (after): classCreating\n");
    _obj_printMethods(classCreating->name);
  } else {
    printf("_obj_splitPhases (after): NO classCreating\n");
  }
  if (classUsing) {
    printf("_obj_splitPhases (after): classUsing\n");
    _obj_printMethods(classUsing->name);
  } else {
    printf("_obj_splitPhases (after): NO classUsing\n");
  }
#endif

  // finalize created classes and root them in the defining class
  
  if (classCreating)
    {
#if SWARM_OSX
      classCreating->metaobjects = nil;
      setBit (classCreating->info, _CLS_DEFINEDCLASS, 1);
#else
      classCreating = [(id) classCreating createEnd];
#endif
      classCreating->nextPhase = classUsing ? classUsing : CreatingOnly;
      classData->initialPhase  = classCreating;
    }
  else
    {
      classData->initialPhase = classUsing;
      classUsing->nextPhase = UsingOnly;
    }
  if (classUsing)
    {
#if SWARM_OSX
      classUsing->metaobjects = nil;
      setBit (classUsing->info, _CLS_DEFINEDCLASS, 1);
    }
#else
      classUsing = [(id) classUsing createEnd];
      if (classData->classID)
        *classData->classID = classUsing;
    }
  else if (classData->classID)
    *classData->classID = classCreating;
#endif
}

@end  // end of Create superclass


//
// CreateBy_c -- superclass of customized create action
//

@implementation CreateBy_c

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

@implementation Create_byboth

- create: aZone
{
  id newObject;

  // Create new instance by sending message to shallow copy.

  newObject = [aZone copyIVars: createReceiver];
#if SWARM_OSX /* TODO: Maybe Swarm bug, assuming Creating class has Using method createEnd */
  //[newObject setNextPhase:
  [newObject performSelector: createMessage withObject: aZone];
#else
  [newObject perform: createMessage with: aZone];
#endif
  return newObject;

  // (extra zone argument is harmless if not referenced)
}

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
