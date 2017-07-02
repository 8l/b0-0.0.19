CC=gcc
AS=fasm
B0=../../b0
CFLAGS=-Wall -O3 -mtune=opteron -m64
LDFLAGS=
B0FLAGS=-felfo -UTF8

GTK1_CFLAGS=`gtk-config --cflags`
GTK1_LIBS=`gtk-config --libs`

GTK2_CFLAGS=`pkg-config --cflags gtk+-2.0`
GTK2_LIBS=`pkg-config --libs gtk+-2.0`

OBJECTS = gtk-cal gtk2-cal

all: $(OBJECTS)

clean:
	rm -f *.asm *.o *~ $(OBJECTS)

gtk2-cal: gtk2-cal.o
	gcc $(CFLAGS) $(GTK2_CLFAGS) $(GTK2_LIBS) -o $@ $<

gtk-cal: gtk-cal.o
	gcc $(CFLAGS) $(GTK1_CFLAGS) $(GTK1_LIBS) -o $@ $<

.SUFFIXES: .o .asm .b0

.asm.o:
	$(AS) $< $@
	
.b0.asm:
	$(B0) $(B0FLAGS) $<
