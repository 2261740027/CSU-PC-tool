#ifndef PAGEINFO10KVISOLATOR_H
#define PAGEINFO10KVISOLATOR_H

#include "page/pageBase.h"
#include <QDebug>

namespace page
{
    class pageMange;

    const static QList<PageField> infoIsolatro10KvPageFieldList = {
        /*                              数据类型   数据长度   group      category     number              */
        {"10KvAC1Phase1Voltage",        "float",    4,      0x10,       0x1A,       0x01},              // Uab
        {"10KvAC1Phase2Voltage",        "float",    4,      0x10,       0x1A,       0x02},              // Ubc
        {"10KvAC1Phase3Voltage",        "float",    4,      0x10,       0x1A,       0x03},              // Uca
        {"10KvAC1Phase1Current",        "float",    4,      0x10,       0x1A,       0x04},              // Ia
        {"10KvAC1Phase2Current",        "float",    4,      0x10,       0x1A,       0x05},              // Ib
        {"10KvAC1Phase3Current",        "float",    4,      0x10,       0x1A,       0x06},              // Ic
        {"10KvAcFrequency",             "float",    4,      0x10,       0x1A,       0x07}               // f

    };

    const static QList<QByteArray> infoIsolatro10KvPageQuerryCmdList = {
        QByteArray::fromHex("101A00"),
        QByteArray::fromHex("12F400"),
        QByteArray::fromHex("12F500"),
        QByteArray::fromHex("12F600")
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
