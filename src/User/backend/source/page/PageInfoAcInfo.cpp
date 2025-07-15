#include "page/PageInfoAcInfo.h"
#include "page/pageMang.h"
#include <QDebug>

namespace page
{
    infoAcInfoPage::infoAcInfoPage(pageMange *pageManager)
        : pageBase(initAcInfoPageFieldList(), infoAcInfoPageQuerryCmdList,pageManager, _infoAcInfoPageAttribute)
    {
        initPageQuerryCmdList();
    }

    void infoAcInfoPage::initPageQuerryCmdList()
    {
        // 不能插入未定义的值
    }

    pageDataUpdateResult_t infoAcInfoPage::handlePageDataUpdate(const QByteArray &data)
    {
        return pageBase::handlePageDataUpdate(data);
    }

    QList<PageField> &infoAcInfoPage::initAcInfoPageFieldList()
    {
        PageField tempField;

        // init AC infomation
        for(int i = 0; i < AC_NUM; i++)
        {   
            tempField.valueType = "float";
            tempField.length = 4;
            tempField.group = 0x10;
            // AC x phase voltage  name: "AC" + 序号 + "Phase" + 相序 + "Voltage"
            for(int j = 0; j < 3; j++)
            {
                tempField.name = "AC" + QString::number(i + 1) + "Phase" + QString::number(j + 1) + "Voltage";
                tempField.category = 0x10;
                tempField.number = ((i << 4) & 0x00F0) | (j + 1);
                //qDebug() << tempField.name << " " << tempField.group << tempField.category << tempField.number << "i" << i;
                infoAcInfoPageFieldList.append(tempField);
            }

            // AC x phase current  name: "AC" + 序号 + "Phase" + 相序 + "Current"
            for(int j = 0; j < 3; j++)
            {
                tempField.name = "AC" + QString::number(i + 1) + "Phase" + QString::number(j + 1) + "Current";
                tempField.category = 0x11;
                tempField.number = ((i << 4) & 0x00F0) | (j + 1);
                infoAcInfoPageFieldList.append(tempField);
            }
 
            // AC x frequency  name: "AC" + 序号 + "Frequency"
            tempField.name = "AC" + QString::number(i + 1) + "Frequency";
            tempField.category = 0x12;
            tempField.number = ((i << 4) & 0x00F0) | 0x01;
            infoAcInfoPageFieldList.append(tempField);

            // AC x breaker status  name: "AC" + 序号 + "BreakerStatus"
            tempField.name = "AC" + QString::number(i + 1) + "BreakerStatus";
            tempField.valueType = "ushort";
            tempField.length = 2;
            tempField.group = 0x12;
            tempField.category = 0xF0;
            tempField.number = ((i + 1 )& 0x00FF);
        }
        // AC分路数量 
        for(int i = 0; i < AC_BRANCH_NUM; i++)
        {
            tempField.valueType = "float";
            tempField.length = 4;
            tempField.group = 0x32;
            uint8_t dataNumber = i + 1;

            // AC分路电流     name: "AcBranch + 分路序号 + Current"
            tempField.name = "AcBranch" + QString::number(dataNumber) + "Current";
            tempField.category = 0x01;
            tempField.number = dataNumber;
            infoAcInfoPageFieldList.append(tempField);
            // AC分路有功功率     name: "AcBranch + 分路序号 + ActivePower"
            tempField.name = "AcBranch" + QString::number(dataNumber) + "ActivePower";
            tempField.category = 0x02;
            tempField.number = dataNumber;
            infoAcInfoPageFieldList.append(tempField);
            // AC分路电能         name: "AcBranch + 分路序号 + Energy"
            tempField.name = "AcBranch" + QString::number(dataNumber) + "Energy";
            tempField.category = 0x03;
            tempField.number = dataNumber;
            infoAcInfoPageFieldList.append(tempField);
            // AC分路功率因数     name: "AcBranch + 分路序号 + PowerFactor"
            tempField.name = "AcBranch" + QString::number(dataNumber) + "PowerFactor";
            tempField.category = 0x04;
            tempField.number = dataNumber;
            infoAcInfoPageFieldList.append(tempField);
        }

        return infoAcInfoPageFieldList;
    }
}
