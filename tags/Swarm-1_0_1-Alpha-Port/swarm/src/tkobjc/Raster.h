// Swarm library. Copyright (C) 1996 Santa Fe Institute.
// This library is distributed without any warranty; without even the
// implied warranty of merchantability or fitness for a particular purpose.
// See file LICENSE for details and terms of copying.

// Objective C interface to Raster, for use with libtclobjc

#import <tkobjc/Widget.h>
#import <tk.h>
#import <tkobjc/XColormap.h>
#import <tkobjc/XDrawer.h>

#define ButtonLeft 1
#define ButtonMiddle 2
#define ButtonRight 3

// this could include a list of environments (graphics contexts)
@interface Raster : Widget {
  Tk_Window tkwin;
  Display * display;
  Window xwin;
  int width, height;
  GC gc;
  Pixmap pm;
  XColormap * colormap;
  PixelValue * map;
  id button1Client, button2Client, button3Client;
  SEL button1Sel, button2Sel, button3Sel;
}

-(Display *) getDisplay;
-(XColormap *) getColormap;
-setColormap: (XColormap *) colormap;
-drawPointX: (int) x Y: (int) y Color: (Color) c;
-fillRectangleX0: (int) x0 Y0: (int) y0 X1: (int) x1 Y1: (int) y1 Color: (Color) c;
-draw: (id <XDrawer>) xd X: (int) x Y: (int) y;
-drawSelf;
-erase;
-handleButton: (int) n X: (long) x Y: (long) y;
-setButton: (int) n Client: c Message: (SEL) s;
@end