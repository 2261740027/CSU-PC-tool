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