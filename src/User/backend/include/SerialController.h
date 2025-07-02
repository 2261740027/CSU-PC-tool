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
    Q_INVOKABLE void send(QString text);

    QStringList availablePorts() const { return m_ports; }
    bool isOpen() const { return m_open; }

public slots:

    void receivedRaw(QByteArray);       //接收到原始数据
    void sendDataToWorker(QByteArray data); //发送数据到worker
    
signals:
    void sendToWorker(QByteArray);
    void openRequest(QString, int, int, int, int);
    void closeRequest();
    void receivedText(QString);
    //void receivedRaw(QString);
    void isOpenChanged();
    void availablePortsChanged();
    void notificationsPageRecvData(QByteArray data);

private:
    void refreshPorts();

    QThread thread;
    SerialWorker* worker;
    protocol::ProtocolManager *_protocolManager;
    QTimer m_portScanTimer;
    QStringList m_ports;

    bool m_open = false;
};

#endif
