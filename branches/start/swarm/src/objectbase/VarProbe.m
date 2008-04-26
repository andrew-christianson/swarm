// Swarm library. Copyright (C) 1996 Santa Fe Institute.
// This library is distributed without any warranty; without even the
// implied warranty of merchantability or fitness for a particular purpose.
// See file LICENSE for details and terms of copying.

#define __USE_FIXED_PROTOTYPES__  // for gcc headers
#include <stdio.h>
#include <stdlib.h>
#import <string.h>

#import <objc/objc.h>
#import <objc/objc-api.h>
#import <swarmobject/VarProbe.h>

// SAFEPROBES enables lots of error checking here.
#define SAFEPROBES 1

@implementation VarProbe

-setProbedVariable: (char *) aVariable {
  if (probedVariable) {
    if (SAFEPROBES) {
      fprintf(stderr, "It is an error to reset the variable\n");
      return nil;
    } else {
      free(probedVariable);			  // memory allocation?
    }
  }
  probedVariable = strdup(aVariable);		  // make a local copy
  return self;
}

-(char *) getProbedVariable {
  return probedVariable;
}

-createEnd {
  IvarList_t ivarList;
  int i;

  [super createEnd] ;

  if (SAFEPROBES) {
    if (probedVariable == 0 || probedClass == 0) {
      fprintf(stderr, "VarProbe object was not properly initialized\n");
      return nil;
    }
  }

  ivarList = probedClass->ivars;
  
  // search the ivar list for the requested variable.
  i = 0;
  while (i < ivarList->ivar_count &&
           strcmp(ivarList->ivar_list[i].ivar_name, probedVariable) != 0)
    i++;

  if (i == ivarList->ivar_count) {		  // if not found
    if (SAFEPROBES)
      fprintf(stderr, "Warning: variable not found\n");
    return nil;					  // return nil
  } else {
    probedType = (char *) ivarList->ivar_list[i].ivar_type;
    dataOffset = ivarList->ivar_list[i].ivar_offset;
    return self;
  }
}

-(int) getDataOffset {
  return dataOffset ;
}

-free {
  if (probedVariable)
    free(probedVariable);
  return [super free];
}

-clone: aZone {
  VarProbe * new_probe ;

  new_probe = [VarProbe createBegin: aZone] ;
  [new_probe setProbedClass: probedClass] ;
  [new_probe setProbedVariable: probedVariable] ;
  new_probe = [new_probe createEnd] ;

  [new_probe setStringReturnType: stringReturnType] ;
	
  return new_probe ;
}

// no guarantees about alignment here.
-(void *) probeRaw: (id) anObject {
  if (safety)
    if (![anObject isKindOf: probedClass])
      fprintf(stderr, "VarProbe for class %s tried on class %s\n",
	      [probedClass name], [anObject name]);
  return (char *)anObject+dataOffset;
}

-(void *) probeAsPointer: (id) anObject {

	void *p;
	void *q;

  if (safety)
    if (![anObject isKindOf: probedClass])
      fprintf(stderr, "VarProbe for class %s tried on class %s\n",
	      [probedClass name], [anObject name]);

	p = ((char *)anObject) + dataOffset ;

  switch(probedType[0]) {

    case _C_ID:   q = (void *) *(id *)p; break;
    case _C_CLASS:   q = (void *) *(Class *)p; break;
    case _C_CHARPTR:
    case _C_PTR:  q = (void *) *(void **)p; break;

    case _C_INT:  q = (void *) *(int *)p; break;

    default:
      if (SAFEPROBES)
	fprintf(stderr, "Invalid type %s to retrieve as a pointer...\n", probedType);
      break;
  }
	return q ;
}

-(int) probeAsInt: (id) anObject {

	void *p;
	int   i;

  if (safety)
    if (![anObject isKindOf: probedClass])
      fprintf(stderr, "VarProbe for class %s tried on class %s\n",
	      [probedClass name], [anObject name]);

	p = ((char *)anObject) + dataOffset ;

  switch(probedType[0]) {

    case _C_ID:   i = (int) *(id *)p; break;
    case _C_CHARPTR:
    case _C_PTR:  i = (int) *(void **)p; break;

    case _C_UCHR: i = (int) *(unsigned char *)p; break;
    case _C_CHR:  i = (int) *(char *)p; break;

    case _C_INT:  i = (int) *(int *)p; break;
    case _C_UINT: i = (int) *(unsigned int *)p; break;

    default:
      if (SAFEPROBES)
	fprintf(stderr, "Invalid type %s to retrieve as an int...\n", probedType);
      break;
  }
	return i ;
}

-(double) probeAsDouble: (id) anObject {

	void *p;
	double   d;

  if (safety)
    if (![anObject isKindOf: probedClass])
      fprintf(stderr, "VarProbe for class %s tried on class %s\n",
	      [probedClass name], [anObject name]);

	p = ((char *)anObject) + dataOffset ;

  switch(probedType[0]) {

    case _C_UCHR: d = (double) *(unsigned char *)p; break;
    case _C_CHR:  d = (double) *(char *)p; break;

    case _C_INT:  d = (double) *(int *)p; break;
    case _C_UINT: d = (double) *(unsigned int *)p; break;

    case _C_FLT:  d = (double) *(float *)p; break;
    case _C_DBL:  d = (double) *(double *)p; break;

    default:
      if (SAFEPROBES)
	fprintf(stderr, "Invalid type %s to retrieve as a double...\n", probedType);
      break;
  }
	return d ;
}

-setStringReturnType: returnType{
	stringReturnType = returnType ;
	return self ;
}

