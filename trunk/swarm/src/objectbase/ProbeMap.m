// Swarm library. Copyright (C) 1996-1999 Santa Fe Institute.
// This library is distributed without any warranty; without even the
// implied warranty of merchantability or fitness for a particular purpose.
// See file LICENSE for details and terms of copying.

#import <objectbase/ProbeMap.h>
#import <objc/objc-api.h>
#import <defobj.h> // Warning

#import "local.h"
#include <misc.h> // strdup

#ifdef HAVE_JDK
#import "../defobj/directory.h" // swarm_directory_ensure_selector
extern jclass c_Selector;
extern jmethodID  m_ClassGetDeclaredFields,
  m_ClassGetDeclaredMethods, m_MethodGetName,
  m_SelectorConstructor, m_FieldGetName;
#endif

@implementation ProbeMap

+ createBegin: aZone
{
  ProbeMap *tempObj;

  tempObj = [super createBegin: aZone];
  tempObj->objectToNotify = nil;
  return tempObj;
}

- setObjectToNotify: anObject
{
  id temp_otn;

  if (anObject != nil
      && ([anObject 
            respondsTo:
              M(eventOccurredOn:via:withProbeType:on:ofType:withData:)] == NO)
      && ![anObject respondsTo: M(forEach:)])
    raiseEvent (NotImplemented, "Object %0#p of class %s does not implement "
                "standard probe hook message.\n", 
                anObject, [[anObject class] name]);
  
  
  // this is pretty ugly, if you set more than one thing to 
  // notify, you'll be invoking this code more than once with
  // possibly no effect.
  
  // inherit the probeLibrary's otn, which should NOT be a list
  if (objectToNotify != nil) {
    if ((temp_otn = [probeLibrary getObjectToNotify]) != nil)
      {
        if ([objectToNotify respondsTo: M(forEach:)])
          {
            if ([temp_otn respondsTo: M(forEach:)])
              {
                // both exist and both are lists
                // add contents of temp_otn to otn
                id index, tempObj;
                index = [temp_otn begin: scratchZone];
                while ( (tempObj = [index next]) != nil)
                  {
                    if (([objectToNotify contains: tempObj]) == NO)
                      [objectToNotify addLast: tempObj];
                  }
                [index drop];
              }
            else
              {
                // both exist, otn is list temp_otn not list
                // add temp_otn to otn
                if (([objectToNotify contains: temp_otn]) == NO)
                  [objectToNotify addLast: temp_otn];
              }
          }
        else if ([temp_otn respondsTo: M(forEach:)])
          {
            // both exist, otn is not list temp_otn is list
            // add otn to front of temp_otn and swap
            id tempObj;
            tempObj = objectToNotify;
            objectToNotify = temp_otn;
            if ([objectToNotify contains: tempObj] == NO)
              [objectToNotify addFirst: tempObj];
          }
      }
    //else clause => otn exists, temp_otn does not, so do nothing
  }
  else if ((temp_otn = [probeLibrary getObjectToNotify]) != nil)
    objectToNotify = temp_otn;
  //else clause => neither exist, so do nothing
  
  if (objectToNotify != nil)
    {
      if ([objectToNotify respondsTo: M(forEach:)])
        {
          if ([anObject respondsTo: M(forEach:)])
            {
              // put all the objects on the ProbeMap's list 
              // at the time when we're created onto our list
              id index, tempObj;
              index = [anObject begin: scratchZone];
              while ( (tempObj = [index next]) != nil )
                {
                  if (([objectToNotify contains: tempObj]) == NO)
                    [objectToNotify addLast: tempObj];
                }
              [index drop];
            }
          else
            if (([objectToNotify contains: anObject]) == NO)
              [objectToNotify addLast: anObject];
        }
      else
        {  // objectToNotify is not a list
          id temp;
          
          temp = objectToNotify;
          objectToNotify = [List create: [self getZone]];
          [objectToNotify addLast: temp];
          if (([objectToNotify contains: anObject]) == NO) 
            [objectToNotify addLast: anObject];
        }
    }
  else
    objectToNotify = anObject;
  
  return self;
}

