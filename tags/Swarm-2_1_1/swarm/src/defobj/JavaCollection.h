// Swarm library. Copyright � 2000 Swarm Development Group.
// This library is distributed without any warranty; without even the
// implied warranty of merchantability or fitness for a particular purpose.
// See file LICENSE for details and terms of copying.

#import <defobj.h>
#import <defobj/Create.h>

@interface JavaCollection: CreateDrop
{
}
#ifdef HAVE_JDK
- (BOOL)isJavaCollection;
- (unsigned)getCount;
- begin: aZone;
- beginPermuted: aZone;
- getFirst;
- (void)forEach: (SEL)sel :arg1;
#endif
@end