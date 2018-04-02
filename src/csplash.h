#ifndef CSPLASH_H
#define CSPLASH_H

#include <QSplashScreen>

class CSplash : public QSplashScreen
{
    Q_OBJECT

public:
    CSplash( QSplashScreen * parent );
    CSplash( QPixmap & grPixMap );

public slots:
    void slot_close( void );
};

#endif // CSPLASH_H
