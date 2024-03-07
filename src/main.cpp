#include <QApplication>
#include <QQmlApplicationEngine>
#include <QtWebEngineQuick>
#include <QSplashScreen>
#include <QPixmap>
#include <QQuickStyle>
#include "systemstatus.h"

int main(int argc, char *argv[])
{
    QQuickStyle::setStyle("Material");

    QtWebEngineQuick::initialize();

    QGuiApplication::setApplicationName( "VisuBrowser" );
    QGuiApplication::setOrganizationName( "paul-family" );
    QGuiApplication::setOrganizationDomain( "paul-family.de");
    QGuiApplication::setApplicationVersion( "0.5.0" );
    QGuiApplication::setApplicationDisplayName( QGuiApplication::applicationName() + " v" + QGuiApplication::applicationVersion() );

    CSystemStatus app(argc, argv);
    CNativeEventFilter grNativeEventFilter( & app );
    app.installNativeEventFilter( & grNativeEventFilter );

    return app.exec();
}
