// Swarm library. Copyright � 1996-2000 Swarm Development Group.
// This library is distributed without any warranty; without even the
// implied warranty of merchantability or fitness for a particular purpose.
// See file LICENSE for details and terms of copying.

#import <tkobjc/Widget.h>
#import <gui.h>

@interface ArchivedGeometryWidget: Widget <ArchivedGeometryWidget>
{
  const char *windowGeometryRecordName;
  BOOL saveSizeFlag;
}

- setWindowGeometryRecordName: (const char *)recordName;
- setSaveSizeFlag: (BOOL)saveSizeFlag;
- loadWindowGeometryRecord;
- updateArchiver: archiver;
- createEnd;
- registerAndLoad;
- (void)drop;

@end