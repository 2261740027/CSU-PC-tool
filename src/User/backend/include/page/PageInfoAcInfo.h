#ifndef PAGEINFOACINFO_H
#define PAGEINFOACINFO_H

#include "pageBase.h"

namespace page
{
    #define AC_BRANCH_NUM 10
    #define AC_NUM 14

    class pageMange;

    static QList<PageField> infoAcInfoPageFieldList = {
        /*                              数据类型   数据长度   group      category     number              */
        {"TotalAcPhase1Current",        "float",    4,      0x10,       0x18,       0x01},              // 总AC相1电流
        {"TotalAcPhase2Current",        "float",    4,      0x10,       0x18,       0x02},              // 总AC相2电流
        {"TotalAcPhase3Current",        "float",    4,      0x10,       0x18,       0x03},              // 总AC相3电流
        {"TotalAcPower",                "float",    4,      0x10,       0x18,       0x04},              // Total Ac power
        {"TotalAcEnergy",               "float",    4,      0x10,       0x18,       0x05},              // 总AC能量
        {"TotalAcPowerFactor",          "float",    4,      0x10,       0x18,       0x06},              // 总功率因数
    };

    const static QList<QByteArray> infoAcInfoPageQuerryCmdList = {

        QByteArray::fromHex("101000"),
        QByteArray::fromHex("101100"),
        QByteArray::fromHex("101200"),
        //QByteArray::fromHex("101300"),
        //QByteArray::fromHex("101400"),
        //QByteArray::fromHex("101500"),
        //QByteArray::fromHex("101600"),
        QByteArray::fromHex("12F000"),
        //QByteArray::fromHex("12F200"),
        QByteArray::fromHex("101800"),
        QByteArray::fromHex("320100"),
        QByteArray::fromHex("320200"),
        QByteArray::fromHex("320300"),
        QByteArray::fromHex("320400")
    };

    class infoAcInfoPage : public pageBase
    {
        Q_OBJECT
    public:
        infoAcInfoPage(pageMange *pageManager);
        ~infoAcInfoPage() = default;

        // 基类已经实现了所有轮询功能，只需要重写handlePageDataUpdate来添加特殊处理（如果需要）
        pageDataUpdateResult_t handlePageDataUpdate(const QByteArray &data) override;

    private:
        void initPageQuerryCmdList();
        static QList<PageField> &initAcInfoPageFieldList();

        static constexpr pageAttribute_t _infoAcInfoPageAttribute = {
            .isRefresh = 1};
    };
}
#endif