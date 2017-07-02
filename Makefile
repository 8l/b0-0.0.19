# Where you want it installed when you do 'make install'
PREFIX=/usr/local
# Where you want the includes to go when you do 'make install'
IPREFIX=/usr/local

# You shouldn't have to touch the rest unless the compile is failing for some reason?
DISTNAME=b0
VERSION=0.0.19
SRC=./src
EXAMPLE_DIR=./examples
B0_SRC=$(SRC)/b0.b0 $(SRC)/b0.h.b0 $(SRC)/core.b0 $(SRC)/b0_libc.b0 $(SRC)/b0_linux.b0 $(SRC)/b0_win64.b0 $(SRC)/b0_stdlib.b0

# To assist in cross-compiling
CC=gcc
AS=fasm
#CFLAGS=-std=c99 -Wall -O3 -mtune=opteron -m64 -I$(SRC)
CFLAGS=-Wall -O3 -mtune=opteron -m64 -I$(SRC)
#CFLAGS=-Wall -I$(SRC)
LDFLAGS=

#flags for ghostscript and html2ps
GS=gs
GSFLAGS=-sDEVICE=pdfwrite -q -dNOPAUSE -dBATCH
HTML2PS=html2ps

#flags for building the examples
B0_FLAGS=-W -felf

all: b0
b0: $(SRC)/b0.c $(SRC)/b0.h
	$(CC) $(CFLAGS) -s $(LDFLAGS) -o b0 $(SRC)/b0.c

b0-debug: $(SRC)/b0.c $(SRC)/b0.h
	$(CC) $(CFLAGS) -ggdb $(LDFLAGS) -o b0 $(SRC)/b0.c

b0-ia32: $(SRC)/b0.c $(SRC)/b0.h
	$(CC) -Wall -O3 -I$(SRC) -Di386 -s $(LDFLAGS) -o b0 $(SRC)/b0.c

b0_b0: b0 $(B0_SRC)
	./b0 $(B0_FLAGS)o -i./src:./include $(SRC)/b0.b0
	$(AS) -m256000 $(SRC)/b0.asm ./b0.o
	$(CC) $(CFLAGS) $(LDFLAGS) -s -o b0_b0 b0.o
	rm -f $(SRC)/b0.asm ./b0.o
	
