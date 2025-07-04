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
    connect(worker, &SerialWorker::receivedRaw, this, &SerialController::decodedRaw);
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
    // 保存当前连接参数的索引
    m_currentPortIndex = m_ports.indexOf(port);
    
    // 波特率索引转换
    if (baud == 9600) {
        m_currentBaudRateIndex = 0;
    } else if (baud == 115200) {
        m_currentBaudRateIndex = 1;
    }
    
    // 数据位索引转换
    if (dataBits == 5) {
        m_currentDataBitsIndex = 0;
    } else if (dataBits == 6) {
        m_currentDataBitsIndex = 1;
    } else if (dataBits == 7) {
        m_currentDataBitsIndex = 2;
    } else if (dataBits == 8) {
        m_currentDataBitsIndex = 3;
    }
    
    // 停止位索引转换
    if (stopBits == 1) {
        m_currentStopBitsIndex = 0;
    } else if (stopBits == 3) {  // 1.5停止位
        m_currentStopBitsIndex = 1;
    } else if (stopBits == 2) {
        m_currentStopBitsIndex = 2;
    }
    
    // 校验位索引转换
    if (parity == 0) {      // none
        m_currentParityIndex = 0;
    } else if (parity == 2) {  // odd
        m_currentParityIndex = 1;
    } else if (parity == 3) {  // even
        m_currentParityIndex = 2;
    }
    
    // 发出参数变化信号
    emit currentParametersChanged();
    
    emit openRequest(port, baud, dataBits, stopBits, parity);
}

void SerialController::disconnectPort() {
    emit closeRequest();
    m_open = false;
    
    // 清除当前连接参数索引
    m_currentPortIndex = -1;
    m_currentBaudRateIndex = 1;   // 默认115200
    m_currentDataBitsIndex = 3;   // 默认8位
    m_currentStopBitsIndex = 0;   // 默认1位停止位
    m_currentParityIndex = 0;     // 默认无校验
    
    // 发出参数变化信号
    emit currentParametersChanged();
    
    emit isOpenChanged();
}

void SerialController::decodedRaw(QByteArray data)
{
    // 根据协议类型校验提取有效内容
    QByteArray decodeData;
    if(_protocolManager->currentProtocol() != nullptr)
    {
        decodeData = _protocolManager->handleRecvData(data);

        if(!decodeData.isEmpty())       //接收数据有效，交给page处理
        {
           emit notificationsPageRecvData(decodeData); 
        }
    }
}


void SerialController::handlePageSendData(QByteArray data)
{
    //_protocolManager->_current->buildFrame(data);
    QByteArray sendFrame;
    _protocolManager->handleSendData(data,sendFrame);
    emit sendToWorker(sendFrame);
}
