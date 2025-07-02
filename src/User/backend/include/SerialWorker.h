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
    void receivedText(QString text);
    void receivedRaw(QByteArray data);
    void portOpened(bool success);
private slots:
    void onReadyRead();
private:
    QSerialPort *serial = nullptr;
};


#endif
