all: nomake

nomake:
	@echo "no make"

install:
	mkdir -p $(DESTDIR)/usr/share/grub/themes
	mkdir -p $(DESTDIR)/boot/grub/themes
	@cp -fr parslinux $(DESTDIR)/usr/share/grub/themes/
	@cp -fr parslinux $(DESTDIR)/boot/grub/themes/

uninstall:
	@rm -fr $(DESTDIR)/usr/share/grub/themes/parslinux
	@rm -fr $(DESTDIR)/boot/grub/themes/parslinux

.PHONY: install uninstall

