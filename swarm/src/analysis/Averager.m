// Swarm library. Copyright (C) 1996-1998 Santa Fe Institute.
// This library is distributed without any warranty; without even the
// implied warranty of merchantability or fitness for a particular purpose.
// See file LICENSE for details and terms of copying.

#import <collections.h>
#import <analysis/Averager.h>

// Implemenation of data collection facilities. Code like this
// eventually belongs in the Swarm libraries.

// Averager: averages together data, gives the data to whomever asks.
@implementation Averager

//* The setCollection method sets the collection of objects that will be 
//* probed.
- setCollection: l
{
  collection = l;
  return self;
}

- createEnd
{
  if (collection == nil)
    [InvalidCombination raiseEvent: "Averager created without a collection\n"];

  return [super createEnd];
}

//* The update method runs through the collection calling the selector on 
//* each object.
- update
{
  id iter, obj;

  total = 0.0;
  count = 0;

  // special case empty collection.
  if ([collection getCount] == 0)
    {
      min = 0;
      max = 0;
      return self;
    }
  
  obj = [collection getFirst];
  
  max = [self doubleDynamicCallOn: obj];
  min = max;
  
  // Ok, we have cached our function to call on each object - do it.
  // note that we don't do lookup for each step: this code only works
  // if the collection is homogeneous.
  iter = [collection begin: [self getZone]];
  while ((obj = [iter next]) != nil)
    {
      double v = [self doubleDynamicCallOn: obj];
      
      total += v;
      if (v > max)
        max = v;
      if (v < min)
        min = v;
      count++;
    }
  
  [iter drop];
  
  return self;
}

//* The getAverage method averages the values the averager collects. The total
//* and count are read out of the object to compute the average.
- (double)getAverage
{
  if (count)
    return total / (double)count;
  else 
    return 0.0;
} 

//* The getTotal method sums the values the averager collects. The value is 
//* read out of the object, not computed everytime it is asked for.
- (double)getTotal
{
  return total;
}

//* The getMax method returns the maximum value the averager collects. The 
//* value is read out of the object, not computed everytime it is asked for.
- (double)getMax
{
  return max;
}

//* The getMin method returns the minimum value the averager collects. The 
//* value is read out of the object, not computed everytime it is asked for.
- (double)getMin
{
  return min;
}

//* The getCount method returns the number of values the averager collects. 
- (int)getCount 
{
  return count;
}

@end
