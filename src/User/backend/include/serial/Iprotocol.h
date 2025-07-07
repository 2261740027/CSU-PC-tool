#ifndef IPROTOCOL_H
#define IPROTOCOL_H

#include <QString>
#include <QByteArray>
#include <QVariantMap>

namespace protocol {

    class iProtocol {

    public:
        virtual ~iProtocol() = default;

        virtual QString name() const = 0;                       //This is the name of the protocol, e.g., "slip", "modbus", etc.
        virtual bool verifyMsg(QByteArray &rxMsg) = 0;          //This function verifies the received message, returning true if valid.
        virtual bool decodeFrame(QByteArray &rxMsg, QByteArray &decodeMsg) = 0; //提取有效数据后传入下一级进行解析
        virtual void encodeFrame(QByteArray &data, QByteArray &sendFrame) = 0;   //组装数据帧，发送前调用
        //virtual void buildFrame(QByteArray &data, QByteArray &sendFram) = 0;    //按照协议格式组装数据帧
    };

}

#endif
