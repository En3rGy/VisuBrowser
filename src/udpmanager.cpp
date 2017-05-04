#include "udpmanager.h"
#include <QUdpSocket>
#include <QVector>

CUdpManager::CUdpManager(QObject *parent) :
    QObject(parent)
  , m_pUdpSocket( nullptr )
{
}

void CUdpManager::listen( const uint p_nPort )
{
    m_nPort = p_nPort;

    if ( m_pUdpSocket != nullptr )
    {
        delete m_pUdpSocket;
        m_pUdpSocket = nullptr;
    }

    m_pUdpSocket = new QUdpSocket();

    connect( m_pUdpSocket, SIGNAL( readyRead()), this, SLOT( solt_readPendingDatagrams()));
    m_pUdpSocket->bind( p_nPort );
}

void CUdpManager::solt_readPendingDatagrams()
{
    while ( m_pUdpSocket->hasPendingDatagrams() )
    {
        //QHostAddress grSenderAddress;
        //quint16 unSenderPort;

        QByteArray grData = m_pUdpSocket->readAll();
        emit signal_receivedData( grData );
    }
}

void CUdpManager::sendData( const QString & p_sData, const QString & p_sHostAdress, const quint16 p_unPort )
{
    QByteArray   grByteArry;
    grByteArry.append( p_sData );
    QHostAddress grHostAdress( p_sHostAdress );
    QUdpSocket grUdpSocket;

    qDebug() << tr( "Writing datagram" ) << grByteArry << grHostAdress << ":" << p_unPort << Q_FUNC_INFO;
    grUdpSocket.writeDatagram( grByteArry, grHostAdress, p_unPort );
}
