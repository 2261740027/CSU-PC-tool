#include "SlipProtocol.h"
#include "utilsCrc16.h"
#include "utilsType.h"
#include <QDebug>

namespace protocol
{
    namespace slip
    {  
        bool slipProtocol::decodeFrame(QByteArray &rxMsg, QByteArray &decodeMsg)
        {
            _isGotMsgFlag = false;
            for (unsigned char rxChar : rxMsg)
            {
                switch (rxChar)
                {
                case 0xC0:

                    if (this->verifyMsg(decodeMsg) == true)
                    {
                        _isGotMsgFlag = true;
                    }
                    else
                    {
                        decodeMsg.clear();
                    }

                    break;

                case (unsigned char)slip::reserve::esc:

                    _nextByteMode = slip::next::esc;
                    break;

                default:

                    if (_nextByteMode == slip::next::esc)
                    {
                        unsigned char reserveCode;

                        switch (rxChar)
                        {
                        case slip::special::esc:

                            reserveCode = slip::reserve::esc;
                            // rxMsg.push(reserveCode);
                            decodeMsg.append(reserveCode);

                            break;

                        case slip::special::end:

                            reserveCode = slip::reserve::end;
                            // rxMsg.push(reserveCode);
                            decodeMsg.append(reserveCode);

                            break;

                        default:
                            // my.onError();
                            break;
                        }
                    }
                    else
                    {
                        decodeMsg.append(rxChar);
                    }

                    _nextByteMode = slip::next::general;
                    break;
                }
            }

            return _isGotMsgFlag ? true : false;
        }

        bool slipProtocol::verifyMsg(QByteArray &rxMsg)
        {
            static const unsigned int packetMinLength = 5;

            if (rxMsg.length() < packetMinLength)
            {
                return false;
            }

            utils::Crc16 crc16;

            unsigned short myCrc;
            utils::type::Word receivedPacketCrc;

            myCrc = crc16.calc(rxMsg, rxMsg.length() - 2);

            // last two bytes of packet are crc16 code
            receivedPacketCrc.field.hi = rxMsg[rxMsg.length() - 1];
            receivedPacketCrc.field.lo = rxMsg[rxMsg.length() - 2];


            if (myCrc == receivedPacketCrc.value)
            {
                rxMsg.remove(rxMsg.length() - 2, 2);
                return true;
            }
            else
            {
                return false;
            }
        }
        void slipProtocol::encodeFrame(QByteArray &data, QByteArray &sendFrame)
        {
            utils::Crc16 crc16;
            unsigned short myCrc = crc16.calc(data, data.length());

            QByteArray dataWithCrc = data;
            dataWithCrc.append((char)(myCrc & 0x00FF));        // CRC低字节
            dataWithCrc.append((char)((myCrc >> 8) & 0x00FF)); // CRC高字节

            sendFrame.clear();
            sendFrame.append((char)slip::reserve::end); // 0xC0 起始标记

            for (int i = 0; i < dataWithCrc.length(); i++)
            {
                unsigned char txChar = (unsigned char)dataWithCrc[i];

                switch (txChar)
                {
                case (unsigned char)slip::reserve::end: // 0xC0
                    sendFrame.append((char)slip::reserve::esc); // 0xDB
                    sendFrame.append((char)slip::special::end); // 0xDC
                    break;

                case (unsigned char)slip::reserve::esc: // 0xDB
                    sendFrame.append((char)slip::reserve::esc); // 0xDB
                    sendFrame.append((char)slip::special::esc); // 0xDD
                    break;

                default:
                    sendFrame.append((char)txChar);
                    break;
                }
            }

            sendFrame.append((char)slip::reserve::end); // 0xC0 结束标记
        }
    }
}
