#ifndef __swarmBase_h__
#define __swarmBase_h__
#include "nsIXPConnect.h"
#include "swarmIBase.h"

class swarmBase: public swarmIBase
{
  nsCOMPtr <nsIXPConnectWrappedNative> wrapper;

 public:
 NS_DECL_SWARMIBASE
 virtual ~swarmBase ();
};
#endif