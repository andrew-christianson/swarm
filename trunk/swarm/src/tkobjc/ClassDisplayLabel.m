// Swarm library. Copyright � 1996-1999 Santa Fe Institute.
// This library is distributed without any warranty; without even the
// implied warranty of merchantability or fitness for a particular purpose.
// See file LICENSE for details and terms of copying.

#import <tkobjc/global.h>
#import <tkobjc/ClassDisplayLabel.h>

@implementation ClassDisplayLabel

PHASE(Creating)

- createEnd
{
  [super createEnd];

  [globalTkInterp eval: "%s configure -anchor w", widgetName];
  [globalTkInterp eval: "%s configure -foreground blue", widgetName];

  return self;
}

PHASE (Using)

@end
