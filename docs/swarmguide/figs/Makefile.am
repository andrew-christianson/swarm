GS = @GS@
GS_LIB = @GS_LIB@
CJPEG = @CJPEG@ -quality 100
PNGTOPNM = @PNGTOPNM@
PNMTOPS = @PNMTOPS@
PNMCROP= @PNMCROP@

EPS = discrete-event-sim.eps interface-vs-implementation.eps libraries-activity.eps libraries-itemized.eps libraries-overview.eps libraries-random-overview.eps libraries-random-process.eps libraries-rankedlist-map.eps libraries-space-hierarchy.eps merging-schedules.eps modeling.eps objc-basics.eps oo-principles.eps oo-programming.eps recursive-swarm.eps simplebug-activation.eps simplebug-class-hierarchy.eps simplebug-foodspace.eps simplebug-model-swarm.eps simplebug-modelswarm2.eps simplebug-objc.eps simplebug-observer-swarm.eps simplebug-probes1.eps simplebug-probes2.eps simplebug-schedules-1.eps simplebug-schedules-group.eps swarm-discrete-event.eps swarm.eps system-diagram.eps gui-graph.eps gui-histogram.eps gui-raster.eps gui-probemap-example.eps gui-probemap-customized.eps gui-probemap-complete.eps

GENERATED_EPS = $(patsubst %.png,%.eps,$(PNG))
PNG =  $(addsuffix .png, tip note important caution warning switcheroo 1 2 3 4 5 6 7 8 9 10)
GENERATED_JPEG = $(patsubst %.eps,%.jpeg,$(EPS)) $(patsubst %.png,%.jpeg,$(PNG))

EXTRA_DIST = $(EPS) $(PNG)

GENERATED_FIGS = $(GENERATED_EPS) $(GENERATED_JPEG)

figsdir = $(prefix)/figs
nodist_figs_DATA = $(GENERATED_FIGS) $(EPS)

CLEANFILES = $(GENERATED_FIGS)

%.png: $(srcdir)/%.eps
	GS_LIB="$(GS_LIB)" $(GS) -dNOPAUSE -sDEVICE=png256 -sOutputFile=$@ - < $< -c showpage -c quit

%.jpeg: $(srcdir)/%.eps
	GS_LIB="$(GS_LIB)" $(GS) -dNOPAUSE -sDEVICE=ppm -sOutputFile=$*.ppm - < $< -c showpage -c quit
	$(PNMCROP) $*.ppm > $*-crop.ppm
	$(CJPEG) $*-crop.ppm > $@
	$(RM) $*.ppm $*-crop.ppm

%.eps: $(srcdir)/%.png
	$(PNGTOPNM) $< > $*.pnm
	$(PNMTOPS) $*.pnm > $@
	$(RM) $*.pnm

%.jpeg: $(srcdir)/%.png
	$(PNGTOPNM) $< > $*.pnm
	$(CJPEG) $*.pnm > $@
	$(RM) $*.pnm