- getObjectToNotify
{
  return objectToNotify;
}

- setProbedClass: (Class)aClass
{
  if (SAFEPROBES)
    if (probedClass != 0)
      {
        raiseEvent (WarningMessage, "It is an error to reset the class\n");
        return nil;
      }

#ifdef HAVE_JDK
  // if class passed to setProbedClass is 
  isJavaProxy = [aClass respondsTo: M(isJavaProxy)];     
#endif

  probedClass = aClass;
  return self;
}

- (Class)getProbedClass
{
  return probedClass;
}

- _copyCreateEnd_
{
  if (SAFEPROBES)
    if (probedClass == 0)
      {
        raiseEvent (WarningMessage,
                    "ProbeMap object was not properly initialized\n");
        return nil;
      }
  numEntries = 0;
  
  probes = [Map createBegin: [self getZone]];
  [probes setCompareFunction: &p_compare];
  probes = [probes createEnd];
  
  if (probes == nil)
    return nil;
  
  return self;
}

- createEnd
{
  IvarList_t ivarList;
  MethodList_t methodList;
  //The compiler seems to put the methods in the 
  //opposite order than the one in which they were
  //declared, so we need to manually invert them.
  id inversionList; 
  id index;
  
  int i;
  id aProbe;
  
  if (SAFEPROBES)
    if (probedClass == 0)
      {
        raiseEvent (WarningMessage,
                    "ProbeMap object was not properly initialized\n");
        return nil;
      }

  if (objectToNotify == nil)
    [self setObjectToNotify: 
            [probeLibrary getObjectToNotify]];
  
  probes = [Map createBegin: [self getZone]];
  [probes setCompareFunction: &p_compare];
  probes = [probes createEnd];  

  if (probes == nil)
    return nil;

#ifdef HAVE_JDK
  if (isJavaProxy)
    { 
      jarray fields;
      jsize fieldslength;
      jarray methods;
      jsize methodslength;

      unsigned i;
      numEntries = 0;
      classObject = SD_FINDJAVA (jniEnv, probedClass);
      if (!classObject)
	raiseEvent (SourceMessage,
		    "Java class to be probed can not be found!\n");      
      
      if (!(fields = (*jniEnv)->CallObjectMethod (jniEnv, classObject, 
                                                  m_ClassGetDeclaredFields)))
	abort(); 
      
      fieldslength = (*jniEnv)->GetArrayLength (jniEnv, fields);
      if (!(methods = (*jniEnv)->CallObjectMethod (jniEnv,
                                                   classObject, 
                                                   m_ClassGetDeclaredMethods)))
	abort();
      methodslength = (*jniEnv)->GetArrayLength (jniEnv, methods);
      numEntries = fieldslength;
      for (i = 0; i < numEntries; i++)
	{
	  jobject field;
	  jstring name;
	  const char * buf;
	  jboolean isCopy;

	  field = (*jniEnv)->GetObjectArrayElement (jniEnv, fields, i);
	
	  name = (*jniEnv)->CallObjectMethod (jniEnv, field, m_FieldGetName);
	  
	  buf = (*jniEnv)->GetStringUTFChars (jniEnv, name, &isCopy);
	  aProbe = [VarProbe createBegin: [self getZone]];
          [aProbe setProbedClass: probedClass];
          [aProbe setProbedVariable: buf];
	  
          if (objectToNotify != nil) 
            [aProbe setObjectToNotify: objectToNotify];
          aProbe = [aProbe createEnd];
          [probes at: [String create: [self getZone] setC: buf]
                  insert: aProbe];
	  
	  if (isCopy)
	    (*jniEnv)->ReleaseStringUTFChars (jniEnv, name, buf);
	}

      if (methodslength)
	{
	  numEntries += methodslength;
	  
	  inversionList = [List create: [self getZone]];
	  for (i = 0; i < methodslength; i++)
	    {
	      jobject method;
	      jstring name;
	      jobject selector;
	      SEL sel;

	      method = (*jniEnv)->GetObjectArrayElement (jniEnv, methods, i);
	      name = (*jniEnv)->CallObjectMethod (jniEnv,
                                                  method, 
						  m_MethodGetName);
	      selector = (*jniEnv)->NewObject (jniEnv,
                                               c_Selector, 
					       m_SelectorConstructor, 
					       classObject,
					       name,
                                               JNI_FALSE);
	      sel = swarm_directory_ensure_selector (jniEnv, selector);
	      	      
	      aProbe = [MessageProbe createBegin: [self getZone]];
	      [aProbe setProbedClass: probedClass];
	      [aProbe setProbedSelector: sel];
	      if (objectToNotify != nil) 
		[aProbe setObjectToNotify: objectToNotify];
	      
	      aProbe = [aProbe createEnd];
	      
	      if (aProbe)
		[inversionList addFirst: aProbe];
	      else
		numEntries--;
	    }
      
	  index = [inversionList begin: [self getZone]];
	  while ((aProbe = [index next]))
	    {
	      [probes at: 
			[String 
			  create: [self getZone] 
			  setC: [aProbe getProbedMessage]] 
		      insert: 
			aProbe];
	      [index remove];
	    }	
	  [index drop];
	  [inversionList drop];
	}
      return self;
    }
  
#endif
      
  if (!(ivarList = probedClass->ivars))
    numEntries = 0;
  else
    {
      numEntries = ivarList->ivar_count;
      
      for (i = 0; i < numEntries; i++)
        {
          const char *name;
          
          name = ivarList->ivar_list[i].ivar_name;
          
          aProbe = [VarProbe createBegin: [self getZone]];
          [aProbe setProbedClass: probedClass];
          [aProbe setProbedVariable: name];
          if (objectToNotify != nil) 
            [aProbe setObjectToNotify: objectToNotify];
          aProbe = [aProbe createEnd];
          
          [probes at: [String create: [self getZone] setC: name]
                  insert: aProbe];
        }
    }
  
  if ((methodList = probedClass->methods))
    {
      numEntries += methodList->method_count;
      
      inversionList = [List create: [self getZone]];
      
      for (i = 0; i < methodList->method_count; i++)
        {
          aProbe = [MessageProbe createBegin: [self getZone]];
          [aProbe setProbedClass: probedClass];
          [aProbe setProbedSelector: methodList->method_list[i].method_name];
          if (objectToNotify != nil) 
            [aProbe setObjectToNotify: objectToNotify];
          aProbe = [aProbe createEnd];
          
          if(aProbe)
            [inversionList addFirst: aProbe];
          else
            numEntries--;
        }
      
      index = [inversionList begin: [self getZone]];
      while ((aProbe = [index next]))
        {
          [probes at: 
                    [String 
                      create: [self getZone] 
                      setC: [aProbe getProbedMessage]] 
                  insert: 
                    aProbe];
          [index remove];
        }	
      [index drop];
      [inversionList drop];
    }

  return self;
}

