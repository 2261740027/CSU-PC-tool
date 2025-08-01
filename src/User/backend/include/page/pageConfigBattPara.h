#ifndef PAGECONFIGBATTPARA_H
#define PAGECONFIGBATTPARA_H

#include "pageBase.h"
#include <QJsonObject>    
#include <QJsonArray>

namespace page {

    inline QVariantMap createCalendarConfig() {
        QJsonArray fields = {
            QJsonObject{ {"name", "Y"}, {"type", "uchar"}, {"size", 1}},
            QJsonObject{ {"name", "M"}, {"type", "uchar"}, {"size", 1}},
            QJsonObject{ {"name", "D"}, {"type", "uchar"}, {"size", 1}},
            QJsonObject{ {"name", "H"}, {"type", "uchar"}, {"size", 1}},
            QJsonObject{ {"name", "m"}, {"type", "uchar"}, {"size", 1}},
            QJsonObject{ {"name", "S"}, {"type", "uchar"}, {"size", 1}}
        };

        return {
            {"fields", fields}
        };
    }

    static QList<PageField> configBattParaPageFieldList = {
        {"battInstallTime",                 "calendar",         6, 0x16, 0x30, 0x01, createCalendarConfig()},
    
    };

    static QList<PageField> appendConfigBattParaWithRang = {
        {"batteryTotalCapacity",            "short",            2, 0x50, 0x30, 0x01},
        {"systemFloatVoltage",              "short",            2, 0x50, 0x20, 0x01, {{"decimals", 1}}},
        {"systemEqualizeVoltage",           "short",            2, 0x50, 0x21, 0x01, {{"decimals", 1}}},
        {"equBoostCap",                     "short",            2, 0x50, 0x46, 0x01},
        {"boostChargeDepthVoltage",         "short",            2, 0x50, 0x45, 0x01, {{"decimals", 1}}},
        {"boostChargeChargeCurrent",        "short",            2, 0x50, 0x47, 0x01, {{"decimals", 2}}},
        {"equalizEperiod",                  "short",            2, 0x50, 0x44, 0x01},
        {"equalizeMaxTime",                 "short",            2, 0x50, 0x40, 0x01},
        {"equalizeAdditionalTime",          "short",            2, 0x50, 0x41, 0x01},
        {"equalizeTerminalCurrent",         "short",            2, 0x50, 0x42, 0x01, {{"decimals", 2}}},
        {"batteryFloatChargeCurr",          "short",            2, 0x50, 0x34, 0x02, {{"decimals", 2}}},
        {"batteryEqualizeChargeCurr",       "short",            2, 0x50, 0x34, 0x03, {{"decimals", 2}}},
        {"batteryDpVoltChargeCurr",         "short",            2, 0x50, 0x34, 0x01, {{"decimals", 2}}},
        {"batteryManualChargeCurrLimit",    "short",            2, 0x50, 0x35, 0x01, {{"decimals", 1}}},
        {"batteryOverCurrent",              "short",            2, 0x50, 0x33, 0x01, {{"decimals", 2}}},
        {"batteryBreakerTripVoltage",       "short",            2, 0x50, 0x32, 0x01, {{"decimals", 1}}},
        {"batteryBreakerTripCurr",          "short",            2, 0x50, 0x39, 0x01, {{"decimals", 2}}},

        {"batteryBaseTemperature",          "short",            2, 0x50, 0x3B, 0x01, {{"decimals", 1}}},
        {"batteryUpperLimit",               "short",            2, 0x50, 0x3C, 0x01, {{"decimals", 1}}},
        {"batteryLowerLimit",               "short",            2, 0x50, 0x3D, 0x01, {{"decimals", 1}}},
        {"batteryTemperatureComp",          "short",            2, 0x50, 0x3A, 0x01, {{"decimals", 1}}},
        {"BatteryTemperatureCompEq",        "short",            2, 0x50, 0x3A, 0x02, {{"decimals", 1}}},

        {"batteryTestCurrent",              "short",            2, 0x50, 0x53, 0x01, {{"decimals", 1}}},
        {"batteryTestEndVolt",              "short",            2, 0x50, 0x54, 0x01, {{"decimals", 1}}},
        {"batteryTestEndCap",               "short",            2, 0x50, 0x52, 0x01},
        {"batteryTestMaxTime",              "short",            2, 0x50, 0x50, 0x01},
        {"batteryTestAdditionalTime",       "short",            2, 0x50, 0x55, 0x01},

    };

    static QList<PageField> appendConfigBattParaOption = {
        {"systemClmode",                    "uchar",            1, 0x56, 0x31, 0x01},
        {"equalizeFunction",                "uchar",            1, 0x56, 0x40, 0x01},
        {"boostDepthVoltCharge",            "uchar",            1, 0x56, 0x45, 0x01},
        {"boostDischargeCapCharge",         "uchar",            1, 0x56, 0x46, 0x01},
        {"boostChargeCurrCharge",           "uchar",            1, 0x56, 0x47, 0x01},
        {"boostCharge",                     "uchar",            1, 0x56, 0x48, 0x01},

        {"tempCompFunc",                    "uchar",            1, 0x56, 0x35, 0x01},
        {"equCompFunc",                     "uchar",            1, 0x56, 0x36, 0x01},
    };

    const static QList<QByteArray> configBattParaPageQuerryCmdList = {
        // QByteArray::fromHex("503400"),  
        // QByteArray::fromHex("503500"),
        // QByteArray::fromHex("503900"),
        // QByteArray::fromHex("504000"),  
        // QByteArray::fromHex("504100"),
        // QByteArray::fromHex("504200"),
        // QByteArray::fromHex("504400"),  
        // QByteArray::fromHex("504500"),
        // QByteArray::fromHex("504600"),
        // QByteArray::fromHex("504700"),  
        // QByteArray::fromHex("563100"),
        // QByteArray::fromHex("564000"),
        // QByteArray::fromHex("564500"),  
        // QByteArray::fromHex("564600"),
        // QByteArray::fromHex("564700"),
        // QByteArray::fromHex("163000"),  
        // QByteArray::fromHex("163100"),
        // QByteArray::fromHex("564800"),
        // QByteArray::fromHex("502000"),  
        // QByteArray::fromHex("502100"),
        // QByteArray::fromHex("503000"),
        // QByteArray::fromHex("503200"),  
        // QByteArray::fromHex("503300"),
    };

    class pageConfigBattPara : public pageBase
    {
        Q_OBJECT

    public:
        pageConfigBattPara(pageMange *pageManager);
        ~pageConfigBattPara() = default;
    
    private:

        void appendBattParaWithRange(QList<PageField> &pageFieldList);
        void appendBattParaOption(QList<PageField> &pageFieldList);

        static constexpr pageAttribute_t _configBattParaPageAttribute = {
            .isRefresh = 1,
            .csuIndex = 1,
        };
    };
};

#endif
