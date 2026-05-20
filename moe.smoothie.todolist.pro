# This file is part of harbour-todolist.
# SPDX-FileCopyrightText: 2020-2024 Mirian Margiani
# SPDX-FileCopyrightText: 2025-2026 Smooth-E
# SPDX-License-Identifier: GPL-3.0-or-later

# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed
TARGET = moe.smoothie.todolist

CONFIG += auroraapp c++11

# Note: version number is configured in yaml
DEFINES += APP_VERSION=\\\"$$VERSION\\\"
DEFINES += APP_RELEASE=\\\"$$RELEASE\\\"
include(libs/opal-cached-defines.pri)

include(libs/opal.pri)

SOURCES += \
    src/main.cpp \

HEADERS += \
    src/enumcontainer.h \
    src/constants.h \

DISTFILES += \
    qml/*.qml \
    qml/*/*.qml \
    qml/*/*.js \
    qml/*/*.py \
    qml/*/*/*.qml \
    qml/*/*/*.js \
    qml/*/*/*/*.qml \
    qml/*/*/*/*.js \
    rpm/harbour-*.changes \
    rpm/harbour-*.spec \
    rpm/harbour-*.yaml \
    translations/*.ts \
    harbour-*.desktop

AURORAAPP_ICONS = 86x86 108x108 128x128 172x172

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += auroraapp_i18n

TRANSLATIONS += \
    translations/moe.smoothie.todolist.ts \
    translations/moe.smoothie.todolist-ru.ts

CONFIG += c++11
include(libs/SortFilterProxyModel/SortFilterProxyModel.pri)

# Vendor libraries

cpython_version = 3.8
libdir = /usr/share/$$TARGET/lib
libexecdir = /usr/libexec/$$TARGET

message(Building for architecture $$QT_ARCH)
equals(QT_ARCH, arm64) {
    vendor = vendor/aarch64
    lib_subdir = lib64
}
# qmake in Aurora Platform SDK armv7hl prefix reports QT_ARCH as just arm...
equals(QT_ARCH, arm) {
    # But cmake, which we use for building cpython, reports it as armv7l
    vendor = vendor/armv7l
    lib_subdir = lib
}
message(Selected vendor dir $$vendor)

python_bin.path = $$libexecdir
python_bin.files = $$vendor/bin/python3 \
                   $$vendor/bin/python$$cpython_version

python_lib.path = $$libdir
python_lib.files = $$vendor/lib/python$$cpython_version \
                   $$vendor/lib/lib*

pyotherside.path = $$libdir
pyotherside.files = $$vendor/usr/$$lib_subdir/qt5

INSTALLS += python_bin python_lib pyotherside
