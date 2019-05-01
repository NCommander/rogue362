#
# Makefile for rogue
# %W% (Berkeley) %G%
#
DISTNAME=rogue3.6.2

HDRS= rogue.h machdep.h
OBJS= vers.o armor.o chase.o command.o daemon.o daemons.o fight.o \
	init.o io.o list.o main.o misc.o monsters.o move.o newlevel.o \
	options.o pack.o passages.o potions.o rings.o rip.o rooms.o \
	save.o scrolls.o state.o sticks.o things.o weapons.o wizard.o xcrypt.o
CFILES= vers.c armor.c chase.c command.c daemon.c daemons.c fight.c \
	init.c io.c list.c main.c misc.c monsters.c move.c newlevel.c \
	options.c pack.c passages.c potions.c rings.c rip.c rooms.c \
	save.c scrolls.c state.c sticks.c things.c weapons.c wizard.c xcrypt.c

MISC=	Makefile LICENSE.TXT rogue.6 rogue.r

CC    = gcc
CFLAGS= -O3 -Wno-implicit-function-declaration -Wno-implicit-int
CRLIB = -lcurses
RM    = rm -f
TAR   = tar

rogue: $(HDRS) $(OBJS)
	$(CC) $(CFLAGS) $(LDFLAGS) $(OBJS) $(CRLIB) -o $@

main.o rip.o: machdep.h

tags: $(HDRS) $(CFILES)
	ctags -u $?
	ed - tags < :ctfix
	sort tags -o tags

lint:
	lint -hxbc $(CFILES) $(CRLIB) > linterrs

clean:
	rm -f $(OBJS) core 
	rm -f rogue rogue.exe rogue.tar rogue.tar.gz rogue.cat rogue.doc

count:
	wc -l $(HDRS) $(CFILES)

realcount:
	cc -E $(CFILES) | ssp - | wc -l

update:
	ar uv .SAVE $(CFILES) $(HDRS) $(MISC)

dist:
	@mkdir dist
	cp $(CFILES) $(HDRS) $(MISC) dist

xtar: $(CFILES) $(HDRS) $(MISC)
	rm -f rogue.tar
	tar cf rogue.tar $? :ctfix
	touch xtar

cfiles: $(CFILES)

dist.src:
	make clean
	tar cf $(DISTNAME)-src.tar $(CFILES) $(HDRS) $(MISC)
	gzip $(DISTNAME)-src.tar

dist.irix:
	make clean
	make CC=cc CFLAGS="-woff 1116 -O3" rogue
	tbl rogue.r | nroff -ms | colcrt - > rogue.doc
	nroff -man rogue.6 | colcrt - > rogue.cat
	tar cf $(DISTNAME)-irix.tar rogue LICENSE.TXT rogue.cat roguedoc.doc
	gzip $(DISTNAME)-irix.tar

dist.aix:
	make clean
	make CC=xlc CFLAGS="-qmaxmem=16768 -O3 -qstrict" rogue
	tbl rogue.r | nroff -ms | colcrt - > rogue.doc
	nroff -man rogue.6 | colcrt - > rogue.cat
	tar cf $(DISTNAME)-aix.tar rogue LICENSE.TXT rogue.cat rogue.doc
	gzip $(DISTNAME)-aix.tar

dist.linux:
	make clean
	make rogue
	groff -P-c -t -ms -Tascii rogue.r | sed -e 's/.\x08//g' > rogue.doc
	groff -man rogue.6 | sed -e 's/.\x08//g' > rogue.cat
	tar cf $(DISTNAME)-linux.tar rogue LICENSE.TXT rogue.cat rogue.doc
	gzip $(DISTNAME)-linux.tar
	
dist.interix: 
	make clean
	make rogue
	groff -P-b -P-u -t -ms -Tascii rogue.r > rogue.doc
	groff -P-b -P-u -man -Tascii rogue.6 > rogue.cat
	tar cf $(DISTNAME)-interix.tar rogue LICENSE.TXT rogue.cat rogue.doc
	gzip -f $(DISTNAME)-interix.tar
	
dist.cygwin:
	make clean
	make rogue
	groff -P-c -t -ms -Tascii rogue.r | sed -e 's/.\x08//g' > rogue.doc
	groff -P-c -man -Tascii rogue.6 | sed -e 's/.\x08//g' > rogue.cat
	tar cf $(DISTNAME)-cygwin.tar rogue.exe LICENSE.TXT rogue.cat rogue.doc
	gzip -f $(DISTNAME)-cygwin.tar
	
dist.djgpp: 
	make clean
	make LDFLAGS="-L$(DJDIR)/LIB" CRLIB="-lpdcurses" rogue
	groff -t -ms -Tascii rogue.r | sed -e 's/.\x08//g' > rogue.doc
	groff -man -Tascii rogue.6 | sed -e 's/.\x08//g' > rogue.cat
	rm -f $(DISTNAME)-djgpp.zip
	zip $(DISTNAME)-djgpp.zip rogue.exe LICENSE.TXT rogue.cat rogue.doc
