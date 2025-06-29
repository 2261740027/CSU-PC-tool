#ifndef SLIPPROTOCOL_H
#define SLIPPROTOCOL_H

#include <QByteArray>
#include <QObject>
#include <QElapsedTimer>
//#include <functional>
#include "Singleton.h"

namespace slip
{
    namespace reserve
    {
        enum
        {
            end = 0xc0,
            esc = 0xdb,
        };
    }

    namespace special
    {
        enum
        {
            end = 0xdc,
            esc = 0xdd,
        };
    }

    namespace next
    {
        enum
        {
            general,
            esc,
        };
    }
    class SlipProtocol : public QObject, public Singleton<SlipProtocol>
    {

        //friend class Singleton<SlipProtocol>; // 允许访问构造

    public:
        SlipProtocol() = default;
        ~SlipProtocol() = default;
        void decode(QByteArray &rxMsg, QByteArray &decodeMsg);
        bool verifyMsg(QByteArray &rxMsg);

        QByteArray recvData;

    private:
        unsigned char nextByteMode = 0;
        bool isGotMsgFlag = false;
    };

}

#endif // SLIPPROTOCOL_H
