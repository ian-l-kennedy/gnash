.SILENT:
SHELL=/bin/bash

do_clean_src=(rm -rf deb/gnash/usr)
do_clean_deb=(rm -f **/*.deb ; rm -f *.deb)

deb: clean_all
	mkdir -p deb/gnash/usr/lib
	cp gnash.bash deb/gnash/usr/lib/.
	dpkg-deb --build deb/gnash
	$(call do_clean_src)

install: deb
	sudo apt install ./deb/gnash.deb
	$(call do_clean_deb)

clean_all: clean_deb clean_src

clean_deb:
	$(call do_clean_deb)

clean_src:
	$(call do_clean_src)
