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
Name:         DefClass_OSX.m
Description:  class with variables and/or methods defined at runtime 
Library:      defobj
*/

#import <defobj/DefClass_OSX.h>
#import <defobj/Program.h>
extern Class *osx_classes;

//
// _obj_getClassData() -- function to get class data extension structure
//
classData_t
_obj_getClassData (Class_s *class)
{
  classData_t classData;

#if 1
  printf("_obj_getClassData (%s, %d)\n", class->name, SWARMCLS_GETNUMBER(class) - 1);
  classData = (classData_t)_obj_classes[SWARMCLS_GETNUMBER (class) - 1];
  if (!classData)
    {
      classData = _obj_initAlloc (sizeof *classData);
      _obj_classes[SWARMCLS_GETNUMBER (class) - 1] = (id) classData;
    }
#else
  int i;
  int len = strlen(class->name);
  
  if (strstr(class->name, ".Using")) {
    len -= 6;
    printf("_obj_getClassData lookup: %s\n", class->name);
    }
  else if (strstr(class->name, ".Creating")) {
    len -= 9;
    printf("_obj_getClassData lookup: %s\n", class->name);
    }

  char aName[len+1];
  for (i = 0;i < len; ++i)
    aName[i] = (class->name)[i];
  aName[len] = NULL;
  
  // Apple doesn't have concept of class number
  // so need another way to uniquely tag classes.
  // Right now we just search through the whole list.
  for (i = 0;i < _obj_nclasses; ++i)
  {
    if (!strcmp(aName, osx_classes[i]->name))
    {
        classData = (classData_t)_obj_classes[i];
        break;
    }
  }
  printf("_obj_getClassData (%s)\n", aName);
  if (!classData)
  {
    classData = _obj_initAlloc (sizeof *classData);
    _obj_classes[i] = (id) classData;
  }
#endif
  return classData;
}

//
// _obj_printMethods() -- function to print instance and class methods for a class
//
void _obj_printMethods(char *className)
{
#if 0
  void *iterator = 0;
  int i = 0, j;
  struct objc_method_list *methods;
  struct objc_method *mnext;
  struct objc_class *class;

  class = (struct objc_class *)objc_lookUpClass (className);
  if (!class) {
    printf("_obj_printMethods: %s class not found\n", className);
    return;
  }
  
  printf("\n");

  // instance methods
  while ( methods = class_nextMethodList(class, &iterator) )
  {
    printf("Method list (%d, %d) with (%d) instance methods\n", i++,
        methods, methods->method_count);
    mnext = (struct objc_method *)((struct objc_method_list *)methods)->method_list;
    mnext = mnext + methods->method_count - 1;
    for (j = methods->method_count - 1;j >= 0; --j)
    {
        printf("(%s) instance method list (%d, %d): %s\n", class->name, j,
            mnext->method_imp, (char *)mnext->method_name);
        --mnext;
    }
  }

  // class methods
  iterator = 0; i = 0;
  class = class->isa;
  while ( methods = class_nextMethodList( (struct objc_class *)class, &iterator ) )
  {
    printf("Method list (%d, %d) with (%d) class methods\n", i++, methods, methods->method_count);
    mnext = (struct objc_method *)((struct objc_method_list *)methods)->method_list;
    mnext = mnext + methods->method_count - 1;
    for (j = methods->method_count - 1;j >= 0; --j)
    {
        printf("(%s) class method list (%d, %d): %s\n", class->name, j, 
            mnext->method_imp, (char *)mnext->method_name);
        --mnext;
    }
  }
  printf("\n");
#endif
}

//
// _obj_createClass() -- function to add new class to Mac OSX ObjC runtime
//
void _obj_createClass(Class_s *aClass)
{
    struct objc_class * meta_class;
    struct objc_class * super_class;
    //struct objc_class * new_class;
    struct objc_class * root_class;

    //va_list             args;
    //
    // Ensure that the superclass exists and that someone
    // hasn't already implemented a class with the same name
    //
    super_class = (struct objc_class *)objc_lookUpClass (aClass->superclass->name);
    if (super_class == nil) return;
    if (objc_lookUpClass (aClass->name) != nil) return;

    // Find the root class
    root_class = super_class;
    while( root_class->super_class != nil )
    {
        root_class = root_class->super_class;
    }

    // Allocate space for the class and its metaclass
    //new_class = calloc( 2, sizeof(struct objc_class) );
    //meta_class = &new_class[1];
    meta_class = malloc( sizeof(BehaviorPhase_s) );
    meta_class->isa = aClass->isa->isa;
    meta_class->super_class = aClass->isa->super_class;
    meta_class->name = aClass->name;
    meta_class->info    = CLS_META;
    // TODO: sometimes the meta_class may be looked at for instance size
    // like in [Zone copyIVars] for size of class structure ??
    meta_class->instance_size = aClass->isa->instance_size;

    // setup class
    aClass->isa = meta_class;
    aClass->info     = CLS_CLASS;
    aClass->info    = CLS_META;

    // setup class
    //new_class->isa      = meta_class;
    //new_class->info     = CLS_CLASS;
    //meta_class->info    = CLS_META;
    //new_class->instance_size = aClass->instanceSize;

    //
    // Create a copy of the class name.
    // For efficiency, we have the metaclass and the class itself 
    // to share this copy of the name, but this is not a requirement
    // imposed by the runtime.
    //
    //new_class->name = malloc (strlen (aClass->name) + 1);
    //strcpy ((char*)new_class->name, aClass->name);
    //meta_class->name = new_class->name;

    //
    // Allocate empty method lists.
    // We can add methods later.
    //
    //new_class->methodLists = calloc( 1, sizeof(struct objc_method_list *) );
    //*new_class->methodLists = -1;
    aClass->methodLists = calloc( 1, sizeof(struct objc_method_list *) );
    *aClass->methodLists = -1;
    meta_class->methodLists = calloc( 1, sizeof(struct objc_method_list *) );
    *meta_class->methodLists = -1;
    
    //
    // Connect the class definition to the class hierarchy:
    // Connect the class to the superclass.
    // Connect the metaclass to the metaclass of the superclass.
    // Connect the metaclass of the metaclass to
    //      the metaclass of the root class.
    //new_class->super_class  = super_class;
    meta_class->super_class = super_class->isa;
    meta_class->isa         = (void *)root_class->isa;

    // Finally, register the class with the runtime.
    //printf("Add (%s) to objc runtime\n", new_class->name);
    //objc_addClass( new_class ); 
    printf("Add (%s) to objc runtime\n", aClass->name);
    objc_addClass( aClass ); 
    return;
}