clean: 
	rm -f *.o *.asm *.tmp *~ b0 b0_b0 le le2 le3 le4 le5 le6 le7 le8 le9 test $(DISTNAME)-$(VERSION).tar.bz2 $(DISTNAME)-$(VERSION).tar.gz *.pdf *.ps $(EXAMPLE_DIR)/*.as* $(EXAMPLE_DIR)/*.o $(EXAMPLE_DIR)/*~ $(SRC)/*.as* $(SRC)/*.o $(SRC)/*~ include/*~ doc/*~ doc/css/*~
	
docs: ./doc/b0-man.html
	$(HTML2PS) -o b0.ps ./doc/b0-man.html
	$(GS) $(GSFLAGS) -sOutputFile=b0.pdf b0.ps
	rm -f ./b0.ps

install: b0
	if ( test ! -d $(PREFIX)/bin ) ; then mkdir -p $(PREFIX)/bin ; fi
	if ( test ! -d $(IPREFIX)/include ) ; then mkdir -p $(IPREFIX)/include ; fi
	if ( test ! -d $(IPREFIX)/include/b0 ) ; then mkdir -p $(IPREFIX)/include/b0 ; fi
	cp -f b0 $(PREFIX)/bin/b0
	chmod a+x $(PREFIX)/bin/b0
	cp -f ./include/* \
		$(IPREFIX)/include/b0
	cp -f ./doc/b0.man $(PREFIX)/man/man1/b0.1
	@echo 
	@echo Please set environment variable BO_INCLUDE=$(IPREFIX)/include/b0
	@echo 

uninstall:
	rm -fR $(IPREFIX)/include/b0
	rm -f $(PREFIX)/bin/b0
	rm -f $(PREFIX)/man/man1/b0.1
	
dist:
	rm -f $(DISTNAME)-$(VERSION).tar.bz2
	ln -sf . $(DISTNAME)-$(VERSION)
	tar -cf $(DISTNAME)-$(VERSION).tar \
	   $(DISTNAME)-$(VERSION)/Makefile \
	   $(DISTNAME)-$(VERSION)/Makefile.w32 \
	   $(DISTNAME)-$(VERSION)/README \
	   $(DISTNAME)-$(VERSION)/COPYING \
	   $(DISTNAME)-$(VERSION)/$(SRC)/b0.c \
	   $(DISTNAME)-$(VERSION)/$(SRC)/b0.h \
	   $(DISTNAME)-$(VERSION)/$(SRC)/b0.b0 \
	   $(DISTNAME)-$(VERSION)/$(SRC)/b0.h.b0 \
	   $(DISTNAME)-$(VERSION)/$(SRC)/core.b0 \
	   $(DISTNAME)-$(VERSION)/$(SRC)/b0_libc.b0 \
	   $(DISTNAME)-$(VERSION)/$(SRC)/b0_linux.b0 \
	   $(DISTNAME)-$(VERSION)/$(SRC)/b0_win64.b0 \
	   $(DISTNAME)-$(VERSION)/$(SRC)/b0_stdlib.b0 \
	   $(DISTNAME)-$(VERSION)/$(SRC)/b0_linux.b0 \
	   $(DISTNAME)-$(VERSION)/$(EXAMPLE_DIR)/le.b0 \
	   $(DISTNAME)-$(VERSION)/$(EXAMPLE_DIR)/le2.b0 \
	   $(DISTNAME)-$(VERSION)/$(EXAMPLE_DIR)/le3.b0 \
	   $(DISTNAME)-$(VERSION)/$(EXAMPLE_DIR)/le4_p1.b0 \
	   $(DISTNAME)-$(VERSION)/$(EXAMPLE_DIR)/le4_p2.b0 \
	   $(DISTNAME)-$(VERSION)/$(EXAMPLE_DIR)/le5.b0 \
	   $(DISTNAME)-$(VERSION)/$(EXAMPLE_DIR)/le6.b0 \
	   $(DISTNAME)-$(VERSION)/$(EXAMPLE_DIR)/le7.b0 \
	   $(DISTNAME)-$(VERSION)/$(EXAMPLE_DIR)/win64.b0 \
	   $(DISTNAME)-$(VERSION)/$(EXAMPLE_DIR)/cgi1.b0 \
	   $(DISTNAME)-$(VERSION)/$(EXAMPLE_DIR)/gtk/gtk-cal.b0 \
	   $(DISTNAME)-$(VERSION)/$(EXAMPLE_DIR)/gtk/gtk2-cal.b0 \
	   $(DISTNAME)-$(VERSION)/$(EXAMPLE_DIR)/gtk/Makefile \
	   $(DISTNAME)-$(VERSION)/$(EXAMPLE_DIR)/gtk/gtk1.inc \
	   $(DISTNAME)-$(VERSION)/$(EXAMPLE_DIR)/ia32/le.b0 \
	   $(DISTNAME)-$(VERSION)/$(EXAMPLE_DIR)/ia32/le2.b0 \
	   $(DISTNAME)-$(VERSION)/$(EXAMPLE_DIR)/ia32/win32.b0 \
	   $(DISTNAME)-$(VERSION)/include/std_char.b0 \
	   $(DISTNAME)-$(VERSION)/include/stdlib.b0 \
	   $(DISTNAME)-$(VERSION)/include/stdlib_linux.b0 \
	   $(DISTNAME)-$(VERSION)/include/stdlib_unicode.b0 \
	   $(DISTNAME)-$(VERSION)/doc/b0.man \
	   $(DISTNAME)-$(VERSION)/doc/b0.html \
	   $(DISTNAME)-$(VERSION)/doc/b0-man.html \
	   $(DISTNAME)-$(VERSION)/doc/b0-ver.html \
	   $(DISTNAME)-$(VERSION)/doc/b0-tutorial.html \
	   $(DISTNAME)-$(VERSION)/doc/b0-internals.html \
	   $(DISTNAME)-$(VERSION)/doc/stdlib.html \
	   $(DISTNAME)-$(VERSION)/doc/b0.xml \
	   $(DISTNAME)-$(VERSION)/doc/css/classic.css \
	   $(DISTNAME)-$(VERSION)/doc/css/html1.css \
	   $(DISTNAME)-$(VERSION)/doc/css/silver.css \
	   $(DISTNAME)-$(VERSION)/doc/css/header.css \
	   $(DISTNAME)-$(VERSION)/doc/css/modern.css \
	   $(DISTNAME)-$(VERSION)/doc/css/common.css \
	   $(DISTNAME)-$(VERSION)/doc/css/style.css \
	   $(DISTNAME)-$(VERSION)/doc/css/ui.js \
	   $(DISTNAME)-$(VERSION)/doc/css/bkgnd.gif \
	   $(DISTNAME)-$(VERSION)/doc/css/bkgnd2.gif \
	   $(DISTNAME)-$(VERSION)/doc/css/bkgnd3.gif \
	   $(DISTNAME)-$(VERSION)/doc/css/fontseriftoggle.gif \
	   $(DISTNAME)-$(VERSION)/doc/css/fontsizelarger.gif \
	   $(DISTNAME)-$(VERSION)/doc/css/fontsizesmaller.gif \
	   $(DISTNAME)-$(VERSION)/doc/css/colorswitch.gif \
	   $(DISTNAME)-$(VERSION)/doc/css/reset.gif
	bzip2 -k $(DISTNAME)-$(VERSION).tar
	gzip $(DISTNAME)-$(VERSION).tar
	rm -f $(DISTNAME)-$(VERSION)

test: b0
	./b0 $(B0_FLAGS) $(EXAMPLE_DIR)/le.b0
	$(AS) $(EXAMPLE_DIR)/le.asm le
	./b0 $(B0_FLAGS) $(EXAMPLE_DIR)/le2.b0
	$(AS) $(EXAMPLE_DIR)/le2.asm le2
	./b0 $(B0_FLAGS)o $(EXAMPLE_DIR)/le3.b0
	$(AS) $(EXAMPLE_DIR)/le3.asm $(EXAMPLE_DIR)/le3.o
	$(CC) $(CFLAGS) $(LDFLAGS) -o le3 $(EXAMPLE_DIR)/le3.o
	./b0 $(B0_FLAGS)o $(EXAMPLE_DIR)/le4_p1.b0
	./b0 $(B0_FLAGS)o $(EXAMPLE_DIR)/le4_p2.b0
	$(AS) $(EXAMPLE_DIR)/le4_p1.asm $(EXAMPLE_DIR)/le4_p1.o
	$(AS) $(EXAMPLE_DIR)/le4_p2.asm $(EXAMPLE_DIR)/le4_p2.o
	$(CC) $(CFLAGS) $(LDFLAGS) -o le4 $(EXAMPLE_DIR)/le4_p1.o $(EXAMPLE_DIR)/le4_p2.o
	./b0 $(B0_FLAGS)o $(EXAMPLE_DIR)/le5.b0
	$(AS) $(EXAMPLE_DIR)/le5.asm $(EXAMPLE_DIR)/le5.o
	$(CC) $(CFLAGS) $(LDFLAGS) -o le5 $(EXAMPLE_DIR)/le5.o
	./b0 $(B0_FLAGS) -UTF8 $(EXAMPLE_DIR)/le6.b0
	$(AS) $(EXAMPLE_DIR)/le6.asm le6
	./b0 $(B0_FLAGS)o $(EXAMPLE_DIR)/le7.b0
	$(AS) $(EXAMPLE_DIR)/le7.asm $(EXAMPLE_DIR)/le7.o
	$(CC) $(CFLAGS) $(LDFLAGS) -o le7 $(EXAMPLE_DIR)/le7.o
	rm -f $(EXAMPLE_DIR)/*.asm $(EXAMPLE_DIR)/*.o
	cp le test
	
test2: b0 b0_b0
	./b0 $(B0_FLAGS) $(EXAMPLE_DIR)/le.b0
	./b0 $(B0_FLAGS) $(EXAMPLE_DIR)/le2.b0
	./b0 $(B0_FLAGS)o $(EXAMPLE_DIR)/le3.b0
	./b0 $(B0_FLAGS)o $(EXAMPLE_DIR)/le4_p1.b0
	./b0 $(B0_FLAGS)o $(EXAMPLE_DIR)/le4_p2.b0
	./b0 $(B0_FLAGS)o $(EXAMPLE_DIR)/le5.b0
	./b0 $(B0_FLAGS) -UTF8 $(EXAMPLE_DIR)/le6.b0
	./b0 $(B0_FLAGS)o $(EXAMPLE_DIR)/le7.b0
	./b0 $(B0_FLAGS)o $(EXAMPLE_DIR)/le8.b0
	./b0 $(B0_FLAGS)o -i./src $(EXAMPLE_DIR)/le9.b0
	mv $(EXAMPLE_DIR)/le.asm $(EXAMPLE_DIR)/le.asm_C
	mv $(EXAMPLE_DIR)/le2.asm $(EXAMPLE_DIR)/le2.asm_C
	mv $(EXAMPLE_DIR)/le3.asm $(EXAMPLE_DIR)/le3.asm_C
	mv $(EXAMPLE_DIR)/le4_p1.asm $(EXAMPLE_DIR)/le4_p1.asm_C
	mv $(EXAMPLE_DIR)/le4_p2.asm $(EXAMPLE_DIR)/le4_p2.asm_C
	mv $(EXAMPLE_DIR)/le5.asm $(EXAMPLE_DIR)/le5.asm_C
	mv $(EXAMPLE_DIR)/le6.asm $(EXAMPLE_DIR)/le6.asm_C
	mv $(EXAMPLE_DIR)/le7.asm $(EXAMPLE_DIR)/le7.asm_C
	mv $(EXAMPLE_DIR)/le8.asm $(EXAMPLE_DIR)/le8.asm_C
	mv $(EXAMPLE_DIR)/le9.asm $(EXAMPLE_DIR)/le9.asm_C
	./b0_b0 $(B0_FLAGS) $(EXAMPLE_DIR)/le.b0
	./b0_b0 $(B0_FLAGS) $(EXAMPLE_DIR)/le2.b0
	./b0_b0 $(B0_FLAGS)o $(EXAMPLE_DIR)/le3.b0
	./b0_b0 $(B0_FLAGS)o $(EXAMPLE_DIR)/le4_p1.b0
	./b0_b0 $(B0_FLAGS)o $(EXAMPLE_DIR)/le4_p2.b0
	./b0_b0 $(B0_FLAGS)o $(EXAMPLE_DIR)/le5.b0
	./b0_b0 $(B0_FLAGS) -UTF8 $(EXAMPLE_DIR)/le6.b0
	./b0_b0 $(B0_FLAGS)o $(EXAMPLE_DIR)/le7.b0
	./b0_b0 $(B0_FLAGS)o $(EXAMPLE_DIR)/le8.b0
	./b0_b0 $(B0_FLAGS)o -i./src $(EXAMPLE_DIR)/le9.b0
	diff -q -a $(EXAMPLE_DIR)/le.asm $(EXAMPLE_DIR)/le.asm_C
	diff -q -a $(EXAMPLE_DIR)/le2.asm $(EXAMPLE_DIR)/le2.asm_C
	diff -q -a $(EXAMPLE_DIR)/le3.asm $(EXAMPLE_DIR)/le3.asm_C
	diff -q -a $(EXAMPLE_DIR)/le4_p1.asm $(EXAMPLE_DIR)/le4_p1.asm_C
	diff -q -a $(EXAMPLE_DIR)/le4_p2.asm $(EXAMPLE_DIR)/le4_p2.asm_C
	diff -q -a $(EXAMPLE_DIR)/le5.asm $(EXAMPLE_DIR)/le5.asm_C
	diff -q -a $(EXAMPLE_DIR)/le6.asm $(EXAMPLE_DIR)/le6.asm_C
	diff -q -a $(EXAMPLE_DIR)/le7.asm $(EXAMPLE_DIR)/le7.asm_C
	diff -q -a $(EXAMPLE_DIR)/le8.asm $(EXAMPLE_DIR)/le8.asm_C
	diff -q -a $(EXAMPLE_DIR)/le9.asm $(EXAMPLE_DIR)/le9.asm_C
	./b0 -felfo -i./src ./src/b0.b0
	mv ./src/b0.asm ./src/b0.asm_C
	./b0_b0 -felfo -i./src ./src/b0.b0
	diff -q -a ./src/b0.asm ./src/b0.asm_C 
	$(AS) -m256000 $(SRC)/b0.asm ./b0.o
	$(CC) $(CFLAGS) $(LDFLAGS) -s -o b0_b02 b0.o
	rm -f $(SRC)/b0.asm ./b0.o
	./b0_b02 -felfo -i./src ./src/b0.b0
	diff -q -a ./src/b0.asm ./src/b0.asm_C 
	

	
diff.txt: b0 b0_b0
	./b0 -felfo -i./src -v ./src/b0.b0
	mv ./src/b0.asm ./src/b0.asm_C
	./b0_b0 -felfo -i./src -v ./src/b0.b0
	mv ./src/b0.asm ./src/b0.asm_b0
	diff -y -a ./src/b0.asm_C ./src/b0.asm_b0 > diff.txt
