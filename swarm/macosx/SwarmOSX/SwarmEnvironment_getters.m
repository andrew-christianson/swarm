- (id <Arguments>)getArguments
{
  return arguments;
}
- (id <Symbol>)getStart
{
  return Start;
}
- (id <Symbol>)getMember
{
  return Member;
}
- (id <Symbol>)getEnd
{
  return End;
}
- (id <Symbol>)getInitialized
{
  return Initialized;
}
- (id <Symbol>)getRunning
{
  return Running;
}
- (id <Symbol>)getStopped
{
  return Stopped;
}
- (id <Symbol>)getHolding
{
  return Holding;
}
- (id <Symbol>)getReleased
{
  return Released;
}
- (id <Symbol>)getTerminated
{
  return Terminated;
}
- (id <Symbol>)getCompleted
{
  return Completed;
}
- (id <Symbol>)getRandomized
{
  return Randomized;
}
- (id <Symbol>)getSequential
{
  return Sequential;
}
#if !SWARM_OSX /* TODO */
- (id <Symbol>)getControlStateRunning
{
  return ControlStateRunning;
}
- (id <Symbol>)getControlStateStopped
{
  return ControlStateStopped;
}
- (id <Symbol>)getControlStateStepping
{
  return ControlStateStepping;
}
- (id <Symbol>)getControlStateQuit
{
  return ControlStateQuit;
}
- (id <Symbol>)getControlStateNextTime
{
  return ControlStateNextTime;
}
#endif
- (id <Zone>)getScratchZone
{
  return scratchZone;
}
- (id <Zone>)getGlobalZone
{
  return globalZone;
}
- (id <MT19937gen>)getRandomGenerator
{
  return randomGenerator;
}
- (id <UniformIntegerDist>)getUniformIntRand
{
  return uniformIntRand;
}
- (id <UniformDoubleDist>)getUniformDblRand
{
  return uniformDblRand;
}
- (id <ProbeLibrary>)getProbeLibrary
{
  return probeLibrary;
}
#if !SWARM_OSX /* TODO */
- (id <ProbeDisplayManager>)getProbeDisplayManager
{
  return probeDisplayManager;
}
#endif
- (id <Archiver>)getHdf5Archiver
{
  return hdf5Archiver;
}
- (id <Archiver>)getLispArchiver
{
  return lispArchiver;
}
- (id <Archiver>)getHdf5AppArchiver
{
  return hdf5AppArchiver;
}
- (id <Archiver>)getLispAppArchiver
{
  return lispAppArchiver;
}
- (BOOL)getGuiFlag
{
  return swarmGUIMode;
}
- (id <Symbol>)getLanguageCOM
{
  return LanguageCOM;
}
- (id <Symbol>)getLanguageJava
{
  return LanguageJava;
}
- (id <Symbol>)getLanguageObjc
{
  return LanguageObjc;
}
