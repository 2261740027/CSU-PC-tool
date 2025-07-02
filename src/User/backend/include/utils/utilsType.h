#ifndef UTILSTYPE_H
#define UTILSTYPE_H

namespace utils
{
    namespace type
    {
        union Word
        {
            unsigned short value;
            unsigned char bytes[2];

            struct
            {
                unsigned char lo;
                unsigned char hi;
            } field;
        };

        union Dword
        {
            unsigned long value;
            unsigned char bytes[4];

            struct
            {
                unsigned short lo;
                unsigned short hi;
            } field;
        };

        union Dlong
        {
            unsigned long long int value;
            union Word word[4];
        };

        union Ufloat
        {
            float value;
            unsigned char bytes[4];

            struct
            {
                unsigned short lo;
                unsigned short hi;
            } field;
        };

        extern short bigEndian2LittleEndian(short data);
        extern unsigned short bigEndian2LittleEndian(unsigned short data);
        extern unsigned long bigEndian2LittleEndian(unsigned long data);
    }
}

#endif