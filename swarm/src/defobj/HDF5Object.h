// Swarm library. Copyright (C) 1996-1998 Santa Fe Institute.
// This library is distributed without any warranty; without even the
// implied warranty of merchantability or fitness for a particular purpose.
// See file LICENSE for details and terms of copying.

#include <swarmconfig.h>

#ifdef HAVE_HDF5

#define id hdf5id
#include <hdf5.h>
#undef id

#import <defobj/Create.h>

@interface HDF5_c: CreateDrop_s
{
  hid_t loc_id;
  id parent;
  const char *name;
}
- setParent: parent;
- setName: (const char *)name;
- createEnd;
- store: (const char *)name type: (const char *)type ptr: (void *)ptr;
- (void)drop;
@end

#endif
