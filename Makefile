# beacon - A simple flexible popup dialog to run on X.
# Based on Lighthouse Project that are no longer maintained.
# See LICENSE file for copyright and license details.

PREFIX = /usr/local
SHAREPREFIX = ${PREFIX}/share/beacon
DOLLAR = $$

CC=gcc
CFLAGS+=-I$(INCDIR)

OBJDIR=objs
SRCDIR=src
INCDIR=$(SRCDIR)/inc
SRCS=$(wildcard $(SRCDIR)/*.c)
OBJS=$(patsubst $(SRCDIR)/%.c,$(OBJDIR)/%.o,$(SRCS))

CFLAGS+=-O2 -Wall -std=c99
CFLAGS_DEBUG+=-O0 -g3 -Werror -DDEBUG -pedantic
LDFLAGS+=-lxcb -lxcb-xkb -lxcb-xinerama -lxcb-randr -lcairo -lpthread

# OS X keeps xcb in a different spot
platform=$(shell uname)
ifeq ($(platform),Darwin)
	CFLAGS+=-I/usr/X11/include
	LDFLAGS+=-L/usr/X11/lib
endif

# Library specific
ifeq "$(shell pkg-config --exists gdk-2.0 && echo 1)" "1"
	CFLAGS+=`pkg-config --cflags gdk-2.0`
	LDFLAGS+=`pkg-config --libs gdk-2.0`
else
	CFLAGS+=-DNO_GDK
endif
ifeq "$(shell pkg-config --exists pango && echo 1)" "1"
	CFLAGS+=`pkg-config --cflags pango`
	LDFLAGS+=`pkg-config --libs pango`
else
	CFLAGS+=-DNO_PANGO
endif

options:
	@echo beacon build options:
	@echo "CFLAGS   = ${CFLAGS}"
	@echo "LDFLAGS  = ${LDFLAGS}"
	@echo "CC       = ${CC}"

all: beacon

install: all .FORCE
	@echo installing executables to ${DESTDIR}${PREFIX}/bin
	@mkdir -p ${DESTDIR}${PREFIX}/bin
	@cp -f beacon ${DESTDIR}${PREFIX}/bin
	@chmod +x ${DESTDIR}${PREFIX}/bin/beacon
	@echo installing configurations to ${DESTDIR}${SHAREPREFIX}/.config
	@mkdir -p ${DESTDIR}${SHAREPREFIX}/.config
	@cp -r config/beacon ${DESTDIR}${SHAREPREFIX}/.config
	@chmod +x ${DESTDIR}${SHAREPREFIX}/.config/beacon/cmd*
	@echo installing beacon-install script
	@echo "#!/bin/sh" > ${DESTDIR}${PREFIX}/bin/beacon-install
	@echo "cp -r -n ${DESTDIR}${SHAREPREFIX}/.config/beacon \$(DOLLAR)HOME/.config" >> ${DESTDIR}${PREFIX}/bin/beacon-install
	@echo "chmod -R +w \$(DOLLAR)HOME/.config/beacon" >> ${DESTDIR}${PREFIX}/bin/beacon-install
	@chmod +x ${DESTDIR}${PREFIX}/bin/beacon-install

debug: CC+=$(CFLAGS_DEBUG)
debug: beacon .FORCE

.FORCE:

beacon: $(OBJS)
	$(CC) $(CFLAGS) $^ -o $@ $(LDFLAGS)

$(OBJS): | $(OBJDIR)
$(OBJDIR):
	@mkdir -p $@

$(OBJDIR)/%.o: $(SRCDIR)/%.c $(wildcard $(INCDIR)/*.h) Makefile
	$(CC) $(CFLAGS) $< -c -o $@

clean:
	@rm -rf $(OBJDIR) beacon