- clone: aZone
{
  ProbeMap *npm;
  id index;
  id aProbe;
  
  npm = [ProbeMap createBegin: aZone];
  [npm setProbedClass: probedClass];
  npm =	[npm _copyCreateEnd_];
  
  index = [self begin: aZone];
  
  while ((aProbe = [index next]) != nil)
    [npm _fastAddProbe_: [aProbe clone: aZone]];
  
  [index drop];
  
  return npm;
}

- (int)getNumEntries
{
  return numEntries;
}

- addProbeMap: (ProbeMap *)aProbeMap
{
  Class aClass;
  Class class;
  id index;
  id aProbe;
	
  aClass = [aProbeMap getProbedClass];

  for (class = probedClass; class!=Nil; class = class_get_super_class (class))
    if (class==aClass)
      {
        index = [aProbeMap begin: globalZone];
        while ((aProbe = [index next]) != nil)
	  [self _fastAddProbe_: aProbe];
        [index drop];
        return self;
      }

  raiseEvent (WarningMessage,
              "ProbeMap not added because %s is not a superclass of %s\n",
              aClass->name, probedClass->name);

  return self;
}

- addProbe: aProbe
{
  id string;
  Class aClass;
  Class class;
	
  if([aProbe isKindOf: [VarProbe class]])
    string = [String create: [self getZone]
                           setC: [aProbe getProbedVariable]];
  else	
    string = [String create: [self getZone]
                           setC: strdup ([aProbe getProbedMessage])];
  
  if ([probes at: string] != nil)
    raiseEvent (WarningMessage,
                "addProbe: There was already a probe for %s!!!\n",
                [string getC]);
  
  aClass = [aProbe getProbedClass];
  
  for (class = probedClass;
       class != Nil;
       class = class_get_super_class (class))
    if (class == aClass)
      {
        [probes at: string insert: aProbe];
        numEntries++;
        if (objectToNotify != nil) 
          [aProbe setObjectToNotify: objectToNotify];
        return self;
      }
  
 raiseEvent (WarningMessage,
             "Probe not added to ProbeMap because %s is not a superclass of %s\n",
             aClass->name, probedClass->name);
  
  return self;
}


