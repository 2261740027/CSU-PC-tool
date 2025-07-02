#ifndef SERIALCONTROLLER_H
#define SERIALCONTROLLER_H

#include <QObject>
#include <QThread>
#include "SerialWorker.h"
#include <QTimer>
#include "Singleton.h"
#include "SlipProtocol.h"
#include "ProtocolManager.h"

class SerialController : public QObject ,public Singleton<SerialController> {
    Q_OBJECT
    Q_PROPERTY(bool isOpen READ isOpen NOTIFY isOpenChanged)
    Q_PROPERTY(QStringList availablePorts READ availablePorts NOTIFY availablePortsChanged)

    friend class Singleton<SerialController>; // 允许访问构造

public:
    SerialController();
    ~SerialController();

    Q_INVOKABLE void connectPort(QString port, int baud, int dataBits, int stopBits, int parity);
    Q_INVOKABLE void disconnectPort();

    QStringList availablePorts() const { return m_ports; }
    bool isOpen() const { return m_open; }


private:
    void refreshPorts();

    QThread thread;
    protocol::ProtocolManager *_protocolManager;
    QTimer m_portScanTimer;
    QStringList m_ports;
    bool m_open = false;
    
    SerialWorker* worker;

public slots:

    void decodedRaw(QByteArray);                // 处理原始数据
    void handlePageSendData(QByteArray data);   // 处理page请求发送的数据
    
signals:
    //com状态管理
    void openRequest(QString, int, int, int, int);
    void availablePortsChanged();
    void closeRequest();
    void isOpenChanged();

    void sendToWorker(QByteArray);      //通知serial发送数据

    void notificationsPageRecvData(QByteArray);

};

#endif
