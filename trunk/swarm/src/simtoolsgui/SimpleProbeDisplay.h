// Swarm library. Copyright � 1996-2000 Swarm Development Group.
// This library is distributed without any warranty; without even the
// implied warranty of merchantability or fitness for a particular purpose.
// See file LICENSE for details and terms of copying.

#import <simtoolsgui/SingleProbeDisplay.h>
#import <objectbase.h>
#import <gui.h>

@interface SimpleProbeDisplay: SingleProbeDisplay
{
  id <ProbeMap> probeMap;
  id <Frame> top_top_Frame, raisedFrame;
  id <Frame> leftFrame, rightFrame, middleFrame, bottomFrame;
  id <CompleteProbeDisplayLabel> title;
  id <SimpleProbeDisplayHideButton> hideB;
  unsigned count;
  id <Widget> *widgets;
}

- setProbeMap: (id <ProbeMap>)probeMap;
- createEnd;
- (id <ProbeMap>)getProbeMap;
- (void)update;
- (void)drop;
@end
