SUBDIRS = tk
MODULE = tkobjc
CURRENT = 4
REVISION = 0
AGE = 0
tkobjcdir = $(includedir)/$(MODULE)

include $(top_srcdir)/src/Makefile.rules

TCLFILES = analysis.tcl comm.tcl simtools.tcl tkbusy.tcl
XPMFILES = schedule.xpm trigger.xpm

EXTRA_DIST = $(TCLFILES) $(XPMFILES)

XPMINCLUDES = @XPMINCLUDES@
TCLINCLUDES = @TCLINCLUDES@
TKINCLUDES = @TKINCLUDES@
ZLIBINCLUDES = @ZLIBINCLUDES@
PNGINCLUDES = @PNGINCLUDES@

INCLUDES = -I$(top_builddir)/libobjc -I$(top_srcdir)/libobjc -I$(srcdir)/../collections -I$(srcdir)/../defobj -I$(srcdir)/../objectbase -I.. -I$(srcdir)/.. -I$(srcdir)/../gui -I$(srcdir)/../misc -I$(srcdir)/../activity -I$(srcdir)/../tclobjc $(TKINCLUDES) $(TCLINCLUDES) $(XPMINCLUDES) $(PNGINCLUDES) $(ZLIBINCLUDES)

override OBJCFLAGS += $(X_CFLAGS) @CFLAGS_NOWARN_IMPLICIT_INT@

noinst_LTLIBRARIES = @noinst_LIBS@
lib_LTLIBRARIES = @inst_LIBS@
EXTRA_LTLIBRARIES = libtkobjc.la

SRC = ArchivedGeometryWidget.m Button.m ButtonPanel.m \
	Canvas.m CanvasAbstractItem.m CanvasItem.m CheckButton.m Circle.m \
	ClassDisplayHideButton.m ClassDisplayLabel.m Colormap.m \
	CompleteProbeDisplayLabel.m CompositeItem.m Entry.m Form.m Frame.m \
	Graph.m Histogram.m InputWidget.m Label.m Line.m LinkItem.m \
	MessageProbeEntry.m NodeItem.m OvalNodeItem.m Pixmap.m ProbeCanvas.m \
	Raster.m Rectangle.m RectangleNodeItem.m \
	ScheduleItem.m SimpleProbeDisplayHideButton.m SuperButton.m \
	TextItem.m TkExtra.m \
	VarProbeEntry.m VarProbeLabel.m Widget.m WindowGeometryRecord.m \
	ZoomRaster.m common.m internal.m tkobjc.m win32dib.c

libtkobjc_la_SOURCES = $(SRC)
libtkobjc_la_LDFLAGS = @inst_LDFLAGS@

tkobjc_HEADERS = ArchivedGeometryWidget.h Button.h ButtonPanel.h Canvas.h \
	CanvasAbstractItem.h CanvasItem.h CheckButton.h Circle.h \
	ClassDisplayHideButton.h ClassDisplayLabel.h Colormap.h \
	CompleteProbeDisplayLabel.h CompositeItem.h Entry.h Form.h Frame.h \
	Graph.h Histogram.h InputWidget.h Label.h Line.h LinkItem.h \
	MessageProbeEntry.h NodeItem.h OvalNodeItem.h \
	Pixmap.h ProbeCanvas.h \
	Raster.h Rectangle.h RectangleNodeItem.h \
	ScheduleItem.h SimpleProbeDisplayHideButton.h SuperButton.h \
	TextItem.h TkExtra.h \
	VarProbeEntry.h VarProbeLabel.h Widget.h WindowGeometryRecord.h \
	ZoomRaster.h common.h global.h internal.h win32dib.h

tkobjc.lo: $(foreach f, $(TCLFILES), $(basename $(f))_tcl.x)

%_tcl.x: %.tcl
	(echo 'const char *$(notdir $(basename $<))_tcl = "' ; cat $< | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g' ; echo '";' ) > $@ 
