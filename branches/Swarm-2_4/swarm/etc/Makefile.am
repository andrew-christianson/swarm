EXTRA_DIST = config.swarm.in Makefile.common.in Makefile.appl.in Makefile.lib.in Makefile.rules Makefile.tests.in common.el protocol.el interface.el Makefile.protocol modules swarmrc.in swarmtrc.in swarm.make

install-data-local:
	$(mkinstalldirs) $(DESTDIR)$(datarootdir)/swarm
	$(INSTALL_DATA) config.swarm $(DESTDIR)$(datarootdir)/swarm
	$(INSTALL_DATA) Makefile.appl $(DESTDIR)$(datarootdir)/swarm
	$(INSTALL_DATA) Makefile.lib $(DESTDIR)$(datarootdir)/swarm
	$(INSTALL_DATA) Makefile.common $(DESTDIR)$(datarootdir)/swarm
	$(INSTALL_DATA) $(srcdir)/Makefile.rules $(DESTDIR)$(datarootdir)/swarm
	$(INSTALL_DATA) $(srcdir)/swarm.make $(DESTDIR)$(datarootdir)/swarm
	$(INSTALL_DATA) swarmrc $(DESTDIR)$(datarootdir)/swarm
	$(INSTALL_DATA) swarmtrc $(DESTDIR)$(datarootdir)/swarm
