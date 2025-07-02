#include "SlipProtocol.h"
#include "utilsCrc16.h"
#include "utilsType.h"
#include <QDebug>

namespace protocol
{
    namespace slip
    {  
        void slipProtocol::decodeFrame(QByteArray &rxMsg, QByteArray &decodeMsg)
        {
            for (unsigned char rxChar : rxMsg)
            {
                switch (rxChar)
                {
                case 0xC0:

                    if (this->verifyMsg(decodeMsg) == true)
                    {
                        _isGotMsgFlag = true;
                        // this->isGotMsgFlag = true;
                        //  true;
                    }
                    else
                    {
                        // my.clear();
                        // rxMsg.clear();
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

            //    printf("myCrc:             %4x\r\n",myCrc);
            //    printf("receivedPacketCrc: %4x\r\n",receivedPacketCrc.value);

            if (myCrc == receivedPacketCrc.value)
            {
                //----- to deduct crc16(last 2 bytes) from rxQueue,because crc16 just for verify
                rxMsg.remove(rxMsg.length() - 2, 2);
                return true;
            }
            else
            {
                return false;
            }
        }

        void slipProtocol::buildFrame(QByteArray &data, QByteArray &sendFram)
        {
            // if querry
            utils::Crc16 crc16;
            unsigned short myCrc = 0;

            myCrc = crc16.calc(data, data.length());

            data.append((char)(myCrc & 0x00FF)); // low byte
            data.append((char)((myCrc >> 8) & 0x00FF)); // high byte

            sendFram.append (0xC0);
            for(int i = 0; i < data.length(); i++)
            {
                sendFram.append(data[i]);
            }
            sendFram.append(0xC0); // end of frame
            //emit notificationsSendData(sendFram);
        }

        void slipProtocol::handleRecvData(QByteArray &data)
        {

        }

    }
}
