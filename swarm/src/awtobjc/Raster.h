// Swarm library. Copyright (C) 1996-1998, 2000 Swarm Development Group.
// This library is distributed without any warranty; without even the
// implied warranty of merchantability or fitness for a particular purpose.
// See file LICENSE for details and terms of copying.

// Objective C interface to Raster, for use with tclobjc

#import <awtobjc/ArchivedGeometryWidget.h>
#import <gui.h>

// this could include a list of environments (graphics contexts)
@interface Raster: ArchivedGeometryWidget
{
  unsigned width, height;
  id <Colormap> colormap;
  PixelValue *map;
  id button1Client, button2Client, button3Client;
  SEL button1Sel, button2Sel, button3Sel;

  jmethodID _erase, _drawPoint, _fillRectangle, _drawSelf;
}

- setColormap: (id <Colormap>)colormap;
- drawPointX: (int)x Y: (int)y Color: (Color)c;
- fillRectangleX0: (int)x0 Y0: (int)y0 X1: (int)x1 Y1: (int)y1 Color: (Color)c;
- drawSelf;
- erase;
- setButton: (int)n Client: c Message: (SEL)s;
@end
