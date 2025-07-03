#include "page/pageBase.h"
#include <QDebug>

namespace page
{

    const static QList<PageField> mainPageFieldList = {
        {"Voltage", "ushort", 2, 0x50, 0x10, 0x01},
        {"Current", "ushort", 2, 0x50, 0x11, 0x01}};

    class mainPage : public pageBase
    {
    public:
        mainPage() : pageBase(mainPageFieldList) {

                     };
        ~mainPage() = default;

        void refreshPageAllData() override
        {
        }

    private:
        bool _pageReflashState = false;
    };
}
