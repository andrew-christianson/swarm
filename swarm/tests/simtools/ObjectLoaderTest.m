// Swarm library. Copyright (C) 1996 Santa Fe Institute.
// This library is distributed without any warranty; without even the
// implied warranty of merchantability or fitness for a particular purpose.
// See file LICENSE for details and terms of copying.

#import <stdio.h>
#import <stdlib.h>
#import <simtools.h>
#import "TestObject.h"

int
main(int argc, const char ** argv) 
{
  TestObject * theObj;
  char fileName[128];

  initSwarmBatch(argc, argv);

  theObj = [TestObject createBegin: globalZone];
  theObj =[theObj createEnd];

  sprintf(fileName, "%s/test.data", getenv("srcdir"));
  
  [ObjectLoader load: theObj fromFileNamed: fileName];

  [theObj printObject];

  return 0;
}


