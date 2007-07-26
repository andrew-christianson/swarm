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
Name:         DefClass.m
Description:  class with variables and/or methods defined at runtime 
Library:      defobj
*/

#import <defobj/DefClass.h>
#import <defobj/Program.h>
#import <objc/objc-api.h>
#import <collections.h> // catC:
#import <collections/predicates.h> // keywordp
#import <defobj/internal.h> // fcall_type_{size,alignment}, alignsizeto

#import <misc.h> // strncmp, isdigit

//
// CreatedClass_s -- class with variables and/or methods defined at runtime 
//
@implementation CreatedClass_s (OSX_GNU)
PHASE(CreatingOnly)

+ createBegin: aZone
{
  return [aZone allocIVars: self];
}

- setName: (const char *)className
{
  name = className;
  return self;
}

- setClass: aClass
{
  metaobjects = aClass;
  // later -- reallocate self if class defines additional class vars
  return self;
}

- setSuperclass: aClass
{
  superclass = aClass;
  return self;
}

- lispInCreate: expr
{
  id aZone = [expr getZone];
  id <Index> li = [expr begin: aZone];
  id key, val;

  Class newClass = class_copy ((Class) self);
  
  while ((key = [li next]) != nil)
    {
      const char *varName;

      if (!keywordp (key))
        raiseEvent (InvalidArgument, "expecting keyword [%s]", [key name]);

      if ((val = [li next]) == nil)
        raiseEvent (InvalidArgument, "missing value");
      
      varName = ZSTRDUP (aZone, [key getKeywordName]);
      
      if (stringp (val))
        class_addVariable (newClass, varName,
                           fcall_type_for_lisp_type ([val getC]), 0, NULL);
      else if (archiver_list_p (val))
        {
          id index = [val begin: aZone];
          id first = [index next];
          unsigned rank = [val getCount] - 2;
          fcall_type_t baseType;
          
          if (!stringp (first))
            raiseEvent (InvalidArgument, "argument should be a string");
          
          if (strcmp ([first getC], "array") != 0)
            raiseEvent (InvalidArgument, "argument should be \"array\"");

          {
            id second = [index next];

            if (!stringp (second))
              raiseEvent (InvalidArgument, "array type should be a string");
            
            baseType = fcall_type_for_lisp_type ([second getC]);
          }
          
          {
            id dimCountValue;
            unsigned dims[rank];
            unsigned i;
            
            for (i = 0; (dimCountValue = [index next]); i++)
              {
                if (!valuep (dimCountValue))
                  raiseEvent (InvalidArgument,
                              "array dimension count should be a value");
                dims[i] = [dimCountValue getUnsigned];
              }
            class_addVariable (newClass, varName, baseType, rank, dims);
          }
          [index drop];
        }
      else
        raiseEvent (InvalidArgument, "argument should be string or list");
    }
  [li drop];
  return newClass;
}


- hdf5InCreate: hdf5Obj
{
  [hdf5Obj setBaseTypeObject: self];
  return [hdf5Obj getClass];
}

- (void)hdf5OutShallow: hdf5Obj
{
  raiseEvent (NotImplemented, "DefClass / hdf5OutShallow:");
}

- (void)updateArchiver: archiver
{
  [archiver putShallow: [self name] object: self];
}

@end

@implementation BehaviorPhase_s

PHASE(CreatingOnly)

- (void)setNextPhase: aBehaviorPhase
{
  nextPhase = aBehaviorPhase;
}

@end
