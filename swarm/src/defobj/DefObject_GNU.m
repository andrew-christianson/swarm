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
Name:         DefObject_GNU.m
Description:  top-level superclass to provide standard services
Library:      defobj
*/

#import <defobj/DefObject_GNU.h>
#import <objc/sarray.h>

@implementation Object_s

/* TODO: HDF5 */
- hdf5In: (id <HDF5>)hdf5Obj
{
  if ([hdf5Obj getDatasetFlag])
    [hdf5Obj shallowLoadObject: self];
  else
    {
      int process_object (id component)
        {
          [component assignIvar: self];
          return 0;
        }
      [hdf5Obj iterate: process_object];
    }
  return self;
}

+ (BOOL)conformsTo: (Protocol *)protocol
{
  if (getBit (((Class) self)->info, _CLS_DEFINEDCLASS))
    return [((CreatedClass_s *) self)->definingClass
                                     conformsTo: protocol];
  else
    return [super conformsTo: protocol];
}

//
// getMethodFor: -- return method defined for message to instance, if any
//
+ (IMP)getMethodFor: (SEL)aSel
{
  return sarray_get (((Class) self)->dtable, (size_t) aSel->sel_id);
}  

//
// perform:[with:[with:[with:]]] --
//   method to perform a message on an object with arguments, defined locally
//   for optional inheritance from the Object superclass, and to define the
//   three-argument form
//
#if 1
- perform: (SEL)aSel
{
  IMP  mptr;
  mptr = objc_msg_lookup (self, aSel);
  if (!mptr)
    raiseEvent (InvalidArgument, "> message selector not valid\n");
  return mptr (self, aSel);
}

- perform: (SEL)aSel with: anObject1
{
  IMP  mptr;
  mptr = objc_msg_lookup (self, aSel);
  if (!mptr)
    raiseEvent (InvalidArgument, "> message selector not valid\n");
  return mptr (self, aSel, anObject1);
}

- perform: (SEL)aSel with: anObject1 with: anObject2
{
  IMP  mptr;
  mptr = objc_msg_lookup (self, aSel);
  if (!mptr)
    raiseEvent (InvalidArgument, "> message selector not valid\n");
  return mptr (self, aSel, anObject1, anObject2);
}

- perform: (SEL)aSel with: anObject1 with: anObject2 with: anObject3
{
  IMP  mptr;
  mptr = objc_msg_lookup (self, aSel);
  if (!mptr)
    raiseEvent (InvalidArgument, "> message selector not valid\n");
  return mptr (self, aSel, anObject1, anObject2, anObject3);
}
#endif

#ifdef USE_MFRAME
- (retval_t)forward: (SEL)aSel : (arglist_t)argFrame
{
  NSArgumentInfo info;
  id <FArguments> fa;
  id <FCall> fc;
  types_t val;
  const char *type = sel_get_type (aSel);
#ifdef HAVE_JDK
  jobject jObj;
#endif
  COMobject cObj;
  id <Zone> aZone = getCZone (getZone (self));

  if (!type)
    {
      aSel = sel_get_any_typed_uid (sel_get_name (aSel));
      type = sel_get_type (aSel);
      if (!type)
        abort ();
    }


  fa = [FArguments createBegin: aZone];

  if ((cObj = SD_COM_FIND_OBJECT_COM (self)))
    {
      COMselector cSel; 

      if (!(cSel = SD_COM_FIND_SELECTOR_COM (aSel)))
        raiseEvent (InvalidArgument,
                    "unable to find COM selector `%s' in objc:`%s' %p\n",
                    sel_get_name (aSel),
                    [self name],
                    self,
                    cObj);
      {
        id <Symbol> language = (COM_selector_is_javascript (cSel)
                                ? LanguageJS
                                : LanguageCOM);
        [fa setLanguage: language];
      }
    }
#ifdef HAVE_JDK
  else if ((jObj = SD_JAVA_FIND_OBJECT_JAVA (self)))
    {
      jobject jSel;
      jclass jClass = (*jniEnv)->GetObjectClass (jniEnv, jObj);

      jSel = SD_JAVA_ENSURE_SELECTOR_JAVA (jClass, aSel);
      (*jniEnv)->DeleteLocalRef (jniEnv, jClass);

#if 0      
      if (!jSel)
        raiseEvent (InvalidArgument,
                    "unable to find Java selector `%s' in objc:`%s' %p java: %p hash: %d\n",
                    sel_get_name (aSel),
                    [self name],
                    self,
                    jObj,
                    swarm_directory_java_hash_code (jObj));
#endif
      
      if (jSel)
        {
          const char *sig = java_ensure_selector_type_signature (jSel);
          
          [fa setJavaSignature: sig];
          [scratchZone free: (void *) sig];
        }
    }
#endif
  else
    {
      [fa drop];
      [self doesNotRecognize: aSel];
      return NULL;
    }
  
  type = mframe_next_arg (type, &info);
  mframe_get_arg (argFrame, &info, &val);
  [fa setObjCReturnType: *info.type];
  /* skip object and selector */
  type = mframe_next_arg (type, &info);
  type = mframe_next_arg (type, &info);
  while ((type = mframe_next_arg (type, &info)))
    {
      mframe_get_arg (argFrame, &info, &val);
      [fa addArgument: &val ofObjCType: *info.type];
    }
  fa = [fa createEnd];

  fc = [FCall create: aZone
              target: self
              selector: aSel
              arguments: fa];
  
  if (fc)
    {
      [fc performCall];
      {
        types_t typebuf;
        extern void *alloca (size_t);
        retval_t retValBuf = alloca (MFRAME_RESULT_SIZE);
        retval_t retVal;
        
        retVal = [fc getRetVal: retValBuf buf: &typebuf];
        [fc drop];
        [fa drop];
        return retVal;
      }
    }
  else
    {
      [fa drop];
      [self doesNotRecognize: aSel];
      return NULL;
    }
}
#endif
#endif

