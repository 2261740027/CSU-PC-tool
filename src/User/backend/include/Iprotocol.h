#ifndef IPROTOCOL_H
#define IPROTOCOL_H

#include <QString>
#include <QByteArray>
#include <QVariantMap>

namespace protocol {

    class iProtocol {

    public:
        virtual ~iProtocol() = default;

        virtual QString name() const = 0;

        virtual bool verifyMsg(QByteArray &rxMsg) = 0;
        virtual void decodeFrame(QByteArray &rxMsg ,QByteArray &decodeMsg) = 0;
        virtual void buildFrame() = 0;
        
    };

}

#endif
