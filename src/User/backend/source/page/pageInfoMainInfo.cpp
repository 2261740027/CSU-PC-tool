#include "page/pageInfoMainInfo.h"
#include "page/pageMang.h"
#include <QDebug>

namespace page
{
    infoMainInfoPage::infoMainInfoPage(pageMange *pageManager)
        : pageBase(infoMainInfoPageFieldList, infoMainInfoPageQuerryCmdList, pageManager, _infoMainInfoPageAttribute)
    {
        initPageQuerryCmdList();
    }

    // 下面的数据在当前页面的category中只需要一条，因此不在infoMainInfoPageQuerryCmdList中用00全部问询，而是单独添加
    void infoMainInfoPage::initPageQuerryCmdList()
    {
        appendQuerryCmd(querryItemData("sysVolt"));
        appendQuerryCmd(querryItemData("ambiTemp"));
        appendQuerryCmd(querryItemData("BattABrk"));
        appendQuerryCmd(querryItemData("BattBBrk"));
        appendQuerryCmd(querryItemData("RTCBattVolt"));
    }

    pageDataUpdateResult_t infoMainInfoPage::handlePageDataUpdate(const QByteArray &data)
    {
        return pageBase::handlePageDataUpdate(data);
    }
}