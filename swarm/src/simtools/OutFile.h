// Swarm library. Copyright � 1996-2000 Swarm Development Group.
// This library is distributed without any warranty; without even the
// implied warranty of merchantability or fitness for a particular purpose.
// See file LICENSE for details and terms of copying.

#import <simtools.h> // OutFile
#import <objectbase/SwarmObject.h>

@interface OutFile: SwarmObject <OutFile>
{
  FILE *theFile;
}

+ create: aZone setName: (const char *)theName;
+ create: aZone withName: (const char *)theName;

- _setFile_: (FILE *)aFile;
- (FILE *)_getFile_;

- putString: (const char *)aString;
- putInt: (int) anInt;
- putUnsigned: (unsigned) anUnsigned;
- putLong: (long) aLong;
- putUnsignedLong: (unsigned long) anUnsLong;
- putDouble: (double) aDouble;
- putFloat: (float) aFloat;
- putChar: (char) aChar;
- putTab;
- putNewLine;

@end
