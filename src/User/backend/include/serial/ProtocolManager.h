#ifndef PROTOCOLMANAGER_H
#define PROTOCOLMANAGER_H

#include <qdebug.h>
#include <qstring.h>
#include <QOBject>
#include "Singleton.h"
#include "Iprotocol.h"

namespace protocol
{
	class ProtocolManager : public QObject, public Singleton<ProtocolManager>
	{

		friend class Singleton<ProtocolManager>;

	public:
		// Add methods to manage protocols, e.g., register, unregister, etc.
		iProtocol* currentProtocol() const { return _current; }
		
		bool registerProtocol(iProtocol* proto);
		void unregisterProtocol(const QString &protocolName) { _protocolMap.remove(protocolName);}
		
		void setCurrentProtocol(const QString& name) {
 	    	_current = getProtocol(name);
    	}

		
        QByteArray handleRecvData(QByteArray &data);       //处理接受到的数据

		void handleSendData(QByteArray &data,QByteArray &sendFram);
		
	private:
		
		ProtocolManager();
		~ProtocolManager() = default;

		iProtocol* getProtocol(const QString& name) const {
        	return _protocolMap.value(name, nullptr);
    	}
		
		QHash<QString, iProtocol*> _protocolMap;   //使用hash保存协议
    	iProtocol* _current = nullptr;
	};
}


#endif
