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

#import <defobj/HDF5Archiver.h>
/*
#import <defobj/HDF5Object.h>
#import <defobj.h> // OSTRDUP
#import <misc.h> // access

#include <collections/predicates.h>
*/
#import <defobj/defalloc.h> // getZone

@implementation HDF5Archiver_c (OSX_GNU)

PHASE(Creating)

+ createBegin: aZone
{
  HDF5Archiver_c *newArchiver = [super createBegin: aZone];
  return newArchiver;
}

+ create: aZone setPath: (const char *)thePath
{
  return [super create: aZone setPath: thePath];
}

- setDefaultPath
{
  path = defaultPath (SWARMARCHIVER_HDF5);
  return self;
}

- setDefaultAppPath
{
  path = defaultAppPath ([arguments getAppDataPath],
                         [arguments getAppName],
                         SWARMARCHIVER_HDF5_SUFFIX);
  return self;
}

- getObject: (const char *)key
{
  return [self getWithZone: getZone (self) key: key];
}

- (void)sync
{
  [self updateArchiver];
  
  {
    id app = [self getApplication];
   
    if (app)
      [app flush];
  }
}

@end
