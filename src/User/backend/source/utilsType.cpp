#include "utilsType.h"

namespace utils
{
    namespace type
    {
        short bigEndian2LittleEndian(short data)
        {
            utils::type::Word word;

            word.field.hi = ((utils::type::Word &)data).field.lo;
            word.field.lo = ((utils::type::Word &)data).field.hi;

            return (short)word.value;
        }
        //---------------------------------------------------------------------------
        unsigned short bigEndian2LittleEndian(unsigned short data)
        {
            utils::type::Word word;

            word.field.hi = ((utils::type::Word &)data).field.lo;
            word.field.lo = ((utils::type::Word &)data).field.hi;

            return word.value;
        }
        //---------------------------------------------------------------------------
        unsigned long bigEndian2LittleEndian(unsigned long data)
        {
            utils::type::Dword dword;

            dword.bytes[0] = ((utils::type::Dword &)data).bytes[3];
            dword.bytes[1] = ((utils::type::Dword &)data).bytes[2];
            dword.bytes[2] = ((utils::type::Dword &)data).bytes[1];
            dword.bytes[3] = ((utils::type::Dword &)data).bytes[0];

            return dword.value;
        }

    }

}