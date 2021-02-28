//#include <QGuiApplication>
//#include <QQmlApplicationEngine>
#include <QtWebEngine>
//#include <QSplashScreen>
//#include <QPixmap>
#include <QQuickStyle>
#include "systemstatus.h"
//#include "csplash.h"

int main(int argc, char *argv[])
{
    QtWebEngine::initialize();
    QQuickStyle::setStyle("Material");

    QGuiApplication::setApplicationName( "VisuBrowser" );
    QGuiApplication::setOrganizationName( "paul-family" );
    QGuiApplication::setOrganizationDomain( "paul-family.de");
    QGuiApplication::setApplicationVersion( "0.4.0" );
    QGuiApplication::setApplicationDisplayName( QGuiApplication::applicationName() + " v" + QGuiApplication::applicationVersion() );

    CSystemStatus app(argc, argv);
    CNativeEventFilter grNativeEventFilter( & app );
    app.installNativeEventFilter( & grNativeEventFilter );

    return app.exec();
}
