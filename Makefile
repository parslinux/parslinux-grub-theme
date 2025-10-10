all: nomake

nomake:
	@echo "no make"

install:
	mkdir -p $(DESTDIR)/usr/share/grub/themes
	mkdir -p $(DESTDIR)/boot/grub/themes
	@cp -fr bilge $(DESTDIR)/usr/share/grub/themes/
	@cp -fr bilge $(DESTDIR)/boot/grub/themes/

uninstall:
	@rm -fr $(DESTDIR)/usr/share/grub/themes/bilge
	@rm -fr $(DESTDIR)/boot/grub/themes/bilge

.PHONY: install uninstall

