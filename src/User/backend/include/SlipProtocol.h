#ifndef SLIPPROTOCOL_H
#define SLIPPROTOCOL_H

#include <QByteArray>
#include <QObject>
#include <QElapsedTimer>
#include "Iprotocol.h"
// #include <functional>
// #include "Singleton.h"

namespace protocol
{
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

        class slipProtocol : public iProtocol
        {

        public:
            slipProtocol(): _isGotMsgFlag(0),_nextByteMode(0) {};
            ~slipProtocol() = default;

            QString name() const override
            {
                return "slip";
            }

            void decodeFrame(QByteArray &rxMsg, QByteArray &decodeMsg) override;
            bool verifyMsg(QByteArray &rxMsg) override;
            void buildFrame() override;
            

        private:
            bool _isGotMsgFlag;
            unsigned char _nextByteMode;
        };

    }
}

#endif // SLIPPROTOCOL_H
