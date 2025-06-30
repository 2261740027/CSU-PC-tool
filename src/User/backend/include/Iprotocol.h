#ifndef IPROTOCOL_H
#define IPROTOCOL_H

#include <QString>
#include <QByteArray>
#include <QVariantMap>
#include <vector>

namespace protocol {

    class iProtocol {

    public:
        virtual ~iProtocol() = default;

        virtual QString name() const = 0;

        virtual bool verifyMsg(QByteArray &rxMsg) = 0;
        virtual void decodeFrame(QByteArray &rxMsg , std::vector<QByteArray> &decodeMsg) = 0;
        virtual void buildFrame() = 0;
        
    };

}

#endif
