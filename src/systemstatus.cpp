#include "systemstatus.h"
#include <iostream>
#include <QTimer>
#include <QQuickWindow>
//#include <QGuiApplication>
#include <QQmlApplicationEngine>
//#include <QtWebEngine>
#include <QSplashScreen>
#include <QPixmap>
//#include <QQuickStyle>
//#include "systemstatus.h"
#include "csplash.h"


#ifdef win32
#include <windows.h>
#endif

CSystemStatus::CSystemStatus(  int & p_nArgc , char ** & p_ppArgv )
    :  QApplication( p_nArgc, p_ppArgv )
    , m_bResumeDetected( false )
{
    CNativeEventFilter grFilter( this );
    installNativeEventFilter( & grFilter );

    QPixmap grPixmap("://ressources/AppIcon.png");
    CSplash grSplash(grPixmap);
    grSplash.show();
    this->processEvents();

    m_engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    QList< QObject * > grObjLst = m_engine.rootObjects();
    m_pWindow = qobject_cast<QQuickWindow *>(grObjLst.first());

    // to qml
    QObject::connect( this, SIGNAL( signal_systemResume() ), m_pWindow, SLOT(slot_resume()));
    QObject::connect( this, SIGNAL( signal_goingToSuspend() ), m_pWindow, SLOT(slot_suspend()));

    // from qml
    QObject::connect( m_pWindow, SIGNAL( signal_quitApp() ), this, SLOT( slot_quit()) );
    QObject::connect( m_pWindow, SIGNAL( signal_completed() ), &grSplash, SLOT( slot_close() ) );
}

#ifdef win32
bool CSystemStatus::winEventFilter(MSG *p_pMsg, qintptr *p_pResult)
{
    Q_UNUSED( p_pResult )

    // Process only if not detected before
    if ( m_bResumeDetected == true )
    {
        return false;
    }

    if ( p_pMsg->message == WM_POWERBROADCAST )
    {
        if ( ( p_pMsg->wParam == PBT_APMRESUMESUSPEND ) ||
             ( p_pMsg->wParam == PBT_APMRESUMEAUTOMATIC ) )
        {
            //std::cout << "Received RESUME Event" << std::endl;

            m_bResumeDetected = true;
            emit signal_systemResume();
            QTimer::singleShot( 2000, this, SLOT( slot_timeout()) );
        }
        else if( p_pMsg->wParam == PBT_APMSUSPEND )
        {
            emit signal_goingToSuspend();
        }
    }
    return false;
}
#endif

/// @todo Implement functionality for other OS.

void CSystemStatus::slot_timeout()
{
    m_bResumeDetected = false;
}

void CSystemStatus::slot_quit()
{
    this->quit();
}

#ifdef win32
CNativeEventFilter::CNativeEventFilter(CSystemStatus *p_pSystemStatus)
    : m_pSystemStatus ( p_pSystemStatus )
{

}

bool CNativeEventFilter::nativeEventFilter(const QByteArray & p_grEventType, void * p_pMessage, qintptr * p_nResult)
{

    //   On Windows, eventType is set to "windows_generic_MSG" for messages sent
    //   to toplevel windows, and "windows_dispatcher_MSG" for system-wide
    //   messages such as messages from a registered hot key. In both cases,
    //   the message can be casted to a MSG pointer. The result pointer is only
    //   used on Windows, and corresponds to the LRESULT pointer.

    if ( p_grEventType == "windows_generic_MSG")
    {
        MSG     * pMsg = static_cast< MSG *>    ( p_pMessage );
        m_pSystemStatus->winEventFilter( pMsg, p_nResult );
    }
    return false;
}
#endif
