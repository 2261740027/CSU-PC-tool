#ifndef PAGECONFIGALARMPARA_H
#define PAGECONFIGALARMPARA_H

#include "pageBase.h"

namespace page {

    static QList<PageField> configAlarmParaPageFieldList = {
    
    };

    static QList<PageField> configAlarmParaPageFieldWithRangeList = {
        {"acVoltageHigh",               "short",    2,      0x50,       0x10,       0x01,               {{"decimals", 1}}},              
        {"acUnbalance",                 "short",    2,      0x50,       0x12,       0x01},                                               
        {"acFreqHigh",                  "short",    2,      0x50,       0x14,       0x01,               {{"decimals", 1}}},                                               
        {"acVoltageLow",                "short",    2,      0x50,       0x11,       0x01,               {{"decimals", 1}}},                                               
        {"acOverCurrent",               "short",    2,      0x50,       0x13,       0x01,               {{"decimals", 1}}},                                               
        {"acFreqLow",                   "short",    2,      0x50,       0x15,       0x01,               {{"decimals", 1}}},                                               
        {"acFailure",                   "short",    2,      0x50,       0x16,       0x01,               {{"decimals", 1}}},                                               
        {"acRecover",                   "short",    2,      0x50,       0x17,       0x01,               {{"decimals", 1}}},   

        {"systemADCVoltageHigh",        "short",    2,      0x50,       0x22,       0x01,               {{"decimals", 1}}},   
        {"systemADCVoltagelow",         "short",    2,      0x50,       0x23,       0x01,               {{"decimals", 1}}},   
        {"batteryAtemperaturehigh",     "short",    2,      0x50,       0x31,       0x01,               {{"decimals", 1}}},   
        {"systemBDCVoltageHigh",        "short",    2,      0x50,       0x22,       0x11,               {{"decimals", 1}}},   
        {"systemBDCVoltagelow",         "short",    2,      0x50,       0x23,       0x11,               {{"decimals", 1}}},   
        {"batteryBtemperaturehigh",     "short",    2,      0x50,       0xE0,       0x01,               {{"decimals", 1}}},  
        {"systemCDCVoltageHigh",        "short",    2,      0x50,       0x22,       0x21,               {{"decimals", 1}}},   
        {"systemCDCVoltagelow",         "short",    2,      0x50,       0x23,       0x21,               {{"decimals", 1}}},   
        {"batteryCtemperaturehigh",     "short",    2,      0x50,       0xE1,       0x01,               {{"decimals", 1}}},   

        {"batteryUnbalanceDischarge",   "short",    2,      0x50,       0x27,       0x01,               {{"decimals", 2}}},
        {"gfdPositiveImpedanceLow",     "short",    2,      0x50,       0xEA,       0x01,               {{"decimals", 1}}},
        {"sysCurrShareDiff",            "short",    2,      0x50,       0xE2,       0x02,               {{"decimals", 1}}},
        {"sysLoadOverCurr",             "short",    2,      0x50,       0x26,       0x01},
        {"gfdNegativeImpedanceLow",     "short",    2,      0x50,       0xEB,       0x01,               {{"decimals", 1}}},
        {"battLoS",                     "short",    2,      0x50,       0x28,       0x01},
        {"mainDcOV",                    "short",    2,      0x50,       0xE5,       0x0D,               {{"decimals", 1}}},
        {"mainDCLV",                    "short",    2,      0x50,       0xE5,       0x0E,               {{"decimals", 1}}},
        {"batteryCellOV",               "short",    2,      0x50,       0xE6,       0x02,               {{"decimals", 10}}},

        {"ac10kvVolH",                  "short",    2,      0x50,       0x1A,       0x01,               {{"decimals", 1}}},
        {"ac10kvVolUnbalance",          "short",    2,      0x50,       0x1A,       0x03},
        {"ac10kvFreqHigh",              "short",    2,      0x50,       0x1A,       0x05,               {{"decimals", 1}}},
        {"ac10kvVolL",                  "short",    2,      0x50,       0x1A,       0x02,               {{"decimals", 1}}},
        {"ac10kvOverCurrent",           "short",    2,      0x50,       0x1A,       0x04,               {{"decimals", 1}}},
        {"ac10kvFreqLow",               "short",    2,      0x50,       0x1A,       0x06,               {{"decimals", 1}}},
        {"ac10kvFailure",               "short",    2,      0x50,       0x1A,       0x07,               {{"decimals", 1}}},
        {"ac10kvRecover",               "short",    2,      0x50,       0x1A,       0x08,               {{"decimals", 1}}},
        {"transformerTemphigh",         "short",    2,      0x50,       0xE5,       0x01,               {{"decimals", 1}}},
        {"transOTPTH",                  "short",    2,      0x50,       0xE5,       0x02,               {{"decimals", 1}}},
    };


    const static QList<QByteArray> configAlarmParaPageQuerryCmdList = {
        QByteArray::fromHex("501001"),  
        QByteArray::fromHex("501101"),
        QByteArray::fromHex("501201"),
        QByteArray::fromHex("501301"),  
        QByteArray::fromHex("501401"),
        QByteArray::fromHex("501501"),
        QByteArray::fromHex("501601"),  
        QByteArray::fromHex("501701"),
        QByteArray::fromHex("502200"),
        QByteArray::fromHex("502300"),  
        QByteArray::fromHex("502600"),
        QByteArray::fromHex("502700"),
        QByteArray::fromHex("503100"),  
        QByteArray::fromHex("503300"),
        QByteArray::fromHex("50E000"),
        QByteArray::fromHex("50E100"),  
        QByteArray::fromHex("50EA00"),
        QByteArray::fromHex("50EB00"),
        QByteArray::fromHex("501A00"),  
        QByteArray::fromHex("50E500"),
        QByteArray::fromHex("50E200"),
        QByteArray::fromHex("502800"),  
        QByteArray::fromHex("50E600"),
    };


    class pageConfigAlarmPara : public pageBase
    {
        Q_OBJECT
    public:
        pageConfigAlarmPara(pageMange *pageManager);
        ~pageConfigAlarmPara() = default;


    private:
        void appendAlarmParaPageFieldList(QList<PageField> &pageFieldList);

        static constexpr pageAttribute_t _configAlarmParaPageAttribute = {
            .isRefresh = 1,
            .csuIndex = 0,
        };
    };
};

#endif
