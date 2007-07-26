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
Name:         DefObject_OSX.m
Description:  top-level superclass to provide standard services
Library:      defobj
*/

#import <defobj/DefObject_OSX.h>
#import <defobj/DefClass.h>
#import <objc-gnu2next.h>

@implementation Object_s

+ (BOOL)conformsTo: (Protocol *)protocol
{
  if (getBit (((Class) self)->info, _CLS_DEFINEDCLASS))
    return [((CreatedClass_s *) self)->definingClass
                                     conformsToProtocol: protocol];
  else
    return [super conformsToProtocol: protocol];
}

//
// getMethodFor: -- return method defined for message to instance, if any
//
+ (IMP)getMethodFor: (SEL)aSel
{
/* TODO */
  printf("getMethodFor: %s\n", aSel);
  Method m = class_getClassMethod([self class], aSel);
  return m->method_imp;
}  

//
// perform:[with:[with:[with:]]] --
//   method to perform a message on an object with arguments, defined locally
//   for optional inheritance from the Object superclass, and to define the
//   three-argument form
//
#if 0
- perform: (SEL)aSel
{
  IMP  mptr;
  printf("perform: %s\n", aSel);
  mptr = objc_msg_lookup (self, aSel);
  if (!mptr)
    raiseEvent (InvalidArgument, "> message selector not valid\n");
  return mptr (self, aSel);
}

- perform: (SEL)aSel with: anObject1
{
  IMP  mptr;
  /* TODO */
  printf("perform:with: %s\n", aSel);
  mptr = objc_msg_lookup (self, aSel);
  if (!mptr)
    raiseEvent (InvalidArgument, "> message selector not valid\n");
  return mptr (self, aSel, anObject1);
}

- perform: (SEL)aSel with: anObject1 with: anObject2
{
  IMP  mptr;
  /* TODO */
  printf("perform:with:with: %s\n", aSel);
  mptr = objc_msg_lookup (self, aSel);
  if (!mptr)
    raiseEvent (InvalidArgument, "> message selector not valid\n");
  return mptr (self, aSel, anObject1, anObject2);
}

- perform: (SEL)aSel with: anObject1 with: anObject2 with: anObject3
{
  IMP  mptr;
  /* TODO */
  printf("perform:with:with:with: %s\n", aSel);
  mptr = objc_msg_lookup (self, aSel);
  if (!mptr)
    raiseEvent (InvalidArgument, "> message selector not valid\n");
  return mptr (self, aSel, anObject1, anObject2, anObject3);
}

- perform: (SEL)aSel with: anObject1 with: anObject2 with: anObject3
{
  return objc_msgSend(self, aSel, anObject1, anObject2, anObject3);
}

- forward: (SEL)aSel : (marg_list)argFrame
{
    printf("forward:\n");
    return nil;
}
#endif


- (void)lispOutVars: stream deep: (BOOL)deepFlag
{
}

- (void)hdf5OutDeep: hdf5Obj
{
}

- (void)hdf5OutShallow: hdf5Obj
{
}

#if 0
- (NSMethodSignature*) methodSignatureForSelector: (SEL)aSelector
{
  const char* aName = sel_getName(aSelector);
  printf("selector: %s\n", aName);

  NSMethodSignature *sig = [self methodSignatureForSelector: aSelector];

  return sig;
}
#endif

#if 0
- (void) forwardInvocation: (NSInvocation*)anInvocation
{
  printf("forwardInvocation:\n");
  SEL aSel = [anInvocation selector];
  [self doesNotRecognize: aSel];
}
#endif

@end

//
// respondsTo() -- function to test if object responds to message  
//
BOOL
respondsTo (id anObject, SEL aSel)
{
  /* TODO */
  printf("respondsTo()\n");
  return [anObject respondsToSelector: aSel];

//  return ((object_is_instance (anObject)
//           ? class_getInstanceMethod (anObject->isa, aSel)
//           : class_getClassMethod (anObject->isa, aSel)) != NULL);
}

//
// getMethodFor() --
//   function to look up the method that implements a message within a class
//
IMP
getMethodFor (Class aClass, SEL aSel)
{
  /* TODO */
  printf("getMethodFor(%s, %s)\n", aClass->name, aSel);
  Method m = class_getInstanceMethod(aClass, aSel);
  if (m == NULL)
    m = class_getClassMethod(aClass, aSel);

  if (m == NULL)
    printf("getMethodFor(%s, %s) not found\n", aClass->name, aSel);
  return m->method_imp;
}
