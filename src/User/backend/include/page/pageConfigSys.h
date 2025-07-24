#ifndef PAGECONFIGSYS_H
#define PAGECONFIGSYS_H

#include "page/pageBase.h"

namespace page
{
    class pageMange;
    
    static QList<PageField> configSysPageFieldList = {
        /*                              数据类型   数据长度   group      category     number              */
        {"systemMode",                 "uchar",    1,      0x56,       0xF3,       0x02},              // 
        {"loadCurrSrc",                "uchar",    1,      0x56,       0xF3,       0x05},              // 
        {"rectifierModel",             "uchar",    1,      0x56,       0xF3,       0x04},              // 
        {"gfdFunc",                    "uchar",    1,      0x56,       0xE0,       0x02},              // 
        {"sysVoltageMode",             "uchar",    1,      0x56,       0xF3,       0x01},              // 
        {"calStoragePos",              "uchar",    1,      0x56,       0xF3,       0x06},              //校准存储位置
        {"batteryConnectType",         "uchar",    1,      0x56,       0xF3,       0x07},              //电池连接方式
        {"essFunction",                "uchar",    1,      0x56,       0xE2,       0x01},              //存储功能
        {"limitInputPower",            "uchar",    1,      0x56,       0xE2,       0x02},              //限制输入功率
        {"limitBuffCurr",              "uchar",    1,      0x56,       0xE2,       0x03},              //缓冲限流
        {"essInterface",               "uchar",    1,      0x56,       0xE2,       0x04},              //ESS接口
        {"battery",                    "uchar",    1,      0x56,       0xF3,       0x0C},              //电池类型
        {"rectifierVpgmCmd",           "uchar",    1,      0x56,       0xF3,       0x0A},              //
        {"batteryMicroCurrent",        "uchar",    1,      0x56,       0xF3,       0x0B},              //
        {"buzzer",                     "uchar",    1,      0x56,       0xF1,       0x01},              //
        {"sysAShareFunc",              "uchar",    1,      0x56,       0x49,       0x01},              //
        {"sysBShareFunc",              "uchar",    1,      0x56,       0x49,       0x11},              //
        {"acSenseSource",              "uchar",    1,      0x56,       0xE3,       0x01},              //
        {"sysWorkMode",                "uchar",    1,      0x56,       0xF3,       0x0D},              //
        {"rectVoltageIncrease",        "uchar",    1,      0x56,       0xF3,       0x0E},              //
        {"rectStartUpInSequence",      "uchar",    1,      0x56,       0xF3,       0x0F},              //

        //CMD 清除能量
        {"clearEnergy",                "uchar",    1,      0x04,       0xF0,       0x02},              //

        {"acNum",                      "uchar",    1,      0x56,       0xF5,       0x01},              //
        {"ac10kvNum",                  "uchar",    1,      0x56,       0xF5,       0x0C},              //10kv ac num
        {"batteryPackNum",             "uchar",    1,      0x56,       0xF5,       0x06},              //battery pack num
        {"transformerTempNum",         "uchar",    1,      0x56,       0xF5,       0x0B},              //transformer temp num
        {"csuABatteryNum",             "uchar",    1,      0x56,       0xF5,       0x0D},              //csu a battery num
        {"transformerFanNum",          "uchar",    1,      0x56,       0xF5,       0x0A},              //transformer fan num
        {"stateBranchNum",             "uchar",    1,      0x56,       0xF5,       0x08},              //state branch num
        {"extendStateBranchNum",       "uchar",    1,      0x56,       0xF5,       0x07},              //extend state branch num
        {"loadFuseNum",                "uchar",    1,      0x56,       0xF5,       0x09},              //load fuse num
        {"csuADcBranchNum",            "uchar",    1,      0x56,       0x82,       0x01},              //csu a dc branch num
        {"csuBDcBranchNum",            "uchar",    1,      0x56,       0x82,       0x11},              //csu b dc branch num
        {"mixedBoardNum",              "uchar",    1,      0x56,       0xF5,       0x02},              //mixed board num
        {"meterNum",                   "uchar",    1,      0x56,       0xF5,       0x05},              //meter num
        {"acBaseFromRect",             "uchar",    1,      0x56,       0xE3,       0x02},              //ac base from rect
        {"diodeNum",                   "uchar",    1,      0x56,       0xF5,       0x03},              //diode num
        {"csuNum",                     "ushort",   2,      0x50,       0xF2,       0x01},              //
        {"csuARectNum",                "ushort",   2,      0x50,       0x60,       0x01},              //csu a rect num
        {"csuBRectNum",                "ushort",   2,      0x50,       0x60,       0x11},              //csu b rect num
        {"csuCRectNum",                "ushort",   2,      0x50,       0x60,       0x21},              //csu c rect num
        {"fanRotationCycle",           "ushort",   2,      0x50,       0xE5,       0x0B},              //fan rotation cycle
        {"mainVoltage",                "ushort",   2,      0x50,       0xE5,       0x0C,        QVariantMap{{"decimals", 1}} },              //main voltage
        {"mainCurrent",                "ushort",   2,      0x50,       0xE6,       0x01,        QVariantMap{{"decimals", 1}} }     //main current

    };

    const static QList<QByteArray> configSysPageQuerryCmdList = {
        QByteArray::fromHex("506000"),  
        QByteArray::fromHex("56F500"),
        QByteArray::fromHex("50F201"),
        QByteArray::fromHex("563000"),
        QByteArray::fromHex("56F300"),
        QByteArray::fromHex("161001"),
        QByteArray::fromHex("563121"),
        QByteArray::fromHex("503521"),
        QByteArray::fromHex("50E201"),
        QByteArray::fromHex("50E301"),
        QByteArray::fromHex("50E401"),
        QByteArray::fromHex("502021"),
        QByteArray::fromHex("502121"),
        QByteArray::fromHex("56E000"),
        //QByteArray::fromHex("56E200"),
        //QByteArray::fromHex("501B00"),
        QByteArray::fromHex("50EC00"),
        //QByteArray::fromHex("56F100"),
        QByteArray::fromHex("506100"),
        //QByteArray::fromHex("564900"),
        QByteArray::fromHex("50E500"),
        QByteArray::fromHex("568200"),
        QByteArray::fromHex("56E300"),
        QByteArray::fromHex("564A00"),
        QByteArray::fromHex("508900"),
        //QByteArray::fromHex("50D000"),
        //QByteArray::fromHex("50E600"),
    };

    class pageConfigSys : public pageBase
    {
        Q_OBJECT
    public:
        pageConfigSys(pageMange *pageManager);
        ~pageConfigSys() = default;

    private:

        static constexpr pageAttribute_t _configSysPageAttribute = {
            .isRefresh = 1};
    };
}

#endif
