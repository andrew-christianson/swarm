// Swarm library. Copyright (C) 1996-1997 Santa Fe Institute.
// This library is distributed without any warranty; without even the
// implied warranty of merchantability or fitness for a particular purpose.
// See file LICENSE for details and terms of copying.

#import <objectbase/SwarmObject.h>

#import <tkobjc/CompositeItem.h>

@interface NodeItem: CompositeItem {
  int x,y ;
  char *text ;
  char *item ;
  char *string ;
}

-setX: (int) x Y: (int) y ;
-(int) getX ;
-(int) getY ;
-setString: (char *) string ;
-setColor: (char *) aColor ;
-setBorderColor: (char *) aColor ;
-setBorderWidth: (int) aVal ;
-createBindings ;
@end

