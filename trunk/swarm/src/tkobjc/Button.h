// Swarm library. Copyright � 1996-2000 Swarm Development Group.
// This library is distributed without any warranty; without even the
// implied warranty of merchantability or fitness for a particular purpose.
// See file LICENSE for details and terms of copying.

#import <tkobjc/Widget.h>
#import <gui.h>

@interface Button: Widget <Button>
{
}

- (void)setText: (const char *)text;
- (void)setButtonTarget: target method: (SEL)sel;

@end
