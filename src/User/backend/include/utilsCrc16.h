#ifndef UTILSCRC16_H
#define UTILSCRC16_H

#include <QByteArray>

namespace utils
{

    class Crc16
    {
    public:
        virtual unsigned short calc(QByteArray &data, unsigned int length, unsigned short crcValue = 0);
    };
}

#endif
