// Swarm library. Copyright (C) 1996-1998 Santa Fe Institute.
// This library is distributed without any warranty; without even the
// implied warranty of merchantability or fitness for a particular purpose.
// See file LICENSE for details and terms of copying.

/*
Name:         OutputStream.m
Description:  character string object   
Library:      collections
*/

#import <collections/OutputStream.h>
#include <misc.h> // FILE, fputs

@implementation OutputStream_c

PHASE(Creating)

+ createBegin: aZone
{
  OutputStream_c  *newStream;

  newStream = [aZone allocIVars: self];
  return newStream;
}

- (void) setFileStream: (FILE *)file
{
  fileStream = file;
}

- createEnd
{
  createByCopy ();
  setNextPhase (self);
  return self;
}

+ create: aZone setFileStream: (FILE *)file
{
  OutputStream_c  *newStream;

  newStream = [aZone allocIVars: getNextPhase (self)];
  newStream->fileStream = file;
  return newStream;
}

PHASE(Using)

- (FILE *)getFileStream
{
  return fileStream;
}

- (void)catC: (const char *)cstring
{
  fputs (cstring, fileStream);
}

@end