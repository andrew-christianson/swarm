// Swarm library. Copyright (C) 1996-1999 Santa Fe Institute.
// This library is distributed without any warranty; without even the
// implied warranty of merchantability or fitness for a particular purpose.
// See file LICENSE for details and terms of copying.

#import <objectbase/SwarmObject.h>
#include <misc/argp.h>

@interface Arguments: SwarmObject
{
  int argc;
  const char **argv;
  const char *applicationName;
  const char *appModeString;
  BOOL batchModeFlag;
  BOOL varySeedFlag;
  BOOL showCurrentTimeFlag;
  const char *swarmHome;
  const char *defaultAppConfigPath;
  const char *defaultAppDataPath;
  BOOL ignoringEnvFlag;
}
+ createArgc: (int)argc Argv: (const char **)argv version: (const char *)version bugAddress: (const char *)bugAddress;
- (struct argp_option *)addOptions: (struct argp_option *)options;
- (int)parseKey: (int)key arg: (const char *)arg;

- setArgc: (int)theArgc Argv: (const char **)theArgv;
- setAppName: (const char *)appName;
- setAppModeString: (const char *)appModeString;
- setBatchModeFlag: (BOOL)batchModeFlag;
- setShowCurrentTimeFlag: (BOOL)timeFlag;
- setVarySeedFlag: (BOOL)varySeedFlag;
- setDefaultAppConfigPath: (const char *)path;
- setDefaultAppDataPath: (const char *)path;

- (BOOL)getBatchModeFlag;
- (BOOL)getVarySeedFlag;
- (BOOL)getShowCurrentTimeFlag;
- (const char *)getAppName;
- (const char *)getAppModeString;
- (int)getArgc;
- (const char **)getArgv;
- (const char *)getExecutablePath;
- (const char *)getSwarmHome;
- (const char *)getConfigPath;
- (const char *)getDataPath;
- (const char *)getAppConfigPath;
- (const char *)getAppDataPath;
@end