-(char *) probeAsString: (id) anObject Buffer: (char *) buf {
  void * p;

  if (safety)
    if (![anObject isKindOf: probedClass])
      sprintf(buf, "VarProbe for class %s tried on class %s\n",
	      [probedClass name], [anObject name]);
      
  p = (char *)anObject + dataOffset;		  // probeData

  switch(probedType[0]) {
	  case _C_ID:
                        if([*(id *)p respondsTo: @selector(getInstanceName)])
			  sprintf(buf, "%s", [*(id *)p getInstanceName]);
                        else
			  sprintf(buf, "%s", [*(id *)p name]);
			break;
	  case _C_CLASS:
			sprintf(buf, "%s", (*(Class *)p)->name );
			break;
	  case _C_PTR:
			sprintf(buf, "0x%x", (unsigned) *(void **)p);
			break;
	  case _C_UCHR:
			if(stringReturnType == DefaultString)
                          sprintf(buf, "%u '%c'",(unsigned)*(unsigned char *)p,
                                                 *(unsigned char *)p);
			else if(stringReturnType == CharString)
                          sprintf(buf, "'%c'",*(unsigned char *)p);
			else if(stringReturnType == IntString)
                          sprintf(buf, "%u",(unsigned)*(unsigned char *)p);
			else {
  			  printf("stringReturnType set incorrectly!!!\n") ;
   			  exit(-1) ;
			}

			break;
    case _C_CHR:
			if(stringReturnType == DefaultString)
                          sprintf(buf, "%d '%c'",(int)*(char *)p,
                                                 *(char *)p);
			else if(stringReturnType == CharString)
                          sprintf(buf, "'%c'",*(char *)p);
			else if(stringReturnType == IntString)
                          sprintf(buf, "%d",(int)*(char *)p);
			else {
  			  printf("stringReturnType set incorrectly!!!\n") ;
   			  exit(-1) ;
			}

			break;
    case _C_INT:
			sprintf(buf, "%d", *(int *)p);
			break;
    case _C_UINT:
			sprintf(buf, "%u", *(unsigned *)p);
			break;
    case _C_FLT:
			sprintf(buf, "%g", (double)(*(float *)p));
			break;
    case _C_DBL:
			sprintf(buf, "%g", *(double *)p);
			break;
    case _C_CHARPTR:
			sprintf(buf, "%s", *(char **)p);
			break;
    default: sprintf(buf, "..."); break;
  }

  return buf;
}

// sets the probed to whatever is pointed to by newValue. Use the
// type information to try to do this intelligently.
-setData: (id) anObject To: (void *) newValue {
  void * p;
  if (safety)
    if (![anObject isKindOf: probedClass])
      fprintf(stderr, "VarProbe for class %s tried on class %s\n",
	      [probedClass name], [anObject name]);
      
  p = (char *)anObject + dataOffset;		  // probeData

  switch(probedType[0]) {
    case _C_ID:   *(id *)p = *(id *)newValue; break;
    case _C_CHARPTR:
    case _C_PTR:  *(void **)p = *(void **)newValue; break;

    case _C_UCHR: *(unsigned char *)p = *(unsigned char *)newValue; break;
    case _C_CHR:  *(char *)p = *(char *)newValue; break;

    case _C_INT:  *(int *)p = *(int *)newValue; break;
    case _C_UINT: *(unsigned int *)p = *(unsigned int *)newValue; break;
    case _C_FLT:  *(float *)p = *(float *)newValue; break;
    case _C_DBL:  *(double *)p = *(double *)newValue; break;

    default:
      if (SAFEPROBES)
	fprintf(stderr, "Invalid type %s to set\n", probedType);
      break;
  }
  return self;
}

// sets data to the string passed in. Some duplicated code with
// setData:To:, but it's not too bad. Note we don't allow setting
// pointers here, because textual representations of pointers are
// strange. That's probably not a good idea.
-setData: (id) anObject ToString: (const char *) s {
  union {
    char c;
    int i;
    float f;
    double d;
  } value;

  int rc;
  void * p;
  
  if (safety)
    if (![anObject isKindOf: probedClass])
      fprintf(stderr, "VarProbe for class %s tried on class %s\n",
	      [probedClass name], [anObject name]);

  p = (char *)anObject + dataOffset;		  // probeData

  switch(probedType[0]) {

    case _C_CHR:
      if(stringReturnType == CharString){
        if((rc = sscanf(s, "'%c'", &value.c))==1)
	  *(char *)p = value.c;
	} else {
	  if((rc = sscanf(s, "%d", &value.i))==1)
	    *(char *)p = value.i;
	}
      break;

    case _C_UCHR:
      if(stringReturnType == CharString){
	if((rc = sscanf(s, "'%c'", &value.c))==1)
	  *(char *)p = value.c;
        } else {
	  if((rc = sscanf(s, "%u", &value.i))==1)
            *(unsigned char *)p = value.i;
	}
      break ;

    case _C_CHARPTR:
	  *(char **)p = strdup(s) ;
          if(*(char **)p != NULL)
            rc = 1 ;
          else
            rc = 0 ;
          break;


    case _C_INT:  if((rc = sscanf(s, "%d", &value.i))==1) 
      *(int *)p = value.i; 
      break;

    case _C_UINT: if((rc = sscanf(s, "%u", &value.i))==1) 
      *(unsigned *)p = value.i; 
      break;

    case _C_FLT:  if((rc = sscanf(s, "%f", &value.f))==1) 
      *(float *)p = value.f; 
      break;

    case _C_DBL:  if((rc = sscanf(s, "%lf", &value.d))==1) 
      *(double *)p = value.d; 
      break;

    default:
      if (SAFEPROBES)
	fprintf(stderr, "Invalid type %s to set\n", probedType);
      break;
  }

  if (rc != 1 && SAFEPROBES)
    fprintf(stderr, "Error scanning for value in string %s\n", s);

  return self;
}

@end
