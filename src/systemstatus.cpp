#include "systemstatus.h"
#include <iostream>
#include <QTimer>

#ifdef win32
#include <windows.h>
#endif

CSystemStatus::CSystemStatus(  int & p_nArgc , char ** & p_ppArgv )
    :  QGuiApplication( p_nArgc, p_ppArgv )
    , m_bResumeDetected( false )
{
    CNativeEventFilter grFilter( this );
    installNativeEventFilter( & grFilter );
}

#ifdef win32
bool CSystemStatus::winEventFilter(MSG *p_pMsg, long *p_pResult)
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

void CSystemStatus::slot_sendStatus(QString p_sStatus, QString p_sAddr, int p_nPort)
{
    CUdpManager::sendData( p_sStatus, p_sAddr, p_nPort );
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

bool CNativeEventFilter::nativeEventFilter(const QByteArray & p_grEventType, void * p_pMessage, long * p_nResult)
{

    //   On Windows, eventType is set to "windows_generic_MSG" for messages sent
    //   to toplevel windows, and "windows_dispatcher_MSG" for system-wide
    //   messages such as messages from a registered hot key. In both cases,
    //   the message can be casted to a MSG pointer. The result pointer is only
    //   used on Windows, and corresponds to the LRESULT pointer.

    if ( p_grEventType == "windows_generic_MSG")
    {
        MSG     * pMsg = static_cast< MSG *>    ( p_pMessage );
        LRESULT * pRes = static_cast< LRESULT *>( p_nResult );

        Q_UNUSED( pRes )

        m_pSystemStatus->winEventFilter( pMsg, pRes );
    }
    return false;
}
#endif
