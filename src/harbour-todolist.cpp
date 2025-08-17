/*
 * This file is part of harbour-todolist.
 * SPDX-FileCopyrightText: 2020-2024 Mirian Margiani
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

#include <QtQuick>
#include <auroraapp.h>
#include "requires_defines.h"
#include "constants.h"

DEFINE_ENUM_REGISTRATION_FUNCTION(Todolist) {
    REGISTER_ENUM_CONTAINER(EntryState)
    REGISTER_ENUM_CONTAINER(EntrySubState)
}

int main(int argc, char *argv[])
{
    REGISTER_ENUMS(Todolist, "Todolist.Constants", 1, 0)
    qmlRegisterUncreatableType<EntryState>("Todolist.Constants", 1, 0, "EntryState", "This is only a container for an enumeration.");
    qmlRegisterUncreatableType<EntrySubState>("Todolist.Constants", 1, 0, "EntrySubState", "This is only a container for an enumeration.");

    QScopedPointer<QGuiApplication> app(Aurora::Application::application(argc, argv));
    app->setOrganizationName("moe.smoothie"); // needed for Sailjail
    app->setApplicationName("todolist");

    QScopedPointer<QQuickView> view(Aurora::Application::createView());
    view->rootContext()->setContextProperty("APP_VERSION", QString(APP_VERSION));
    view->rootContext()->setContextProperty("APP_RELEASE", QString(APP_RELEASE));

    view->engine()->addImportPath(Aurora::Application::pathTo("qml/modules").toString());
    view->setSource(Aurora::Application::pathTo("qml/harbour-todolist.qml"));
    view->show();
    return app->exec();
}
