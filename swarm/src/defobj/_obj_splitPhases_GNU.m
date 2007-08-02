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
Name:         _obj_splitPhases_GNU.m
Description:
Library:      defobj
*/

#import <defobj/_obj_splitPhases.h>
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
  Method_t mnext;

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
  
  // install methods in whichever phase each method belongs
  
  for (mdefs = (methodDefs_t) classData->metaobjects; mdefs; 
       mdefs = mdefs->next)
    {
      if ( mdefs->interfaceID == Creating
           || (mdefs->interfaceID == CreatingOnly &&
               mdefs == (methodDefs_t) classData->metaobjects))
        {
          for (mnext = mdefs->firstEntry;
               mnext < mdefs->firstEntry + mdefs->count; mnext++)
            [(id) classCreating at: mnext->method_name addMethod: mnext->method_imp];
        }
      else if (mdefs->interfaceID == Using
               || (mdefs->interfaceID == UsingOnly &&
                   mdefs == (methodDefs_t) classData->metaobjects))
        {
          for (mnext = mdefs->firstEntry;
               mnext < mdefs->firstEntry + mdefs->count; mnext++)
            [(id) classUsing at: mnext->method_name addMethod: mnext->method_imp];
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
          for (mnext = mdefs->firstEntry;
               mnext < mdefs->firstEntry + mdefs->count; mnext++)
            {
              [(id) classCreating at: mnext->method_name addMethod: mnext->method_imp];
              [(id) classUsing    at: mnext->method_name addMethod: mnext->method_imp];
            }
        }
      else
        {
          raiseEvent (SourceMessage,
                      "> setTypeImplemented: invalid phase marker in class %s\n",
                      class->name);
        }        
    }

  // finalize created classes and root them in the defining class
  
  if (classCreating)
    {
      classCreating = [(id) classCreating createEnd];
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
      classUsing = [(id) classUsing createEnd];
      if (classData->classID)
        *classData->classID = classUsing;
    }
  else if (classData->classID)
    *classData->classID = classCreating;
}
