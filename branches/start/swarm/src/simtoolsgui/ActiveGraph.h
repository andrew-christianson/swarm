// Swarm library. Copyright (C) 1996-1998 Santa Fe Institute.
// This library is distributed without any warranty; without even the
// implied warranty of merchantability or fitness for a particular purpose.
// See file LICENSE for details and terms of copying.

#import <objectbase/MessageProbe.h>
#import <gui.h>

// A graph that fetches its data, draws it on a GraphElement
@interface ActiveGraph: MessageProbe
{
  id <GraphElement> element;			  // element to draw on
  id dataFeed;					  // object to read from
}

- setElement: (id <GraphElement>)ge;
- setDataFeed: d;
- step;
@end