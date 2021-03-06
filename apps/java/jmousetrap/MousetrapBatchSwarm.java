// Java mousetrap application. Copyright � 1999-2000 Swarm Development Group.
// This application is distributed without any warranty; without even
// the implied warranty of merchantability or fitness for a particular
// purpose.  See file COPYING for details and terms of copying.

import swarm.objectbase.SwarmImpl;

import swarm.Globals;
import swarm.Selector;
import swarm.defobj.Zone;
import swarm.activity.ActionGroup;
import swarm.activity.ActionGroupImpl;
import swarm.activity.Activity;
import swarm.activity.Schedule;
import swarm.objectbase.Swarm;
import swarm.activity.ScheduleImpl;

import swarm.analysis.EZGraph;
import swarm.analysis.EZGraphImpl;

public class MousetrapBatchSwarm extends SwarmImpl {
  int loggingFrequency = 1;		     // Frequency of fileI/O
  
  ActionGroup displayActions;	     // schedule data structs
  Schedule displaySchedule;
  
  MousetrapModelSwarm mousetrapModelSwarm;   // the Swarm we're observing
  
  EZGraph triggerGraph;

  public MousetrapBatchSwarm (Zone aZone) {
    super (aZone);
  }
  
  public Object buildObjects ()   {
    super.buildObjects();

    mousetrapModelSwarm = new MousetrapModelSwarm (getZone ());

    mousetrapModelSwarm.buildObjects ();
      
    triggerGraph = new EZGraphImpl (getZone (), true);

    try {
      triggerGraph.createSequence$withFeedFrom$andSelector
        ("trigger.output", mousetrapModelSwarm.getStats(), 
         new Selector (mousetrapModelSwarm.getStats().getClass(), 
                       "getNumTriggered", false));
      
      triggerGraph.createSequence$withFeedFrom$andSelector
        ("delta-trigger.output", mousetrapModelSwarm.getStats(), 
         new Selector (mousetrapModelSwarm.getStats().getClass(), 
                       "getNumBalls", false));
      
    } catch (Exception e) {
      System.err.println ("Exception EZGraph: " + e.getMessage ());
    }
    
    return this;
  }  

  public Object buildActions () {
    super.buildActions ();
    
    mousetrapModelSwarm.buildActions ();
    
    if (loggingFrequency > 0) {
      
      displayActions = new ActionGroupImpl (getZone ());
      
      try {
        displayActions.createActionTo$message 
          (triggerGraph, 
           new Selector (triggerGraph.getClass (), "step", true));
        displayActions.createActionTo$message
          (this,
           new Selector (getClass (), "checkToStop", false));
      } catch (Exception e) {
        System.err.println ("Exception batch EZGraph: " + e.getMessage ());
      }
      
      displaySchedule = new ScheduleImpl (getZone (), loggingFrequency);
      
      displaySchedule.at$createAction (0, displayActions);
    }
    
    return this;
  }

  public Activity activateIn (Swarm swarmContext) {
    super.activateIn (swarmContext);
    
    mousetrapModelSwarm.activateIn (this);
    
    if (loggingFrequency > 0)
      displaySchedule.activateIn (this);
    
    return getActivity ();
  }
  
  public Object go () {
    System.out.println
      ("You typed `mousetrap --batchmode' or `mousetrap -b'," 
       + " so we're running without graphics.");
    
    System.out.println ("mousetrap is running to completion.");
    
    if (loggingFrequency > 0) 
      System.out.println 
        ("It is logging data every " + loggingFrequency +
         " timesteps to: trigger.output");
    
    getActivity ().getSwarmActivity ().run (); 
    
    if (loggingFrequency > 0)
      triggerGraph.drop ();
    
    return getActivity ().getStatus ();
  }
  
  public Object checkToStop () {
    if (mousetrapModelSwarm.getStats ().getNumBalls () == 0) {
      System.out.println ("All the balls have landed!");
      Globals.env.getCurrentSwarmActivity ().terminate (); 
    }
    return this;
  }
}
