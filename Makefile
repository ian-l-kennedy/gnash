.SILENT:
SHELL=/bin/bash

deb:
	rm -f build/deb/gnash.deb
	rm -rf build/deb/gnash/usr
	mkdir -p build/deb/gnash/usr
	mkdir -p build/deb/gnash/usr/lib
	cp gnash.bash build/deb/gnash/usr/lib/.
	dpkg-deb --build build/deb/gnash
