#!/usr/bin/make -f
# Makefile for mod-panel #
# ---------------------- #
# Created by falkTX
#

# ----------------------------------------------------------------------------------------------------------------------------

PREFIX  := /usr
DESTDIR :=

# ----------------------------------------------------------------------------------------------------------------------------
# Set PyQt tools

# TODO use shell to check for tool
# TODO also check for virtualenv

PYUIC5 ?= /usr/bin/pyuic5
PYUIC6 ?= /usr/bin/pyuic6

ifneq (,$(wildcard $(PYUIC5)))
HAVE_PYQT=true
HAVE_PYQT5=true
else
HAVE_PYQT5=false
endif

ifneq (,$(wildcard $(PYUIC6)))
HAVE_PYQT=true
HAVE_PYQT6=true
else
HAVE_PYQT6=false
endif

ifneq ($(HAVE_PYQT),true)
$(error PyQt is not available, please install it)
endif

ifeq ($(HAVE_PYQT5),true)
DEFAULT_QT ?= 5
else
DEFAULT_QT ?= 6
endif

ifeq ($(DEFAULT_QT),5)
PYUIC ?= pyuic5
PYRCC ?= pyrcc5
else
PYUIC ?= pyuic6
PYRCC ?= pyrcc6
endif

# ----------------------------------------------------------------------------------------------------------------------------

all: RES UI host utils

# ----------------------------------------------------------------------------------------------------------------------------
# Resources

RES = \
	source/mod_config.py \
	source/resources_rc.py

RES: $(RES)

source/mod_config.py:
	@echo "#!/usr/bin/env python3\n# -*- coding: utf-8 -*-\n" > $@
ifeq ($(DEFAULT_QT),5)
	@echo "config_UseQt5 = True" >> $@
else
	@echo "config_UseQt5 = False" >> $@
endif

source/resources_rc.py: resources/resources.qrc resources/*/*.svg
	$(PYRCC) $< -o $@

bin/resources/%.py: source/%.py
	$(LINK) $(CURDIR)/source/$*.py bin/resources/

# ----------------------------------------------------------------------------------------------------------------------------
# UI code

UIs = \
	source/ui_mod_panel.py

UI: $(UIs)

source/ui_%.py: resources/ui/%.ui
	$(PYUIC) $< -o $@

# ----------------------------------------------------------------------------------------------------------------------------
# host (from mod-host submodule)

host: source/mod-host/mod-host

source/mod-host/mod-host: source/mod-host/src/*.c source/mod-host/src/*.h
	$(MAKE) -C source/mod-host

# ----------------------------------------------------------------------------------------------------------------------------
# utils (from mod-ui submodule)

utils: source/mod-ui/utils/libmod_utils.so

source/mod-ui/utils/libmod_utils.so: source/mod-ui/utils/*.cpp source/mod-ui/utils/*.h
	$(MAKE) -C source/mod-ui/utils

# ----------------------------------------------------------------------------------------------------------------------------

clean:
	rm -f $(RES) $(UIs)
	rm -f *~ source/*~ source/*.pyc source/*_rc.py source/ui_*.py
	$(MAKE) clean -C source/mod-host
	$(MAKE) clean -C source/mod-ui/utils

# ----------------------------------------------------------------------------------------------------------------------------

install:
	# Create directories
	install -d $(DESTDIR)$(PREFIX)/bin/
	install -d $(DESTDIR)$(PREFIX)/share/applications/
	install -d $(DESTDIR)$(PREFIX)/share/mod-panel/
	install -d $(DESTDIR)$(PREFIX)/share/pixmaps/

	# Install desktop file and pixmap
	install -m 755 data/*.desktop          $(DESTDIR)$(PREFIX)/share/applications/
	install -m 644 resources/48x48/mod.png $(DESTDIR)$(PREFIX)/share/pixmaps/mod-panel.svg

	# Install script files
	install -m 755 \
		data/mod-panel \
		$(DESTDIR)$(PREFIX)/bin/

	# Install python code
	install -m 644 \
		source/mod-panel \
		source/*.py \
		$(DESTDIR)$(PREFIX)/share/mod-panel/

	# Adjust PREFIX value in script files
	sed -i "s?X-PREFIX-X?$(PREFIX)?" $(DESTDIR)$(PREFIX)/bin/mod-panel

# ----------------------------------------------------------------------------------------------------------------------------

uninstall:
	rm -f  $(DESTDIR)$(PREFIX)/bin/mod-panel
	rm -f  $(DESTDIR)$(PREFIX)/share/applications/mod-panel.desktop
	rm -f  $(DESTDIR)$(PREFIX)/share/pixmaps/mod-panel.svg
	rm -rf $(DESTDIR)$(PREFIX)/share/mod-panel/

# ----------------------------------------------------------------------------------------------------------------------------
