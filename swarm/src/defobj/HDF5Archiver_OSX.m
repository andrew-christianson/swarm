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

#import <defobj/HDF5Archiver_OSX.h>
/*
#import <defobj/HDF5Object.h>
#import <defobj.h> // OSTRDUP
#import <misc.h> // access

#include <collections/predicates.h>
*/
#import <defobj/defalloc.h> // getZone

@implementation HDF5Archiver_c

static id
hdf5_create_app_group (const char *appKey, id hdf5Obj)
{
  id hdf5AppObj = hdf5Obj;
  char *newAppKey, *modeKey;

  newAppKey = OSTRDUP (hdf5Obj, appKey);
  modeKey = newAppKey;
  
  while (*modeKey && *modeKey != '/')
    modeKey++;

  if (*modeKey == '/')
  {
    *modeKey = '\0';
    modeKey++;
    hdf5AppObj = [[[HDF5 createBegin: [hdf5Obj getZone]]
                       setWriteFlag: YES]
                         setParent: hdf5Obj];
    [hdf5AppObj setName: newAppKey];
    hdf5AppObj = [hdf5AppObj createEnd];
  }
  else
    raiseEvent (InvalidArgument, "expecting composite app/mode key");

  id obj = [[HDF5 createBegin: [hdf5AppObj getZone]] setParent: hdf5AppObj];
  
  [obj setName: modeKey];
  
  return [[obj setWriteFlag: YES] createEnd];
}

- createEnd
{
  id <HDF5> appFile;
  
  [super createEnd];

  appFile = [[[HDF5 createBegin: getZone (self)]
                 setWriteFlag: NO]
                setParent: nil];
  [appFile setName: path];
  [appFile createEnd];
  [self ensureApp: appFile];
  return self;
}

PHASE(Setting)

- (void)ensureApp: hdf5File
{
  //. Another do-nothing call.
}

PHASE(Using)

- getWritableController
{
  id hdf5Obj = [self getApplication];
  
  if (hdf5Obj)
    {
      if ([hdf5Obj getWriteFlag])
        return hdf5Obj;
      else
        {
          if (systemArchiverFlag)
            {
              id app = [hdf5Obj getParent];
              id file = [app getParent];

              [applicationMap deleteAll];
              [app drop];
              [file drop];
            }
          [hdf5Obj drop];
        }
    }
  hdf5Obj = [[[HDF5 createBegin: getZone (self)]
                 setWriteFlag: YES]
                setParent: nil];
  [hdf5Obj setName: path];
  hdf5Obj = [hdf5Obj createEnd];
  
  if (systemArchiverFlag)
    hdf5Obj = hdf5_create_app_group ([currentApplicationKey getC], hdf5Obj);
  
  [applicationMap at: currentApplicationKey replace: hdf5Obj];
  return hdf5Obj;
}

- (void)putDeep: (const char *)key object: object
{
  id group = [[[HDF5 createBegin: getZone (self)]
                  setWriteFlag: YES]
                 setParent: [self getWritableController]];
  [group setName: key];
  group = [group createEnd];

  if (!group)
    abort ();
  [object hdf5OutDeep: group];
  [group drop];
}

- (void)putShallow: (const char *)key object: object
{
  id dataset = [[[[HDF5 createBegin: getZone (self)]
                     setWriteFlag: YES]
                    setParent: [self getWritableController]]
                   setDatasetFlag: YES];
  [dataset setName: key];
  dataset = [dataset createEnd];
  if (!dataset)
    abort ();
  [object hdf5OutShallow: dataset];
  [dataset drop];
}

- getWithZone: aZone key: (const char *)key 
{
  id result; 
  id parent = [self getApplication];
  
  if (parent)
    {
      id <HDF5> hdf5Obj = [[[HDF5 createBegin: getZone (self)]
                               setParent: parent]
                              setDatasetFlag: [parent checkDatasetName: key]];
      [hdf5Obj setName: key];
      hdf5Obj = [hdf5Obj createEnd];
      
      if (hdf5Obj)
        {
          result = hdf5In (aZone, hdf5Obj);
          [hdf5Obj drop];
        }
      else
        result = nil;
    }
  else
    result = nil;
  return result;
}

@end
