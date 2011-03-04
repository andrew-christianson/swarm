/* All Rights reserved */

#include <AppKit/AppKit.h>

@interface HeatbugsController : NSObject
{
  id infoPanel;
  id inspectorPanel;
  NSMutableArray *simulations;
}

- (void) dropSimulation: (id)sender;
- (void) stepSimulation: (id)sender;
- (void) stopSimulation: (id)sender;
- (void) newSimulation: (id)sender;
- (void) startSimulation: (id)sender;

- (void) showInfoPanel: (id)sender;
- (void) showInspectorPanel: (id)sender;

@end