void _obj_addInstanceMethodList(methodDefs_t methodDefs, char *name)
{
  int j;
  Method mnext;
  struct objc_method_list *mlist;
  
  if (methodDefs->count == 0) return;

  struct objc_class *aClass = objc_lookUpClass(name);
  if (!aClass) return;

  mlist = (struct objc_method_list *) _obj_initAlloc (sizeof(struct objc_method_list)
                                                      + sizeof(struct objc_method) * (methodDefs->count - 1));
  mnext = methodDefs->firstEntry;
  mlist->method_count = methodDefs->count;
  for (j = 0;j < methodDefs->count; ++j) {
    mlist->method_list[j].method_name = mnext->method_name;
    mlist->method_list[j].method_types = strdup(mnext->method_types);
    mlist->method_list[j].method_imp = mnext->method_imp;
    --mnext;
  }
  class_addMethods(aClass, mlist);
}

void _obj_addClassMethodList(methodDefs_t methodDefs, char *name)
{
  int j;
  Method mnext;
  struct objc_method_list *mlist;
  
  if (methodDefs->classCount == 0) return;

  struct objc_class *aClass = objc_lookUpClass(name);
  if (!aClass) return;

  mlist = (struct objc_method_list *) _obj_initAlloc (sizeof(struct objc_method_list)
                                                      + sizeof(struct objc_method) * (methodDefs->classCount - 1));
  mnext = methodDefs->firstClassEntry;
  mlist->method_count = methodDefs->classCount;
  for (j = 0;j < methodDefs->classCount; ++j) {
    mlist->method_list[j].method_name = mnext->method_name;
    mlist->method_list[j].method_types = strdup(mnext->method_types);
    mlist->method_list[j].method_imp = mnext->method_imp;
    --mnext;
  }
  class_addMethods(aClass->isa, mlist);
}

