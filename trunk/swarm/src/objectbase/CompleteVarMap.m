// Swarm library. Copyright (C) 1996-1999 Santa Fe Institute.
// This library is distributed without any warranty; without even the
// implied warranty of merchantability or fitness for a particular purpose.
// See file LICENSE for details and terms of copying.

#import <objectbase/CompleteVarMap.h>
#import <collections.h>
#import <objc/objc-api.h>
#import <defobj.h> // Warning

#import "local.h"

@implementation CompleteVarMap

- createEnd
{
  IvarList_t ivarList;
  int i;
  id a_probe;
  Class a_class;

  id classList;  //added to ensure the vars are added from Object downwards
  id anIndex;    //as required by the ObjectSaver (for example).
	
  if (SAFEPROBES)
    if (probedClass == 0)
      {
        raiseEvent (WarningMessage,
                    "CompleteVarMap object was not properly initialized\n");
        return nil;
      }

  probes = [Map createBegin: [self getZone]];
  [probes setCompareFunction: &p_compare];
  probes = [probes createEnd];
	
  if (probes == nil)
    return nil;

  classList = [List create: [self getZone]];
  if(!classList) 
    return nil;

  numEntries = 0;

  a_class = probedClass;
  do{
    [classList addFirst: (id) a_class];
    a_class = a_class->super_class;
  }while(a_class);

  anIndex = [classList begin: [self getZone]];
  while ((a_class = (id)[anIndex next]))
    {
      if ((ivarList = a_class->ivars))
        {
          numEntries += ivarList->ivar_count;
          
          for (i = 0; i < ivarList->ivar_count; i++)
            {
              char *name;
              
              name = (char *)ivarList->ivar_list[i].ivar_name;
              
              a_probe = [VarProbe createBegin: [self getZone]];
              [a_probe setProbedClass: a_class];
              [a_probe setProbedVariable: name];
              if (objectToNotify != nil) 
                [a_probe setObjectToNotify: objectToNotify];
              a_probe = [a_probe createEnd];
              
              [probes at: [String create: [self getZone] setC: name]
                      insert: a_probe];
            }
        }
    }
  [anIndex drop];
  [classList drop];
  return self;
}

@end

