// Swarm library. Copyright � 1996-2000 Swarm Development Group.
// This library is distributed without any warranty; without even the
// implied warranty of merchantability or fitness for a particular purpose.
// See file LICENSE for details and terms of copying.

#import <analysis/Averager.h>
#import <collections.h>
#import <defobj/defalloc.h> // getZone, getCZone
#include <misc.h> // sqrt

#define NEXT(index) nextImp(index, M(next))
#define GETLOC(index) ((id) getLocImp (index, M(getLoc)))
#define ADD(val) addImp (self, M(addValueToAverage:), val)
#define CALL(target) callImp (self, M(doubleDynamicCallOn:), target)

@implementation Averager

PHASE(Creating)

- setCollection: obj
{
  target = obj;
  return self;
}

- setWidth: (unsigned)width
{
  maWidth = width;
  return self;
}

- createEnd
{
  isList = [target respondsTo: M(getFirst)];

  total = 0.0;
  totalSquared = 0.0;
  count = 0;
  totalCount = 0;
  min = 0.0;
  max = 0.0;

  if (target == nil)
    raiseEvent (InvalidCombination, "Averager created without a target\n");
  
  if (maWidth == 0 && !isList)
    raiseEvent (InvalidCombination,
                "Averages of non-collections must having a interval width\n");
  
  if (maWidth > 0)
    {
      unsigned i;

      if (isList)
        maWidth *= [target getCount];

      maData = [getZone (self) allocBlock: maWidth * sizeof (double)];

      for (i = 0; i < maWidth; i++)
        maData[i] = 0.0;

      maTotal = 0.0;
      maTotalSquared = 0.0;
    }


  {
    id protoIndex = [target begin: getCZone (getZone (self))];

    nextImp = [protoIndex methodFor: M(next)];
    getLocImp = [protoIndex methodFor: M(getLoc)];
    
    [protoIndex drop];
  }
  callImp = [self methodFor: M(doubleDynamicCallOn:)];
  addImp = [self methodFor: M(addValueToAverage:)];
  
  setMappedAlloc (self);
  return [super createEnd];
}

PHASE(Setting)

PHASE(Using)

- (void)addValueToAverage: (double)v
{
  total += v;
  totalSquared += v * v;

  if (totalCount == 0)
    max = min = v;
  else
    {
      if (v > max)
        max = v;
      else if (v < min)
        min = v;
    }
  if (maWidth > 0)
    {
      if (totalCount < maWidth)
        {
          maTotal += v;
          maTotalSquared += v * v;
          maData[totalCount] = v;
        }
      else
        {
          unsigned maPos = totalCount % maWidth;
          double obsolete = maData[maPos];
      
          maTotal = maTotal - obsolete + v; 
          maTotalSquared = (maTotalSquared - 
                            obsolete * obsolete +
                            v * v);
          maData[maPos] = v;
        }
    }
  count++;
  totalCount++;
}

- (void)update
{
  if (isList)
    {
      count = 0;
      total = 0.0;
      totalSquared = 0.0;
      min = max = 0.0;
      
      {
        id <Index> iter;
        id obj;
        
        iter = [target begin: getCZone (getZone (self))];
        for (obj = NEXT (iter); GETLOC (iter) == (id) Member; obj = NEXT (iter))
          ADD (CALL (obj));
        [iter drop];
      }
    }
  else
    ADD (CALL (target));
}

- (double)getAverage
{
  if (count)
    return total / (double) count;
  else 
    return 0.0;
} 

- (double)getMovingAverage
{
  if (totalCount == 0)
    return 0.0;

  return maTotal / ((totalCount < maWidth) ? totalCount : maWidth);
}


- (double)getVariance
{
  double mean = total / (double) count;

  return (((double) count / ((double) (count - 1))) * 
          (totalSquared / (double) count - mean * mean));
}

- (double)getMovingVariance
{
  double movingMean = [self getMovingAverage];
  double actualCount = (totalCount < maWidth) ? totalCount : maWidth;

  return (((double) actualCount / ((double) (actualCount - 1))) * 
          (maTotalSquared / (double) totalCount - movingMean * movingMean));
}

- (double)getStdDev
{
  return sqrt ([self getVariance]);
}

- (double)getMovingStdDev
{
  return sqrt ([self getMovingVariance]);
}

- (double)getTotal
{
  return total;
}

- (double)getMax
{
  return max;
}

- (double)getMin
{
  return min;
}

- (unsigned)getCount 
{
  return count;
}

- (void)mapAllocations: (mapalloc_t)mapalloc
{
  mapalloc->size = maWidth * sizeof (double);
  mapAlloc (mapalloc, maData);
}

@end
