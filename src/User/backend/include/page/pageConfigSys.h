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

    };

    const static QList<QByteArray> configSysPageQuerryCmdList = {


    };

    class pageConfigSys : public pageBase
    {
        Q_OBJECT
    public:
        pageConfigSys(pageMange *pageManager);
        ~pageConfigSys() = default;

    private:

        static constexpr pageAttribute_t _configSysPageAttribute = {
            .isRefresh = 0};
    };
}

#endif
