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

            bool decodeFrame(QByteArray &rxMsg, QByteArray &decodeMsg)  override;
            bool verifyMsg(QByteArray &rxMsg) override;                          //验证数据校验是否正确
            void encodeFrame(QByteArray &data, QByteArray &sendFrame) override;   //只负责添加帧头帧尾和校验
            
            QString name() const override {
                return "slip";
            }

        private:
            //void handleRecvQueryData(QByteArray &data, QMap<QString, dbTable::DBItem>& dbTable);
            //void handleRecvSettingData(QByteArray &data, QMap<QString, dbTable::DBItem>& dbTable);

            bool _isGotMsgFlag;
            unsigned char _nextByteMode;
        };

    }
}

#endif // SLIPPROTOCOL_H
