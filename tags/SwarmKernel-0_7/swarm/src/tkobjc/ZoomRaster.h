// Swarm library. Copyright (C) 1996 Santa Fe Institute.
// This library is distributed without any warranty; without even the
// implied warranty of merchantability or fitness for a particular purpose.
// See file LICENSE for details and terms of copying.

// Objective C interface for a Raster with a zoom factor.

#import <tkobjc/Raster.h>
#import <tkobjc/Frame.h>

@interface ZoomRaster: Raster {
  int zoomFactor;
  int logicalWidth, logicalHeight;
}

-increaseZoom;
-decreaseZoom;
-(int) getZoomFactor;
-setZoomFactor: (int) z;
-handleConfigureWidth: (int) newWidth Height: (int) newHeight;

@end