// Swarm library. Copyright � 1996-2000 Swarm Development Group.
// This library is distributed without any warranty; without even the
// implied warranty of merchantability or fitness for a particular purpose.
// See file LICENSE for details and terms of copying.

// Generic support for 2d discrete lattices.
// Each point in the lattice stores either an id or a integer.
// Ie: 32 bits per point. This is not 100% general, but is the best
// compromise I know of.

// See FUTURE-DESIGN for notes on where this is going.

#import <objectbase/SwarmObject.h>
#import <space.h>

@interface Discrete2d: SwarmObject <Discrete2d>
{
@public
  unsigned xsize, ysize;
  id *lattice;
  long *offsets;
}

+ create: aZone setSizeX: (unsigned)x Y: (unsigned)y;
- setSizeX: (unsigned)x Y: (unsigned)y;
- createEnd;
- makeOffsets;
- (id *)allocLattice;

- (unsigned)getSizeX;
- (unsigned)getSizeY;

- getObjectAtX: (unsigned)x Y: (unsigned)y;
- (long)getValueAtX: (unsigned)x Y: (unsigned)y;

- putObject: anObject atX: (unsigned)x Y: (unsigned)y;
- putValue: (long)v atX: (unsigned)x Y: (unsigned)y;

- fastFillWithValue: (long)aValue;
- fastFillWithObject: anObj;

- fillWithValue: (long)aValue;
- fillWithObject: anObj;

- setLattice: (id *)lattice;

- (id *)getLattice;
- (long *)getOffsets;

- copyDiscrete2d: (id <Discrete2d>)a toDiscrete2d: (id <Discrete2d>)b;
- (int)setDiscrete2d: (id <Discrete2d>)a toFile: (const char *)filename;

- hdf5InCreate: hdf5Obj;
- hdf5In: hdf5Obj;
- (void)hdf5OutShallow: hdf5Obj;
- (void)hdf5OutDeep: hdf5Obj;
- (void)lispOutShallow: stream;
- (void)lispOutDeep: stream;
@end

// fast macro to access lattice array. Use this cautiously.
// We define this here to allow library authors to get around the
// getFooAtX:Y: and setFooAtX:Y: methods. This plays havoc with
// inheritance, of course.
#define discrete2dSiteAt(l, offsets, x, y) ((l) + (offsets)[(y)] + (x))
