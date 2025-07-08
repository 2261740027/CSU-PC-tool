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
        
        const QHash<unsigned short, unsigned short> groupDataSizeMap = {
            {0x03, 1},
            {0x05, 1},
            {0x08, 4},
            {0x10, 4},
            {0x12, 2},
            {0x14, 1},
            {0x16, 6},
            {0x18, 2},
            {0x24, 20},
            {0x26, 8},
            {0x30, 4},
            {0x32, 4},
            {0x34, 1},
            {0x40, 12},
            {0x42, 16},
            {0x50, 2},
            {0x52, 2},
            {0x54, 2},
            {0x56, 1},
            {0x58, 1},
            {0x60, 12},
            {0x64, 8},
            {0x66, 4},
        };





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
            
            QByteArray _receiveBuffer;          
            void clearReceiveBuffer();          // 清空接收缓冲区
        };

    }
}

#endif // SLIPPROTOCOL_H
