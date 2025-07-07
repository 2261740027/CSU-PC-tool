#ifndef PAGEINFOMAININFO_H
#define PAGEINFOMAININFO_H

#include "page/pageBase.h"
#include <QDebug>

namespace page
{
    class pageMange;

    const static QList<PageField> infoMainInfoPageFieldList = {
        /*                              数据类型   数据长度   group      category     number              */
        {"sysVolt",                     "float",    4,      0x10,       0x24,       0x01},              // 系统电压
        {"sysCurr",                     "float",    4,      0x10,       0x21,       0x02},
        {"sysPower",                    "float",    4,      0x10,       0x26,       0x01},
        {"load",                        "float",    4,      0x10,       0x25,       0x02},
        {"loadVolt",                    "float",    4,      0x10,       0x23,       0x11},
        {"loadCurr",                    "float",    4,      0x10,       0x21,       0x01},
        {"sysEnergy",                   "float",    4,      0x10,       0x26,       0x02},
        {"ambiTemp",                    "float",    4,      0x10,       0x27,       0x01},

    };

    class infoMainInfoPage : public pageBase
    {
        Q_OBJECT
    public:
        infoMainInfoPage(pageMange *pageManager);
        ~infoMainInfoPage() = default;

        // 基类已经实现了所有轮询功能，只需要重写handlePageDataUpdate来添加特殊处理（如果需要）
        QString handlePageDataUpdate(const QByteArray &data) override;

    private:
        static constexpr pageAttribute_t _infoMainInfoPageAttribute = {
            .isRefresh = 1};
    };
}

#endif
