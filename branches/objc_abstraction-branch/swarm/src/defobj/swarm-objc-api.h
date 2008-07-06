// Swarm library. Copyright © 2008 Swarm Development Group.
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
Name:         swarm-objc-api.h
Description:  Swarm ObjC runtime library abstraction API
Library:      defobj
*/

#ifndef _SWARM_OBJC_API_H
#define _SWARM_OBJC_API_H

#include <stdint.h>
#include <stdlib.h>
#include <stddef.h>


#define SWARM_OBJC_TODO 1

#define SWARM_OBJC_DONE 0

#define SWARM_OBJC_DEBUG 0

// opaque ObjC runtime structures
typedef void *ObjcClass;
typedef void *ObjcIvar;
typedef void *ObjcProperty;
typedef void *ObjcMethod;
typedef void *ObjcProtocol;
typedef signed char ObjcBOOL;
typedef void *ObjcID;
typedef void *ObjcSEL;
typedef ObjcID (*ObjcIMP)(ObjcID, ObjcSEL, ...); 

#if 0

// core ObjC stuff
typedef signed char BOOL;
#define YES   (BOOL)1
#define NO    (BOOL)0
typedef void *SEL;
typedef struct objc_object {
  struct objc_class*  class_pointer;
} *id;
typedef id (*IMP)(id, SEL, ...); 
typedef void *retval_t;
#define nil (id)0                               /* id of Nil instance */
#define Nil (Class)0                            /* id of Nil class */
#define METHOD_NULL	(ObjcMethod)0
typedef void(*apply_t)(void);	/* function pointer */
typedef union {
  char *arg_ptr;
  char arg_regs[sizeof (char*)];
} *arglist_t;			/* argument frame */

/* Filer types used to describe Ivars and Methods.  */
#define _C_ID       '@'
#define _C_CLASS    '#'
#define _C_SEL      ':'
#define _C_CHR      'c'
#define _C_UCHR     'C'
#define _C_SHT      's'
#define _C_USHT     'S'
#define _C_INT      'i'
#define _C_UINT     'I'
#define _C_LNG      'l'
#define _C_ULNG     'L'
#define _C_LNG_LNG  'q'
#define _C_ULNG_LNG 'Q'
#define _C_FLT      'f'
#define _C_DBL      'd'
#define _C_LNG_DBL  'X'
#define _C_BFLD     'b'
#define _C_VOID     'v'
#define _C_UNDEF    '?'
#define _C_PTR      '^'
#define _C_CHARPTR  '*'
#define _C_ATOM     '%'
#define _C_ARY_B    '['
#define _C_ARY_E    ']'
#define _C_UNION_B  '('
#define _C_UNION_E  ')'
#define _C_STRUCT_B '{'
#define _C_STRUCT_E '}'

#define _C_CONST	'r'
#define _C_IN		'n'
#define _C_INOUT	'N'
#define _C_OUT      	'o'
#define _C_BYCOPY	'O'
#define _C_BYREF	'R'
#define _C_ONEWAY	'V'
#define _C_GCINVISIBLE	'!'

#endif // Core objc stuff


// Working with classes

ObjcBOOL
swarm_class_addIvar (ObjcClass cls, const char *name, size_t size, uint8_t alignment,
		     const char *types);

ObjcBOOL
swarm_class_addMethod (ObjcClass cls, ObjcSEL name, ObjcIMP imp, const char *types);

ObjcBOOL
swarm_class_addProtocol (ObjcClass cls, ObjcProtocol *protocol);

ObjcBOOL
swarm_class_conformsToProtocol (ObjcClass cls, ObjcProtocol *protocol);

ObjcIvar *
swarm_class_copyIvarList (ObjcClass cls, unsigned int *outCount);

ObjcMethod *
swarm_class_copyMethodList (ObjcClass cls, unsigned int *outCount);

ObjcProperty *
swarm_class_copyPropertyList (ObjcClass cls, unsigned int *outCount);

ObjcProtocol **
swarm_class_copyProtocolList (ObjcClass cls, unsigned int *outCount);

ObjcID
swarm_class_createInstance (ObjcClass cls, size_t extraBytes);

ObjcMethod
swarm_class_getClassMethod (ObjcClass cls, ObjcSEL name);

ObjcIvar
swarm_class_getClassVariable (ObjcClass cls, const char *name);

ObjcMethod
swarm_class_getInstanceMethod (ObjcClass cls, ObjcSEL name);

size_t
swarm_class_getInstanceSize (ObjcClass cls);

ObjcIvar
swarm_class_getInstanceVariable (ObjcClass cls, const char *name);

const char *
swarm_class_getIvarLayout (ObjcClass cls);

ObjcClass
swarm_class_getMetaclass (ObjcClass cls);

