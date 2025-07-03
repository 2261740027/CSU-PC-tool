#include "page/pageBase.h"
#include <QDebug>

namespace page
{

    const static QList<PageField> settingPageFieldList = {
        {"bus1", "ushort", 2, 0x60, 0x10, 0x01},
        {"bus2", "ushort", 2, 0x60, 0x11, 0x01}};

    class settingPage : public pageBase
    {
    public:
        settingPage() : pageBase(settingPageFieldList) {

                        };
        ~settingPage() = default;
    };
}
