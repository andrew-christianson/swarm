SUBDIRS = figs
NAME = userbook
GENERATED_SGML = genindex.sgml
SGML = userbook.sgml usercont.sgml usermeta.sgml userpreface.sgml userbiblio.sgml user1.01.sgml user1.02.sgml user1.03.sgml user1.04.sgml user1.05.sgml user2.01.sgml user2.02.sgml user2.03.sgml user2.04.sgml user2.05.sgml user2.06.sgml user2.07.sgml user3.01.sgml user3.02.sgml user3.03.sgml user3.04.sgml user3.05.sgml user3.06.sgml user3.07.sgml userapp-tech.sgml userapp-swarmobjc.sgml userapp-rand.sgml userapp-rand1.sgml userapp-rand2.sgml userapp-rand3.sgml userapp-rand4.sgml

SGML_FILES = $(SGML) $(GENERATED_SGML)

all-recursive-am: versions.ent

.PHONY: FORCE

include $(top_srcdir)/Makefile.rules

EXTRA_DIST= $(SGML) html.dsl print.dsl common.dsl global.ent collateindex.pl docbook.dcl Makefile.rules

## ensure citations are links
JADEFLAGS = -V biblio-citation-check 

## automatically generate index, if any non-generated SGML files change
genindex.sgml: $(SGML) @COLLATEINDEX@ 
	perl @COLLATEINDEX@ -i "SWARM.USER.GENERATED.INDEX" -N -o genindex.sgml
	$(RUNJADE) -V html-index $(CATOPTS) -t sgml -ihtml -d $(HTML) `echo $< | sed 's,//\([A-Za-z]\),\1:,'`	
	perl @COLLATEINDEX@ -i "SWARM.USER.GENERATED.INDEX" -g -o genindex.sgml HTML.index

versions.ent: FORCE
	echo '<!ENTITY swarm-guide-release-number "@VERSION@">' > versions.ent.new
	echo '<!ENTITY swarm-guide-package-name "@PACKAGE@">' >> versions.ent.new
	((echo '<!ENTITY pubdate "' ; date +'%d %B %Y' ; echo '">') | tr -d '\n' ; echo) >> versions.ent.new
	@if test -f versions.ent; then \
	if cmp versions.ent versions.ent.new; then \
	echo No change, using old version.ent; \
	$(RM) versions.ent.new; \
	else \
	echo Different content, using new version; \
	mv versions.ent.new versions.ent; \
	fi \
	else \
	echo Using versions.ent.new; \
	mv versions.ent.new versions.ent; \
	fi           

# Local variables:
# mode: makefile
# end:
