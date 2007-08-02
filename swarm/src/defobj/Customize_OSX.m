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
Name:         Customize_OSX.m
Description:  superclass to implement create-phase customization
Library:      defobj
*/

#import <defobj/Customize_OSX.h>
#import <defobj/Program.h>
#import <defobj/defalloc.h>
#import <defobj/DefClass.h>
#import <collections.h>
#import <objc/objc-api.h>
#import <misc.h> // strchr, stpcpy, strlen

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
  Method mnext;

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

  // install methods in whichever phase each method belongs
  
  for (mdefs = (methodDefs_t) classData->metaobjects; mdefs; 
       mdefs = mdefs->next)
    {
      if ( mdefs->interfaceID == Creating
           || (mdefs->interfaceID == CreatingOnly &&
               mdefs == (methodDefs_t) classData->metaobjects))
        {
          _obj_addInstanceMethodList(mdefs, classCreating->name);
          _obj_addClassMethodList(mdefs, classCreating->name);
          //[(id) classCreating addInstanceMethodList: mdefs];
          //[(id) classCreating addClassMethodList: mdefs];
        }
      else if (mdefs->interfaceID == Using
               || (mdefs->interfaceID == UsingOnly &&
                   mdefs == (methodDefs_t) classData->metaobjects))
        {
          _obj_addInstanceMethodList(mdefs, classUsing->name);
          _obj_addClassMethodList(mdefs, classUsing->name);
          //[(id) classUsing addInstanceMethodList: mdefs];
          //[(id) classUsing addClassMethodList: mdefs];
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
          _obj_addInstanceMethodList(mdefs, classCreating->name);
          _obj_addClassMethodList(mdefs, classCreating->name);
          _obj_addInstanceMethodList(mdefs, classUsing->name);
          _obj_addClassMethodList(mdefs, classUsing->name);
          //[(id) classUsing addInstanceMethodList: mdefs];
          //[(id) classUsing addClassMethodList: mdefs];
        }
      else
        {
          raiseEvent (SourceMessage,
                      "> setTypeImplemented: invalid phase marker in class %s\n",
                      class->name);
        }        
    }

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

  // finalize created classes and root them in the defining class
  
  if (classCreating)
    {
      classCreating->metaobjects = nil;
      setBit (classCreating->info, _CLS_DEFINEDCLASS, 1);
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
      classUsing->metaobjects = nil;
      setBit (classUsing->info, _CLS_DEFINEDCLASS, 1);
    }
}

@implementation CreateBy_c
@end

//
// Customize_s -- superclass to implement create-phase customization
//
@implementation Customize_s
@end  // end of Create superclass

//
// Create_byboth -- class to create instance by sending message to shallow copy
//

@implementation Create_byboth
- create: aZone
{
  id newObject;

  // Create new instance by sending message to shallow copy.

  newObject = [aZone copyIVars: createReceiver];
  /* TODO: Maybe Swarm bug, assuming Creating class has Using method createEnd */
  //[newObject setNextPhase:
  [newObject performSelector: createMessage withObject: aZone];
  return newObject;

  // (extra zone argument is harmless if not referenced)
}

@end
