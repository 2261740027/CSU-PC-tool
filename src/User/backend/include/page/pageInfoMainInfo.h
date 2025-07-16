#ifndef PAGEINFOMAININFO_H
#define PAGEINFOMAININFO_H

#include "page/pageBase.h"
#include <QDebug>

namespace page
{
    class pageMange;

    static QList<PageField> infoMainInfoPageFieldList = {
        /*                              数据类型   数据长度   group      category     number              */
        {"sysVolt",                     "float",    4,      0x10,       0x24,       0x01},              // 系统电压
        {"sysCurr",                     "float",    4,      0x10,       0x21,       0x02},
        {"sysPower",                    "float",    4,      0x10,       0x26,       0x01},
        {"load",                        "float",    4,      0x10,       0x25,       0x02},
        {"loadVolt",                    "float",    4,      0x10,       0x23,       0x11},
        {"loadCurr",                    "float",    4,      0x10,       0x21,       0x01},
        {"sysEnergy",                   "float",    4,      0x10,       0x26,       0x02},
        {"ambiTemp",                    "float",    4,      0x10,       0x27,       0x01},
        {"BattAVolt",                   "float",    4,      0x10,       0x31,       0x01},             
        {"BattACurr",                   "float",    4,      0x10,       0x30,       0x01},
        {"BattATemp",                   "float",    4,      0x10,       0x33,       0x01},
        {"BattABrk",                    "ushort",   2,      0x12,       0x3A,       0x01},
        {"BattBVolt",                   "float",    4,      0x10,       0x31,       0x11},             
        {"BattBCurr",                   "float",    4,      0x10,       0x30,       0x11},
        {"BattBTemp",                   "float",    4,      0x10,       0x33,       0x11},
        {"BattBBrk",                    "ushort",   2,      0x12,       0x3B,       0x01},
        {"AC1Phase1Volt",               "float",    4,      0x10,       0x10,       0x01},
        {"AC1Phase2Volt",               "float",    4,      0x10,       0x10,       0x02},
        {"AC1Phase3Volt",               "float",    4,      0x10,       0x10,       0x03},
        {"AC1Phase1Curr",               "float",    4,      0x10,       0x11,       0x01},
        {"AC1Phase2Curr",               "float",    4,      0x10,       0x11,       0x02},
        {"AC1Phase3Curr",               "float",    4,      0x10,       0x11,       0x03},
        {"AC1Freq",                     "float",    4,      0x10,       0x12,       0x01},
        {"AC2Phase1Volt",               "float",    4,      0x10,       0x10,       0x11},
        {"AC2Phase2Volt",               "float",    4,      0x10,       0x10,       0x12},
        {"AC2Phase3Volt",               "float",    4,      0x10,       0x10,       0x13},
        {"AC2Phase1Curr",               "float",    4,      0x10,       0x11,       0x11},
        {"AC2Phase2Curr",               "float",    4,      0x10,       0x11,       0x12},
        {"AC2Phase3Curr",               "float",    4,      0x10,       0x11,       0x13},
        {"AC2Freq",                     "float",    4,      0x10,       0x12,       0x11},
        {"supplyPower",                 "ushort",   2,      0x12,       0x12,       0x01},
        {"CSUASysStatus",               "ushort",   2,      0x12,       0x20,       0x01},
        {"CSUARectNum",                 "ushort",   2,      0x12,       0x40,       0x01},
        {"CSUBSysStatus",               "ushort",   2,      0x12,       0x20,       0x11},
        {"CSUBRectNum",                 "ushort",   2,      0x12,       0x40,       0x11},
        {"CSUCSysStatus",               "ushort",   2,      0x12,       0x20,       0x21},
        {"CSUCRectNum",                 "ushort",   2,      0x12,       0x40,       0x21},
        //系统时间
        {"sysAlarm",                    "ushort",   2,      0x12,       0x11,       0x01},
        {"sysEFFS",                     "ushort",   2,      0x12,       0x13,       0x01},
        {"RTCBattVolt",                 "float",    4,      0x10,       0xF3,       0x01}


    };

    const static QList<QByteArray> infoMainInfoPageQuerryCmdList = {
        // QByteArray::fromHex("101000"),
        // QByteArray::fromHex("101100"),
        // QByteArray::fromHex("101200"),
        // QByteArray::fromHex("102100"),
        // QByteArray::fromHex("102300"),
        // QByteArray::fromHex("102500"),
        // QByteArray::fromHex("102600"),
        // QByteArray::fromHex("103000"),
        // QByteArray::fromHex("103100"),
        // QByteArray::fromHex("103300"),
        // QByteArray::fromHex("121100"),
        // QByteArray::fromHex("121200"),
        // QByteArray::fromHex("121300"),
        // QByteArray::fromHex("122000"),
        // QByteArray::fromHex("123A00"),
        // QByteArray::fromHex("124000"),
    
    };

    class infoMainInfoPage : public pageBase
    {
        Q_OBJECT
    public:
        infoMainInfoPage(pageMange *pageManager);
        ~infoMainInfoPage() = default;

        // 基类已经实现了所有轮询功能，只需要重写handlePageDataUpdate来添加特殊处理（如果需要）
        pageDataUpdateResult_t handlePageDataUpdate(const QByteArray &data) override;

    private:
        void initPageQuerryCmdList();
        static constexpr pageAttribute_t _infoMainInfoPageAttribute = {
            .isRefresh =1};
    };
}

#endif
