#include <QSerialPortInfo>
#include "SerialWorker.h"


void SerialWorker::open(QString portName, int baudRate, int dataBits, int stopBits, int parity) {
    if (serial) {
        if (serial->isOpen()) serial->close();
        delete serial;
    }

    serial = new QSerialPort();

    serial->setPortName(portName);
    serial->setBaudRate(static_cast<QSerialPort::BaudRate>(baudRate));
    serial->setDataBits(static_cast<QSerialPort::DataBits>(dataBits));
    serial->setStopBits(static_cast<QSerialPort::StopBits>(stopBits));
    serial->setParity(static_cast<QSerialPort::Parity>(parity));
    serial->setFlowControl(QSerialPort::NoFlowControl);

    bool ok = serial->open(QIODevice::ReadWrite);
    if (ok)
        connect(serial, &QSerialPort::readyRead, this, &SerialWorker::onReadyRead, Qt::UniqueConnection);
    emit portOpened(ok);
}

void SerialWorker::close() {
    if (serial) {
        if (serial->isOpen()) serial->close();
        delete serial;
        serial = nullptr;
    }
}

void SerialWorker::send(QString text) {
    if (serial && serial->isOpen()) {
        serial->write(text.toUtf8());
    }
}

void SerialWorker::onReadyRead() {
    QByteArray data = serial->readAll();
    QString hexString = data.toHex(' ').toUpper();

    //emit receivedText(QString::fromUtf8(data));
    emit receivedRaw(hexString);
}
