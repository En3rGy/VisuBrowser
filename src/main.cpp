#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtWebEngine>
#include "systemstatus.h"

int main(int argc, char *argv[])
{
    CSystemStatus app(argc, argv);
    CNativeEventFilter grNativeEventFilter( & app );

    app.installNativeEventFilter( & grNativeEventFilter );

    QGuiApplication::setApplicationName( "VisuBrowser" );
    QGuiApplication::setOrganizationName( "paul-family" );
    QGuiApplication::setOrganizationDomain( "paul-family.de");
    QGuiApplication::setApplicationVersion( "0.3.1" );
    QGuiApplication::setApplicationDisplayName( QGuiApplication::applicationName() + " v" + QGuiApplication::applicationVersion() );

    QtWebEngine::initialize();

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    QList< QObject * > grObjLst = engine.rootObjects();

    QObject::connect( & app, SIGNAL( signal_systemResume() ), grObjLst.first(), SLOT(slot_resume()));
    QObject::connect( & app, SIGNAL( signal_goingToSuspend() ), grObjLst.first(), SLOT(slot_suspend()));
    QObject::connect( grObjLst.first(), SIGNAL( signal_quitApp() ), &app, SLOT( slot_quit()) );

    return app.exec();
}
