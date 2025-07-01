#include "ProtocolManager.h"
#include "SlipProtocol.h"
#include <QDebug>
#include <QString>

namespace protocol
{
    ProtocolManager::ProtocolManager()
    {
        static protocol::slip::slipProtocol slipProtocol;

        registerProtocol(&slipProtocol);
        
        _current = &slipProtocol;           //默认协议为slip协议
    }

    bool ProtocolManager::registerProtocol(iProtocol* proto)
    {
        const QString key = proto->name();
        if (_protocolMap.contains(key)) {
            qWarning() << "Protocol already registered:" << key;
            return false;
        }
        _protocolMap.insert(key, proto);
        return true;
    }

    QByteArray ProtocolManager::HandleRecvData(QByteArray &data)
    {
        QByteArray rxData;
        if(_current != nullptr)
        {
            _current->decodeFrame(data,rxData);
            return rxData;
            //qDebug() << "recvData: " + data.toHex(' ').toUpper();
        }
        return QByteArray();
    }
}
