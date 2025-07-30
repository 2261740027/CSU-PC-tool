#include "page/pageInfoDcInfo.h"
#include "page/pageMang.h"
#include <QDebug>

namespace page
{
    infoDcInfoPage::infoDcInfoPage(pageMange *pageManager)
        : pageBase(initinfoDcInfoPageFieldList(), infoDcInfoPageQuerryCmdList, pageManager, _infoDcInfoPageAttribute)
    {
        initPageQuerryCmdList();
    }

    // 下面的数据在当前页面的category中只需要一条，因此不在infoDcInfoPageQuerryCmdList中用00全部问询，而是单独添加
    void infoDcInfoPage::initPageQuerryCmdList()
    {
        appendQuerryCmd(querryItemData("LoadVolt"));
        appendQuerryCmd(querryItemData("LoadBreaker"));
        appendQuerryCmd(querryItemData("ShareBreaker"));

    }

    QList<PageField> &infoDcInfoPage::initinfoDcInfoPageFieldList()
    {
        PageField tempField;

        for(int i = 0; i < DC_BRANCH_NUM; i++)
        {
            tempField.valueType = "float";
            tempField.length = 4;
            tempField.group = 0x32;

            tempField.name = "DcBranch" + QString::number(i + 1) + "LoadCurr";
            tempField.category = 0x11;
            tempField.number = ((i + 1) & 0x00FF);
            infoDcInfoPageFieldList.append(tempField);

            tempField.name = "DcBranch" + QString::number(i + 1) + "ActivePower";
            tempField.category = 0x12;
            tempField.number = ((i + 1) & 0x00FF);
            infoDcInfoPageFieldList.append(tempField);

            tempField.name = "DcBranch" + QString::number(i + 1) + "Energy";
            tempField.category = 0x13;
            tempField.number = ((i + 1) & 0x00FF);
            infoDcInfoPageFieldList.append(tempField);

        }
        
        return infoDcInfoPageFieldList;
    }

    pageDataUpdateResult_t infoDcInfoPage::handlePageDataUpdate(const QByteArray &data)
    {
        return pageBase::handlePageDataUpdate(data);
    }

}