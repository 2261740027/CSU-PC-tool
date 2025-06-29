#include "SerialController.h"
#include "ProtocolManager.h"
#include <QSerialPortInfo>

SerialController::SerialController() {
    worker = new SerialWorker;
    worker->moveToThread(&thread);

    _protocolManager = protocol::ProtocolManager::getInstance();

    connect(this, &SerialController::sendToWorker, worker, &SerialWorker::send);
    connect(this, &SerialController::openRequest, worker, &SerialWorker::open);
    connect(this, &SerialController::closeRequest, worker, &SerialWorker::close);
    connect(worker, &SerialWorker::receivedText, this, &SerialController::receivedText);
    connect(worker, &SerialWorker::receivedRaw, this, &SerialController::receivedRaw);
    connect(worker, &SerialWorker::portOpened, this, [this](bool ok) {
        m_open = ok;
        emit isOpenChanged();
    });

    thread.start();

    // 定时扫描串口
    connect(&m_portScanTimer, &QTimer::timeout, this, &SerialController::refreshPorts);
    m_portScanTimer.start(1000);  // 每秒刷新一次
    refreshPorts();               // 启动时立即刷新一次
}

SerialController::~SerialController() {

    //emit closeRequest();
    QMetaObject::invokeMethod(worker, "close", Qt::DirectConnection);

    thread.quit();
    thread.wait();
    delete worker;
}

void SerialController::refreshPorts() {
    QStringList current;
    const auto ports = QSerialPortInfo::availablePorts();
    for (const auto &info : ports) {
        current.append(info.portName());
    }

    if (current != m_ports) {
        m_ports = current;
        emit availablePortsChanged();
    }
}

void SerialController::connectPort(QString port, int baud, int dataBits, int stopBits, int parity) {
    emit openRequest(port, baud, dataBits, stopBits, parity);
}

void SerialController::disconnectPort() {
    emit closeRequest();
    m_open = false;
    emit isOpenChanged();
}

void SerialController::send(QString text) {
    emit sendToWorker(text);
}

void SerialController::receivedRaw(QByteArray data)
{
    // 根据协议类型和页面进行有效数据提取
    if(_protocolManager->currentProtocol() != nullptr)
    {
        _protocolManager->HandleRecvData(data);
    }

}
