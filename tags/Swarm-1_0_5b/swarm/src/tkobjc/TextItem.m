// Swarm library. Copyright (C) 1996-1998 Santa Fe Institute.
// This library is distributed without any warranty; without even the
// implied warranty of merchantability or fitness for a particular purpose.
// See file LICENSE for details and terms of copying.

#define __USE_FIXED_PROTOTYPES__  // for gcc headers

#include <string.h>
#include <stdio.h>
#include <stdlib.h>

#import <tkobjc/TextItem.h>

@implementation TextItem

- setX: (int) the_x Y: (int) the_y
{
  x = the_x ;
  y = the_y ;
  return self ;
}

- setText: (const char *)the_text
{
  text = the_text ;
  return self ;
}
 
- createItem
{
  [globalTkInterp eval: 
    "%s create text %d %d -text \"%s\" -anchor c", 
                  [canvas getWidgetName],x,y,text];
  
  item = strdup ([globalTkInterp result]);
  
  return self;
}

@end

