SUBDIRS = misc collections defobj activity objectbase $(TCLTKGUIDIR) gui random simtools simtoolsgui analysis space $(GNUSTEPMODULE)

SWARMMODULES = space analysis $(GNUSTEPMODULE) $(SIMTOOLSGUIMODULE) simtools random $(TCLTKGUIDIR) objectbase activity defobj collections misc

EXTRA_DIST = Makefile.rules getters.el SwarmEnvironment_getters.m

.PHONY: headers

all-recursive: headers

#EXTRA_PROGRAMS = swarm.dll
#bin_PROGRAMS = @SWARM_DLL@

headers: SwarmEnvironment_getters.m
	for i in $(SUBDIRS) ; do $(MAKE) -C $$i headers ; done

# pacify automake
SUPPORTLDFLAGS = 

 include $(top_builddir)/etc/Makefile.common

override CPPFLAGS += -DBUILDING_SWARM
override OBJCFLAGS += @CFLAGS_NOWARN_UNKNOWN_PRAGMAS@

CURRENT = 0
REVISION = 0
AGE = 0

lib_LTLIBRARIES = @LIBSWARM_LA@
EXTRA_LTLIBRARIES = libswarm.la
libswarm_la_DEPENDENCIES = $(foreach module,$(SWARMMODULES),$(module)/lib$(module).la)

libswarm_la_SOURCES = SwarmEnvironment.m

include_HEADERS = swarm.h SwarmEnvironment.h SwarmEnvironment_getters.h

SwarmEnvironment.lo: SwarmEnvironment_getters.m

SwarmEnvironment_getters.m: swarm.h

 include $(top_srcdir)/etc/Makefile.protocol

getters.elc: $(abs_top_builddir)/protocol.elc $(abs_top_builddir)/interface.elc

$(abs_top_builddir)/interface.elc: $(abs_top_builddir)/protocol.elc

$(srcdir)/SwarmEnvironment_getters.m: swarm.h getters.elc
	$(ENVEMACS) -batch -l '$(dos_abs_builddir)@PATHDELIM@getters.elc' -f generate-SwarmEnvironment-getters

LIBS = $(foreach module,$(SWARMMODULES),-l$(module)) -lobjc $(SYSLIBS)

INCLUDES = $(LIBOBJCINCLUDES) -I$(srcdir)/collections -I$(srcdir)/defobj -I$(srcdir)/activity -I$(srcdir)/objectbase -I$(srcdir)/random -I$(srcdir)/simtools -I$(srcdir)/gui -I$(srcdir)/simtoolsgui -I$(srcdir)/misc -I. -I$(srcdir) $(JAVAINCLUDES) $(GNUSTEPLIBINCLUDES)

libswarm_la_LDFLAGS = -version-info $(CURRENT):$(REVISION):$(AGE) -rpath $(DESTDIR)$(libdir) $(foreach module,$(SWARMMODULES),-L$(module)) $(LIBOBJCLDFLAGS) $(SUPPORTLDFLAGS) # -L$(dir $(shell $(CC) -print-libgcc-file-name)) 

DLLWRAP = @DLLWRAP@
if USEDLL
OBJS = $(foreach module,$(SWARMMODULES),$(module)/*.lo) SwarmEnvironment.lo

swarm.dll: swarm.dll.c $(OBJS)
	$(CC) -g -c $(srcdir)/swarm.dll.c
	$(DLLWRAP) --export-all-symbols --output-def swarm.def --implib libswarmdll.a --driver-name $(CC) -o swarm.dll swarm.dll.o $(OBJS) ../avcall/avcall.o ../avcall/avcall-i386-msvc.o -L../libobjc $(SUPPORTLDFLAGS) -lobjcdll $(filter-out $(FFILIB),$(SYSLIBS)) 

#$(CC) -nostdlib -Wl,-shared -Wl,--export-all-symbols -Wl,--out-implib,libswarmdll.a -Wl,--output-def,swarm.def -o swarm.dll swarm.dll.o $(patsubst %.lo,%.o,$(OBJS)) -L../libobjc $(SUPPORTLDFLAGS) -lobjcdll $(SYSLIBS) -lcygwin -lkernel32 `$(CC) -print-libgcc-file-name`

install-data-local: 
	$(INSTALL) libswarmdll.a $(DESTDIR)$(libdir)
	ranlib $(DESTDIR)$(libdir)/libswarmdll.a
endif

