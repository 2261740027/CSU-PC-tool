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

    QByteArray ProtocolManager::handleRecvData(QByteArray &data)
    {
        QByteArray rxData;
        if(true == _current->decodeFrame(data,rxData))
        {
            return rxData;
        }

        return QByteArray(); //返回空数据表示没有有效数据
    }
    
    void ProtocolManager::handleSendData(QByteArray &data,QByteArray &sendFrame)
    {
		if (_current != nullptr) {
			_current->encodeFrame(data,sendFrame);
			//qDebug() << "sendData: " + data.toHex(' ').toUpper();
		}
	}
}
