// Swarm library. Copyright (C) 1996-1998 Santa Fe Institute.
// This library is distributed without any warranty; without even the
// implied warranty of merchantability or fitness for a particular purpose.
// See file LICENSE for details and terms of copying.

// quickie interface for a control panel of buttons

#import <tkobjc/Widget.h>

@interface Button : Widget
{
}

- setText: (const char *)text;		  // give the button a name
- setCommand: (const char *)command;	  // give the button a cmd

@end