ObjcIMP
swarm_class_getMethodImplementation (ObjcClass cls, ObjcSEL sel);

const char *
swarm_class_getName (ObjcClass cls);

ObjcProperty
swarm_class_getProperty (ObjcClass cls, const char *name);

ObjcClass
swarm_class_getSuperclass (ObjcClass cls);

int
swarm_class_getVersion (ObjcClass cls);

ObjcBOOL
swarm_class_isMetaclass (ObjcClass cls);

ObjcBOOL
swarm_class_respondsToSelector (ObjcClass cls, ObjcSEL sel);

void
swarm_class_setIvarLayout (ObjcClass cls, const char *layout);

ObjcClass
swarm_class_setSuperclass (ObjcClass cls, ObjcClass newSuper);

void
swarm_class_setVersion (ObjcClass cls, int version);




// Adding classes
ObjcClass
swarm_objc_allocateClassPair (ObjcClass superClass, const char *name,
			      size_t extraBytes);

ObjcClass
swarm_objc_allocateClassPairCopy (ObjcClass cls, const char *name,
				  size_t extraBytes);

void
swarm_objc_registerClassPair (ObjcClass cls);

// Instantiating classes

// Obtaining class definitions
ObjcID swarm_objc_getClass(const char *name);

int swarm_objc_getClassList(ObjcClass *buffer, int bufferLen);

ObjcClass swarm_objc_getMetaclass(const char *name);
ObjcClass swarm_objc_lookupClass(const char *name);


// Working with instances
ObjcID swarm_object_copy(ObjcID obj, size_t size);

ObjcID swarm_object_dispose(ObjcID obj);

ObjcClass
swarm_object_getClass (ObjcID obj);

const char * swarm_object_getClassName(ObjcID obj);

ObjcIvar swarm_object_getInstanceVariable(ObjcID obj, const char *name, void **outValue);

ObjcID swarm_object_getIvar(ObjcID obj, ObjcIvar ivar);

ObjcClass
swarm_object_setClass (ObjcID obj, ObjcClass cls);

ObjcIvar swarm_object_setInstanceVariable(ObjcID obj, const char *name, void *value);

void swarm_object_setIvar(ObjcID object, ObjcIvar ivar, void *value);


// Working with instance variables
const char *
swarm_ivar_getName (ObjcIvar ivar);

ptrdiff_t
swarm_ivar_getOffset (ObjcIvar ivar);

const char *
swarm_ivar_getTypeEncoding (ObjcIvar ivar);


// Working with methods
char * swarm_method_copyArgumentType(ObjcMethod method, unsigned int index);

char * swarm_method_copyReturnType(ObjcMethod method);

void swarm_method_exchangeImplementations(ObjcMethod m1, ObjcMethod m2);

void swarm_method_getArgumentType(ObjcMethod method, unsigned int index, char *dst,
				  size_t dst_len);

ObjcIMP
swarm_method_getImplementation (ObjcMethod method);

ObjcSEL
swarm_method_getName (ObjcMethod method);

unsigned swarm_method_getNumberOfArguments(ObjcMethod method);

void swarm_method_getReturnType(ObjcMethod method, char *dst, size_t dst_len);

const char * swarm_method_getTypeEncoding(ObjcMethod method);

ObjcIMP swarm_method_setImplementation(ObjcMethod method, ObjcIMP imp);


// Working with selectors
ObjcSEL
swarm_sel_getAnyUid (const char *str);

const char *
swarm_sel_getName (ObjcSEL sel);

const char *
swarm_sel_getTypeEncoding (ObjcSEL sel);

ObjcSEL
swarm_sel_getTypedUid (const char *str, const char *types);

ObjcSEL
swarm_sel_getUid (const char *str);

ObjcSEL
swarm_sel_getUidWithType (const char *str);

ObjcBOOL
swarm_sel_isEqual (ObjcSEL sel1, ObjcSEL sel2);

ObjcSEL
swarm_sel_registerName (const char *str);

ObjcSEL
swarm_sel_registerTypedName (const char *str, const char *types);


// Working with protocols
ObjcProtocol **
swarm_objc_copyProtocolList (unsigned int *outCount);

ObjcProtocol *
swarm_objc_getProtocol (const char *name);

const char *
swarm_protocol_getName (ObjcProtocol *);

// Working with properties




//
// platform-specific ObjC runtime library
//

#if __APPLE_CC__
#include <objc/objc-api.h>
#if defined(OBJC_API_VERSION) && OBJC_API_VERSION >= 2
// Apple ObjC 2.0
#import "swarm-objc-apple2.h"
#else
// Apple ObjC 1.0
#import "swarm-objc-apple.h"
#endif
#else
// GNU ObjC runtime
#import <defobj/swarm-objc-gnu.h>
#endif


#endif // _SWARM_OBJC_API_H
