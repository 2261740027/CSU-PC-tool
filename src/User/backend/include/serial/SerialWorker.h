#ifndef SERIALWORKER_H
#define SERIALWORKER_H

#include <QObject>
#include <QSerialPort>

class SerialWorker : public QObject {
    Q_OBJECT
public slots:
    void open(QString portName, int baudRate, int dataBits, int stopBits, int parity);
    void close();
    void send(QByteArray data);
signals:
    void receivedRaw(QByteArray data);      //接收到数据后通知serIalController
    void portOpened(bool success);
private slots:
    void onReadyRead();             //从QSerialPort读取数据
private:
    QSerialPort *serial = nullptr;
};


#endif
