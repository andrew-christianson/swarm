// Swarm library. Copyright � 1996-2000 Swarm Development Group.
// This library is distributed without any warranty; without even the
// implied warranty of merchantability or fitness for a particular purpose.
// See file LICENSE for details and terms of copying.

#import <tkobjc/CompositeItem.h>
#import <gui.h>

@interface LinkItem: CompositeItem <LinkItem>
{
  id from, to;
  const char *line1, *line2;
}

- setFrom: from;
- setTo: to;
- createItem;

- setColor: (const char *)aColor;
- update;

@end
