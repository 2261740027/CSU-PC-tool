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
    Q_PROPERTY(int currentPortIndex READ currentPortIndex NOTIFY currentParametersChanged)
    Q_PROPERTY(int currentBaudRateIndex READ currentBaudRateIndex NOTIFY currentParametersChanged)
    Q_PROPERTY(int currentDataBitsIndex READ currentDataBitsIndex NOTIFY currentParametersChanged)
    Q_PROPERTY(int currentStopBitsIndex READ currentStopBitsIndex NOTIFY currentParametersChanged)
    Q_PROPERTY(int currentParityIndex READ currentParityIndex NOTIFY currentParametersChanged)

    friend class Singleton<SerialController>; // 允许访问构造

public:
    SerialController();
    ~SerialController();

    Q_INVOKABLE void connectPort(QString port, int baud, int dataBits, int stopBits, int parity);
    Q_INVOKABLE void disconnectPort();

    QStringList availablePorts() const { return m_ports; }
    bool isOpen() const { return m_open; }
    
    // 获取当前连接参数索引
    int currentPortIndex() const { return m_currentPortIndex; }
    int currentBaudRateIndex() const { return m_currentBaudRateIndex; }
    int currentDataBitsIndex() const { return m_currentDataBitsIndex; }
    int currentStopBitsIndex() const { return m_currentStopBitsIndex; }
    int currentParityIndex() const { return m_currentParityIndex; }

private:
    void refreshPorts();

    QThread thread;
    protocol::ProtocolManager *_protocolManager;
    QTimer m_portScanTimer;
    QStringList m_ports;
    bool m_open = false;
    
    // 当前连接参数索引
    int m_currentPortIndex = -1;
    int m_currentBaudRateIndex = 1;   // 默认115200
    int m_currentDataBitsIndex = 3;   // 默认8位
    int m_currentStopBitsIndex = 0;   // 默认1位停止位
    int m_currentParityIndex = 0;     // 默认无校验
    
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

    // 串口参数变化信号（合并）
    void currentParametersChanged();

    void sendToWorker(QByteArray);      //通知serial发送数据

    void notificationsPageRecvData(QByteArray);

};

#endif
