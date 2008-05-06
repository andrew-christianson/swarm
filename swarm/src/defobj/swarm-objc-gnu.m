
#import <defobj/swarm-objc-gnu.h>
#include <stdlib.h>
#include <objc/runtime.h>

BOOL
swarm_class_addMethod (Class cls, SEL aSel, IMP imp, const char *types)
{
  if (!cls) return NO;
  if (sarray_get (cls->dtable, (size_t) aSel->sel_id) != 0) return NO;

  Method *aMethod = (Method *)malloc(sizeof(Method));
  aMethod->method_name = aSel;
  aMethod->method_types = malloc (strlen (types) + 1);
  strcpy ((char*)aMethod->method_types, types);
  aMethod->method_imp = imp;

  sarray_at_put_safe (cls->dtable, (size_t) aSel->sel_id, aMethod);

  // SWARM_OBJC_TODO - reconstruct method list

  return YES;
}

BOOL
swarm_class_respondsToSelector (Class cls, SEL sel)
{
  if (class_get_instance_method(cls, sel)) return YES;
  else if (class_get_class_method(cls->class_pointer, sel)) return YES;
  else return NO;
}

//
// Adding classes
//

Class
swarm_objc_allocateClassPair (Class superClass, const char *name,
			      size_t extraBytes)
{
  Class meta_class;
  Class super_class;
  Class new_class;
  Class root_class;

  printf("Allocating class pair: %s\n", name);

  // SWARM_OBJC_TODO - Allow creation of root class

  //
  // Ensure that the superclass exists and that someone
  // hasn't already implemented a class with the same name
  //
  super_class = objc_lookup_class (superClass->name);
  if (super_class == nil) return nil;
  if (objc_lookup_class (name) != nil) return nil;

  // Find the root class
  root_class = super_class;
  while (root_class->super_class != nil) {
    root_class = root_class->super_class;
  }

  // Allocate space for the class and its metaclass
  new_class = calloc (2, sizeof(struct objc_class));
  meta_class = &new_class[1];

  // setup class
  new_class->class_pointer = meta_class;
  new_class->info = _CLS_CLASS;
  meta_class->info = _CLS_META;
  new_class->instance_size = super_class->instance_size + extraBytes;

  // Create a copy of the class name.
  new_class->name = malloc (strlen (name) + 1);
  meta_class->name = malloc (strlen (name) + 1);
  strcpy ((char*)new_class->name, name);
  strcpy ((char*)meta_class->name, name);

  // We can add methods later.
  new_class->methods = NULL;
  meta_class->methods = NULL;

  // dispatch table
  new_class->dtable = sarray_lazy_copy (super_class->dtable);
  meta_class->dtable = sarray_lazy_copy (super_class->class_pointer->dtable);

  //
  // Connect the class definition to the class hierarchy:
  // Connect the class to the superclass.
  // Connect the metaclass to the metaclass of the superclass.
  // Connect the metaclass of the metaclass to
  //      the metaclass of the root class.
  new_class->super_class = super_class;
  meta_class->super_class = super_class->class_pointer;
  meta_class->class_pointer = (void *)root_class->class_pointer;

  // Finally, register the class with the runtime.
  printf("Adding class to runtime: %s\n", new_class->name);
  __objc_add_class_to_hash(new_class);

  return new_class;
}

void
swarm_objc_registerClassPair (Class cls)
{
}

int
swarm_objc_getClassList (Class *buffer, int bufferLen)
{
  Class class;
  void *enumState;
  int nclasses = 0;

  for (enumState = NULL; (class = objc_next_class (&enumState)); nclasses++) {
    if ((buffer != NULL) && (nclasses < bufferLen)) buffer[nclasses] = class;
  }

  return nclasses;
}

Method **
swarm_class_copyMethodList (Class cls, unsigned int *outCount)
{
  struct objc_method_list *methods;
  Method **methodList;
  int i, j;

  // Get count of all methods
  *outCount = 0;
  methods = cls->methods;
  while (methods != NULL) {
    *outCount += methods->method_count;
    methods = methods->method_next;
  }

  // no methods?
  if (*outCount == 0) return NULL;

  // Allocate method array
  methodList = (Method **)malloc(*outCount * sizeof(Method *));
  i = 0;
  methods = cls->methods;
  while (methods != NULL) {
    for (j = 0; j < methods->method_count; ++j) {
      methodList[i] = &(methods->method_list[j]);
      ++i;
    }
    methods = methods->method_next;
  }

  return methodList;
}

