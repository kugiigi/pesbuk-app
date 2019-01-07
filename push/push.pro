TEMPLATE = app
TARGET = push
QT -= gui
QT += sql dbus widgets
INCLUDEPATH += .

MOC_DIR = mocs
OBJECTS_DIR = objs

#load(ubuntu-click)

HEADERS += pushclient.h pushhelper.h
SOURCES += push.cpp pushclient.cpp pushhelper.cpp
OTHER += push-apparmor.json push.json

other.files += $$OTHER
other.path = /push

target.path = /push

INSTALLS += target other