//
// _obj_initMethodInterfaces() -- function to initialize methods by interface
//
void
_obj_initMethodInterfaces (Class_s *class)
{
  classData_t   classData;
  void *iterator = 0;
  struct objc_method_list *methods;
  struct objc_method        *mnext, *beginMethod;
  int i = 0, j = 0;
  int           count;
  id            interfaceID;
  const char    *mname;
  methodDefs_t  mdefs;

  classData = _obj_getClassData (class);
  printf("_obj_initMethodInterfaces (%s)\n", class->name);

  // Mac OSX keeps the instance methods separate from the class methods,
  // so need to go through both of them to pull out the methods for each phase.
  // Different method marker is used and Mac OSX ObjC runtime has methods
  // in opposite order of GNU runtime.

  _obj_printMethods(class->name);

  // instance methods
  while ( methods = class_nextMethodList( (struct objc_class *)class, &iterator ) )
  {
    count = 0;
    interfaceID = Using;
    mnext = (struct objc_method *)((struct objc_method_list *)methods)->method_list;
    mnext = mnext + methods->method_count - 1;
    beginMethod = mnext;
    for (j = methods->method_count - 1; ; --j)
    {
        if (j < 0 || strncmp ((mname = (const char *) sel_get_name (mnext->method_name)), "_I_", 3 ) == 0)
        {
          if (count)
            {
              mdefs = _obj_initAlloc (sizeof *mdefs);
              mdefs->next = (methodDefs_t)classData->metaobjects;
              classData->metaobjects = (id)mdefs;
              mdefs->interfaceID = interfaceID;
              mdefs->firstEntry = beginMethod;
              mdefs->count = count;
            }
          if (j < 0)
            break;
          interfaceID = mnext->method_imp (nil, (SEL)0);
          count = 0;
          beginMethod = mnext - 1;
        }
      else
        count++;
      --mnext;
    }
  }

  // class methods
  iterator = 0; i = 0;
  while ( methods = class_nextMethodList( (struct objc_class *)class->isa, &iterator ) )
  {
    count = 0;
    interfaceID = Using;
    mnext = (struct objc_method *)((struct objc_method_list *)methods)->method_list;
    mnext = mnext + methods->method_count - 1;
    beginMethod = mnext;
    for (j = methods->method_count - 1; ; --j)
    {
        if (j < 0 || strncmp ((mname = (const char *) sel_get_name (mnext->method_name)), "_C_", 3 ) == 0)
        {
          if (count)
            {
              methodDefs_t cmdefs = (methodDefs_t)classData->metaobjects;
              while (cmdefs) {
                if (cmdefs->interfaceID == interfaceID) {
                  cmdefs->firstClassEntry = beginMethod;
                  cmdefs->classCount = count;
                  break;
                }
                cmdefs = cmdefs->next;
              }
            }
          if (j < 0)
            break;
          interfaceID = mnext->method_imp (nil, (SEL)0);
          count = 0;
          beginMethod = mnext - 1;
        }
      else
        count++;
      --mnext;
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
  ivars = ((Class_s *) aClass)->ivars;
  methodLists = ((Class_s *) aClass)->methodLists;
  //cache = ((Class_s *) aClass)->cache;
  //cache = NULL;
  //protocols = ((Class_s *) aClass)->protocols;
  return self;
}

/* TODO: METHOD */
- (void)addInstanceMethodList: (methodDefs_t)methodDefs
{
  int j;
  Method mnext;
  struct objc_method_list *mlist;
  
  if (methodDefs->count == 0) return;

  struct objc_class *aClass = objc_lookUpClass(name);
  if (!aClass) return;

  mlist = (struct objc_method_list *) _obj_initAlloc (sizeof(struct objc_method_list)
                                                      + sizeof(struct objc_method) * (methodDefs->count - 1));
  mnext = methodDefs->firstEntry;
  mlist->method_count = methodDefs->count;
  for (j = 0;j < methodDefs->count; ++j) {
    mlist->method_list[j].method_name = mnext->method_name;
    mlist->method_list[j].method_types = strdup(mnext->method_types);
    mlist->method_list[j].method_imp = mnext->method_imp;
    --mnext;
  }
  class_addMethods(aClass, mlist);
}

- (void)addClassMethodList: (methodDefs_t)methodDefs
{
  int j;
  Method mnext;
  struct objc_method_list *mlist;
  
  if (methodDefs->classCount == 0) return;

  struct objc_class *aClass = objc_lookUpClass(name);
  if (!aClass) return;

  mlist = (struct objc_method_list *) _obj_initAlloc (sizeof(struct objc_method_list)
                                                      + sizeof(struct objc_method) * (methodDefs->classCount - 1));
  mnext = methodDefs->firstClassEntry;
  mlist->method_count = methodDefs->classCount;
  for (j = 0;j < methodDefs->classCount; ++j) {
    mlist->method_list[j].method_name = mnext->method_name;
    mlist->method_list[j].method_types = strdup(mnext->method_types);
    mlist->method_list[j].method_imp = mnext->method_imp;
    --mnext;
  }
  class_addMethods(aClass->isa, mlist);
}

- at: (SEL)aSel addMethod: (IMP)aMethod withTypes: (const char *)theTypes
{
    // cache these and write at createEnd
    // think we need to start with superclass's method list
    // need types as well
    struct objc_method_list *mlist;
    Method mnext = NULL;
    mlist = (struct objc_method_list *) _obj_initAlloc (sizeof (struct objc_method_list));
    mlist->method_count = 1;
    mlist->method_list->method_name = aSel;
    mlist->method_list->method_types = strdup(theTypes);
    mlist->method_list->method_imp = aMethod;
    class_addMethods(self, mlist);
    printf("at: (%s) addMethod: (%d) withTypes: (%s)\n", sel_getName(aSel),
        mlist, mlist->method_list->method_types);
#if 0
    mnext = class_getInstanceMethod(self, aSel);
    if (mnext) printf("found the method just added among the instance methods\n");
    else printf("did NOT find the method just added among the instance methods\n");
    mnext = class_getClassMethod(self, aSel);
    if (mnext) printf("found the method just added among the class methods\n");
    else printf("did NOT find the method just added among the class methods\n");
#endif
    return self;
}

- at: (SEL)aSel addMethod: (IMP)aMethod
{
  /* TODO */
  //FIXME: Is this really a TODO, or now that it has been sub-classed, should this method
  //FIXME: just be *un*implemented, so not print this message...
  printf("at:addMethod: was called and should not be!\n");
  //FIXME: but die instead?
  return self;
}

- createEnd
{
  metaobjects = nil;
  setBit (info, _CLS_DEFINEDCLASS, 1);
  return self;
}

- (void)lispOutShallow: stream
{
  //FIXME: What is the point of this do-nothing call? Should it die? print error?
  //FIXME: can it just be removed form the OSX split?
}

@end
