#ifndef SYSTEMSTATUS_H
#define SYSTEMSTATUS_H

#include <QApplication>
#include <QAbstractNativeEventFilter>

class CNativeEventFilter;

class CSystemStatus : public QApplication
{
    Q_OBJECT

public:
  CSystemStatus( int &, char ** & );

#ifdef win32
  bool winEventFilter ( MSG * p_pMsg, long * p_pResult );
#endif

public slots:
  void slot_timeout( void );
  void slot_quit( void );

signals:
  void signal_systemResume( void );
  void signal_goingToSuspend( void );

private:
  bool                 m_bResumeDetected;
  CNativeEventFilter * m_pNativeEventFilter;
};

// ################################################
//
// ################################################

class CNativeEventFilter : public QAbstractNativeEventFilter
{
public:
    CNativeEventFilter( CSystemStatus * p_pSystemStatus );
    virtual bool nativeEventFilter(const QByteArray &p_grEventType, void *p_pMessage, long *p_nResult);

private:
    CSystemStatus * m_pSystemStatus;

};

#endif // SYSTEMSTATUS_H