- (void)lispOutVars: stream deep: (BOOL)deepFlag
{
  void store_object (const char *name, fcall_type_t type,
                     void *ptr, unsigned rank, unsigned *dims)
    {
      [stream catSeparator];
      [stream catKeyword: name];
      [stream catSeparator];
      if (rank > 0)
        lisp_process_array (rank, dims, type, ptr,
                            NULL, stream, deepFlag);
      else
        lisp_output_type (type,
                          ptr,
                          0,
                          NULL,
                          stream,
                          deepFlag);
        
    }
  map_object_ivars (self, store_object);
}

- (void)hdf5OutDeep: hdf5Obj
{
  void store_object (const char *name,
                     fcall_type_t type,
                     void *ptr,
                     unsigned rank,
                     unsigned *dims)
    {
      if (type == fcall_type_object)
        {
          id obj = *((id *) ptr);
          
          if (obj != nil)
            {
              id group = [[[[[HDF5 createBegin: [hdf5Obj getZone]]
                              setWriteFlag: YES]
                             setParent: hdf5Obj]
                            setName: name]
                           createEnd];
              
              [obj hdf5OutDeep: group];
              [group drop];
            }
        }
      else
        [hdf5Obj storeAsDataset: name typeName: NULL
                 type: type rank: rank dims: dims 
                 ptr: ptr];
    }
  [hdf5Obj storeTypeName: [self getTypeName]];
  map_object_ivars (self, store_object);
}

- (void)hdf5OutShallow: hdf5Obj
{
  if ([hdf5Obj getCompoundType])
    [hdf5Obj shallowStoreObject: self];
  else
    {
      id cType = [[[HDF5CompoundType createBegin: getZone (self)]
                    setPrototype: self]
                   createEnd];
      const char *objName = [hdf5Obj getHDF5Name];

      id cDataset = [[[[[[HDF5 createBegin: getZone (self)]
                          setName: objName]
                         setWriteFlag: YES]
                        setParent: hdf5Obj]
                       setCompoundType: cType]
                      createEnd];
      
      [cDataset storeTypeName: [self getTypeName]];
      [cDataset shallowStoreObject: self];
      
      // for R
      [cDataset nameRecord: 0 name: objName];
      [cDataset writeRowNames];
      [cDataset writeLevels];
      
      [cDataset drop];
      [cType drop];
    }
}

@end

//
// respondsTo() -- function to test if object responds to message  
//
BOOL
respondsTo (id anObject, SEL aSel)
{
  return sarray_get (getClass (anObject)->dtable, (size_t) aSel->sel_id) != 0;
}

//
// getMethodFor() --
//   function to look up the method that implements a message within a class
//
IMP
getMethodFor (Class aClass, SEL aSel)
{
  return sarray_get (aClass->dtable, (size_t) aSel->sel_id);
}
