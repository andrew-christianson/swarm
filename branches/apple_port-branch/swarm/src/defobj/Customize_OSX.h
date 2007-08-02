// Swarm library. Copyright ? 1996-2000 Swarm Development Group.
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful, but
// WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
// General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
// USA
// 
// The Swarm Development Group can be reached via our website at:
// http://www.swarm.org/

/*
Name:         Customize_OSX.h
Description:  superclass to implement create-phase customization
Library:      defobj
*/

#import "DefObject.h"
#import "DefClass.h"

extern id _obj_initZone;  // currently receives generated classes

void _obj_splitPhases (Class_s *class);

//. FIXME: Move this back to GENERIC file and add it in here as an `extern' but how?
//
// objects to save createBy actions generated customizeBegin/End
//
@interface CreateBy_c: Object_s
{
@public
  id implementedType; // type of object created by CreateBy object
  id createReceiver;  // receiver for message
  SEL createMessage;  // selector from setCreateMessage:, or nil
  IMP createMethod;   // cached method for createMessage selector
  id recustomize;     // object to handle further create, if any
}
@end
//@class CreateBy_c;

@interface Customize_s: Object_s
@end

@interface Create_byboth: CreateBy_c
- create: aZone;
@end

//. vim: syntax=objc