// Here, we don't check that the probe is of an appropriate class...
// This method is used by addProbeMap and clone where the check is done
// for all the probes within the candidate ProbeMap.
//
// Note: In practice, it is probably unnecessary to check for duplicate
//       inclusion...

- _fastAddProbe_: aProbe
{

  id string;

  if([aProbe isKindOf: [VarProbe class]])
    string = [String create: [self getZone]
                     setC: [aProbe getProbedVariable]];
  else
    string = [String create: [self getZone]
                     setC: strdup([aProbe getProbedMessage])];

  if ([probes at: string] != nil)
    raiseEvent (WarningMessage,
                "addProbe: There was already a probe for %s!!!\n",
                [string getC]);

  [probes at: string insert: aProbe];
  numEntries++;

  if (objectToNotify != nil) 
    [aProbe setObjectToNotify: objectToNotify];

  return self;
}


// Note: the candidate ProbeMap for removal does not have to contain the
// *same* class in order to cause removal... Only probes with the same
// name!
//
// [We do not check that the classes are appropriate because the
// user may want to subtract commonly named methods from unrelated
// classes!!!]
- dropProbeMap: (ProbeMap *) aProbeMap
{
  id index;
  id aProbe;
			
  index = [aProbeMap begin: globalZone];

  while ((aProbe = [index next]) != nil)
    if ([aProbe isKindOf: [VarProbe class]])
      [self dropProbeForVariable: [aProbe getProbedVariable]];
    else
      [self dropProbeForMessage: strdup ([aProbe getProbedMessage])];
  
  [index drop];
	
  return self;
}

- dropProbeForVariable: (const char *)aVariable
{
  id string;
  
  string = [String create: [self getZone] setC: aVariable];
  if([probes removeKey: string] != nil)
    numEntries--;
  [string drop];
  
  return self;
}

- (Probe *)getProbeForVariable: (const char *)aVariable
{
  id string;
  id res;
  
  string = [String create: [self getZone] setC: aVariable];
  
  res = [probes at: string];
  [string drop];
  
  if (res == nil)
    { 
      // if not found
      if (SAFEPROBES)
        raiseEvent (WarningMessage,
                    "The variable %s was not found\n",
                    aVariable);
      return nil;
    }
  else
    return res;
}

- dropProbeForMessage: (const char *)aMessage
{
  id string;
  
  string = [String create: [self getZone] setC: aMessage];
  if([probes removeKey: string] != nil)
    numEntries--;
  [string drop];
  
  return self;
}

- (Probe *)getProbeForMessage: (const char *)aMessage
{
  id string;
  id res;
  
  string = [String create: [self getZone] setC: aMessage];

  res = [probes at: string];
  [string drop];

  if (res == nil)
    {
      if (SAFEPROBES)
        raiseEvent (WarningMessage,
                    "The message %s was not found\n",
                    aMessage);
      return nil;
    }
  else
    return res;
}

-begin: aZone
{
  return [probes begin: aZone];
}

@end
