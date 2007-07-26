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
Name:         DefClass_GNU.m
Description:  class with variables and/or methods defined at runtime 
Library:      defobj
*/

#import <defobj/DefClass_GNU.h>
#import <objc/sarray.h>

//
// _obj_getClassData() -- function to get class data extension structure
//
classData_t
_obj_getClassData (Class_s *class)
{
  classData_t classData;

  classData = (classData_t)_obj_classes[CLS_GETNUMBER (class) - 1];
  if (!classData)
  {
    classData = _obj_initAlloc (sizeof *classData);
    _obj_classes[CLS_GETNUMBER (class) - 1] = (id) classData;
  }
  return classData;
}

//
// _obj_initMethodInterfaces() -- function to initialize methods by interface
//
void
_obj_initMethodInterfaces (Class_s *class)
{
  classData_t   classData;
  MethodList_t  methods;
  Method_t      mnext;
  int           count;
  id            interfaceID;
  const char    *mname;
  methodDefs_t  mdefs;

  classData = _obj_getClassData (class);
  for (methods = class->methodList; methods; methods = methods->method_next)
    {
      count = 0;
      interfaceID = Using;
      for (mnext = methods->method_list + methods->method_count - 1; ; mnext--)
        {
          if (mnext < methods->method_list
              || strncmp ((mname =
                           (const char *) sel_get_name (mnext->method_name)),
                          "_I_", 3 ) == 0)
            {
              if (count)
                {
                  mdefs = _obj_initAlloc (sizeof *mdefs);
                  mdefs->next = (methodDefs_t)classData->metaobjects;
                  classData->metaobjects = (id)mdefs;
                  mdefs->interfaceID = interfaceID;
                  mdefs->firstEntry = mnext + 1;
                  mdefs->count = count;
                }
              if (mnext < methods->method_list)
                break;
              interfaceID = mnext->method_imp (nil, (SEL)0);
              count = 0;
            }
          else
            count++;
        }
    }
}

//
// Class_s
//
@implementation Class_s
@end

//
// CreatedClass_s -- class with variables and/or methods defined at runtime 
//
@implementation CreatedClass_s

- setDefiningClass: aClass
{
  definingClass = aClass;
  info = ((Class_s *) aClass)->info;
  instanceSize = ((Class_s *) aClass)->instanceSize;
  version = ((Class_s *) aClass)->version;
  ivarList = ((Class_s *) aClass)->ivarList;
  methodList = ((Class_s *) aClass)->methodList;
  return self;
}

- at: (SEL)aSel addMethod: (IMP)aMethod
{
  if (!dtable)
    {
      if (!superclass)
        raiseEvent (InvalidCombination,
                    "must specify superclass before adding methods to a created class\n");
      
      dtable = sarray_lazy_copy (superclass->dtable);
    }
  
  sarray_at_put_safe (dtable, (size_t) aSel->sel_id, aMethod);
  return self;
}

- createEnd
{
  // TODO
  // is it modifying its real underlying structure, or a copy?
  // it is modifying a structure then overlying it over an existing instance
  // i.e. setClass
  if (!dtable)
    dtable = sarray_lazy_copy (superclass->dtable);
  setClass (self, metaobjects);

  metaobjects = nil;
  setBit (info, _CLS_DEFINEDCLASS, 1);
  return self;
}

- (void)lispOutShallow: stream
{
  struct objc_ivar_list *ivars = ((Class_s *) self)->ivarList;
  unsigned i, count = ivars->ivar_count;

  [stream catStartMakeClass: [self name]];
  for (i = 0; i < count; i++)
    {
      [stream catSeparator];
      [stream catKeyword: ivars->ivar_list[i].ivar_name];
      [stream catSeparator];
      [stream catType: ivars->ivar_list[i].ivar_type];
    }
  [stream catEndMakeClass];
}

@end
