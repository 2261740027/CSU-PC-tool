#ifndef PAGEINFO10KVISOLATOR_H
#define PAGEINFO10KVISOLATOR_H

#include "page/pageBase.h"
#include <QDebug>

namespace page
{
    class pageMange;

    const static QList<PageField> infoIsolatro10KvPageFieldList = {
        /*                              数据类型   数据长度   group      category     number              */
        {"AC1Phase1Voltage10Kv",        "float",    4,      0x10,       0x1A,       0x01},              // Uab
        {"AC1Phase2Voltage10Kv",        "float",    4,      0x10,       0x1A,       0x02},              // Ubc
        {"AC1Phase3Voltage10Kv",        "float",    4,      0x10,       0x1A,       0x03},              // Uca
        {"AC1Phase1Current10Kv",        "float",    4,      0x10,       0x1A,       0x04},              // Ia
        {"AC1Phase2Current10Kv",        "float",    4,      0x10,       0x1A,       0x05},              // Ib
        {"AC1Phase3Current10Kv",        "float",    4,      0x10,       0x1A,       0x06},              // Ic
        {"AcFrequency10Kv",             "float",    4,      0x10,       0x1A,       0x07},              // f
        {"ACBreaker10Kv",               "ushort",   2,      0x12,       0xF6,       0x03},              // 负荷开关状态
        {"TransformerPriTempA",         "float",    4,      0x10,       0xF4,       0x01},              // 变压器A相温度
        {"TransformerPriTempB",         "float",    4,      0x10,       0xF4,       0x02},              // 变压器B相温度
        {"TransformerPriTempC",         "float",    4,      0x10,       0xF4,       0x03},              // 变压器C相温度
        {"TransformerSecTempA",         "float",    4,      0x10,       0xF4,       0x11},              // 变压器A相温度
        {"TransformerSecTempB",         "float",    4,      0x10,       0xF4,       0x12},              // 变压器B相温度
        {"TransformerSecTempC",         "float",    4,      0x10,       0xF4,       0x13},              // 变压器C相温度
        {"Fan1Temp",                    "float",    4,      0x10,       0xF5,       0x01},              // 风扇1温度
        {"Fan2Temp",                    "float",    4,      0x10,       0xF5,       0x11},              // 风扇2温度
        {"Fan3Temp",                    "float",    4,      0x10,       0xF5,       0x12},              // 风扇3温度
        {"Fan4Temp",                    "float",    4,      0x10,       0xF5,       0x13},              // 风扇4温度
        {"Fan1Speed",                   "float",    4,      0x10,       0xF5,       0x21},              // 风扇1速度     
        {"TransformerPriTempStatus",    "ushort",   2,      0x12,       0xF4,       0x01},              // 变压器原边温度模组状态
        {"TransformerSecTempStatus",    "ushort",   2,      0x12,       0xF4,       0x11},              // 变压器副边温度模组状态
        {"Fan1Status",                  "ushort",   2,      0x12,       0xF5,       0x01},              // 风扇1状态
        {"Fan1Speed",                   "ushort",   2,      0x12,       0xF5,       0x02},              // 风扇1转速
        {"Fan1BreakerStatus",           "ushort",   2,      0x12,       0xF5,       0x03},              // 风扇1空开状态
        {"Fan1ContactorStatus",         "ushort",   2,      0x12,       0xF5,       0x04},              // 风扇1接触器状态
        {"Fan2Status",                  "ushort",   2,      0x12,       0xF5,       0x11},              // 风扇2状态
        {"Fan2Speed",                   "ushort",   2,      0x12,       0xF5,       0x12},              // 风扇2转速
        {"Fan2BreakerStatus",           "ushort",   2,      0x12,       0xF5,       0x13},              // 风扇2空开状态
        {"Fan2ContactorStatus",         "ushort",   2,      0x12,       0xF5,       0x14},              // 风扇2接触器状态
        {"Fan3Status",                  "ushort",   2,      0x12,       0xF5,       0x21},              // 风扇3状态
        {"Fan3Speed",                   "ushort",   2,      0x12,       0xF5,       0x22},              // 风扇3转速
        {"Fan3BreakerStatus",           "ushort",   2,      0x12,       0xF5,       0x23},              // 风扇3空开状态
        {"Fan3ContactorStatus",         "ushort",   2,      0x12,       0xF5,       0x24},              // 风扇3接触器状态
        {"Fan4Status",                  "ushort",   2,      0x12,       0xF5,       0x31},              // 风扇4状态
        {"Fan4Speed",                   "ushort",   2,      0x12,       0xF5,       0x32},              // 风扇4转速
        {"Fan4BreakerStatus",           "ushort",   2,      0x12,       0xF5,       0x33},              // 风扇4空开状态
        {"Fan4ContactorStatus",         "ushort",   2,      0x12,       0xF5,       0x34},              // 风扇4接触器状态
        {"EntryCabinetDoor",            "ushort",   2,      0x12,       0xF6,       0x01},              // 进线门开关
        {"PhaseShiftingDoor”",          "ushort",   2,      0x12,       0xF6,       0x02},              // 换相器柜门


    };

    const static QList<QByteArray> infoIsolatro10KvPageQuerryCmdList = {
        QByteArray::fromHex("101A00"),
        QByteArray::fromHex("10F400"),
        QByteArray::fromHex("10F500"),
        QByteArray::fromHex("12F400"),
        QByteArray::fromHex("12F500"),
        QByteArray::fromHex("12F600"),
        QByteArray::fromHex("045000"),
    };
    class infoIsolatro10KvPage : public pageBase
    {
        Q_OBJECT
    public:
        infoIsolatro10KvPage(pageMange *pageManager);
        ~infoIsolatro10KvPage() = default;

        // 基类已经实现了所有轮询功能，只需要重写handlePageDataUpdate来添加特殊处理（如果需要）
        pageDataUpdateResult_t handlePageDataUpdate(const QByteArray &data) override;

    private:
        void initPageQuerryCmdList();
        static constexpr pageAttribute_t _isolatro10KvInfoPageAttribute = {
            .isRefresh = 1};
    };
}

#endif
