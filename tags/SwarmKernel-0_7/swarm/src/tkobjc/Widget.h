// Swarm library. Copyright (C) 1996 Santa Fe Institute.
// This library is distributed without any warranty; without even the
// implied warranty of merchantability or fitness for a particular purpose.
// See file LICENSE for details and terms of copying.

// Objective C interface for arbitrary Tk Widgets

#import <defobj.h>
#import <defobj/Create.h>

@interface Widget : CreateDrop {
  Widget * parent;
  char * widgetName;
  char * objcName;
}

// creation time messages
-setParent: (Widget *) p;			  // set parent widget
-createEnd;					  // finalize creation
+createParent: (Widget *)p;			  // convenience interface

-(char *) getWidgetName;			  // return the widget name
-(char *) getObjcName;				  // return the tclobjc name
-(Widget *) getParent;				  // return the parent
-(Widget *) getTopLevel;			  // return the top parent

-(const char *) getWindowGeometry;		  // get geometry as a string
-(unsigned) getWidth;				  // get geometry values
-(unsigned) getHeight;
-(int) getPositionX;
-(int) getPositionY;

-setWidth: (int) w Height: (int) h;		  // set size
-setWidth: (int) w;
-setHeight: (int) h;
-setWindowGeometry: (char *) s;			  // set geometry as a string
-setPositionX: (int) x Y: (int) y;		  // set window position.

-setWindowTitle: (char *) s;			  // window manager title

-pack;						  // display the widget
-packWith: (char *) c;				  // display, args.
-unpack;					  // unmap the widget

-makeNameFromParentName: (char *) p;		  // make name for widget

@end
