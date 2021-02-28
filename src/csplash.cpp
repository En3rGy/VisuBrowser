#include "csplash.h"
#include <QDebug>

CSplash::CSplash(QSplashScreen *parent)
    : QSplashScreen( parent )
{

}

CSplash::CSplash(QPixmap &grPixMap)
    : QSplashScreen( grPixMap )
{

}

void CSplash::slot_close()
{
    this->close();
}
