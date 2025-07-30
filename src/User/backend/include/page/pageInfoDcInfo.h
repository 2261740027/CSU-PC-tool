#ifndef PAGEINFODCINFO_H
#define PAGEINFODCINFO_H
#include "page/pageBase.h"

namespace page
{
    class pageMange;

    static QList<PageField> infoDcInfoPageFieldList = {
        /*                              数据类型   数据长度   group      category     number              */
        
        {"LoadTotalCurr",               "float",    4,      0x10,       0x21,       0x01},
        {"SysTotalCurr",                "float",    4,      0x10,       0x21,       0x02},
        {"LoadVolt",                    "float",    4,      0x10,       0x23,       0x11},
        {"SysVolt",                     "float",    4,      0x10,       0x24,       0x01},
        {"MainVolt",                    "float",    4,      0x10,       0x24,       0x09},
        {"ShareVoltDiff",               "float",    4,      0x10,       0x24,       0x0A},
        {"RectLoadRate",                "float",    4,      0x10,       0x25,       0x01},
        {"SysEfficiency",               "float",    4,      0x10,       0x25,       0x02},
        {"LoadRate",                    "float",    4,      0x10,       0x25,       0x03},
        {"SysTotalPower",               "float",    4,      0x10,       0x26,       0x01},
        {"SysTotalEnergy",              "float",    4,      0x10,       0x26,       0x02},
        {"LoadTotalPwoer",				"float",    4,      0x10,       0x26,       0x03},
        {"Sys_A_ShareCurr",             "float",    4,      0x10,       0x3B,       0x01},
        {"Sys_B_ShareCurr",             "float",    4,      0x10,       0x3B,       0x11},
        {"LoadBreaker",                 "float",    4,      0x12,       0xF1,       0x01},
        {"ShareBreaker",                "float",    4,      0x12,       0xF7,       0x09},

        // 以下为原labview中有，但csu代码里没有或模糊的显示数据
        // {"Sys.A.LoadCurr",          "float",    4,      0x10,       0x26,       0x01},
        // {"Sys.B.LoadCurr",          "float",    4,      0x10,       0x26,       0x01},
        // {"Sys.B.LoadPower",         "float",    4,      0x10,       0x23,       0x11},
        // {"Sys.B.LoadRate",          "float",    4,      0x10,       0x23,       0x11},
        // {"Sys.B.RectLoadRate",      "float",    4,      0x10,       0x23,       0x11},
        // {"Bus+.BattCurr",           "float",    4,      0x10,       0x21,       0x01},
        // {"Bus-.BattCurr",           "float",    4,      0x10,       0x23,       0x11},
        // {"Ups+.TotalCurr",          "float",    4,      0x10,       0x23,       0x11},
        // {"Ups-.TotalCurr",          "float",    4,      0x10,       0x23,       0x11},

    };

    const static QList<QByteArray> infoDcInfoPageQuerryCmdList = {
        QByteArray::fromHex("102100"),
        //QByteArray::fromHex("102300"),
        QByteArray::fromHex("102400"),
        QByteArray::fromHex("102500"),
        QByteArray::fromHex("102600"),
        QByteArray::fromHex("103B00"),
        //QByteArray::fromHex("12F100"),
        //QByteArray::fromHex("12F700"),

    
    };

    class infoDcInfoPage : public pageBase
    {
        Q_OBJECT
    public:
        infoDcInfoPage(pageMange *pageManager);
        ~infoDcInfoPage() = default;

        // 基类已经实现了所有轮询功能，只需要重写handlePageDataUpdate来添加特殊处理（如果需要）
        pageDataUpdateResult_t handlePageDataUpdate(const QByteArray &data) override;

    private:
        void initPageQuerryCmdList();
        static constexpr pageAttribute_t _infoDcInfoPageAttribute = {
            .isRefresh =1};
    };
}

#endif // PAGEINFODCINFO_H
