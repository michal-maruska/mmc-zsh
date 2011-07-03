
SHELL=zsh

topdir=/usr/share/zsh/site-functions

INSTALL=install

all:

install:
	$(INSTALL) -d $(DESTDIR)$(topdir)/
	$(INSTALL) -d $(DESTDIR)$(topdir)/Misc
	for file in widgets/*; do $(INSTALL) -D $$file  $(DESTDIR)$(topdir)/; done
	foreach file  (functions/*(.)){ $(INSTALL) -D $$file  $(DESTDIR)$(topdir)/}
	foreach file  (functions/Misc/*(.)){ $(INSTALL) -D $$file  $(DESTDIR)$(topdir)/Misc/ }
	for file in keys/*; do $(INSTALL) -D $$file  $(DESTDIR)$(topdir)/; done
	for file in config/*; do $(INSTALL) -D $$file  $(DESTDIR)$(topdir)/; done

	$(INSTALL) -d $(DESTDIR)$(topdir)/recipes
	for file in recipes/*; do $(INSTALL) -D $$file  $(DESTDIR)$(topdir)/; done
clean:

.phony: all install clean
