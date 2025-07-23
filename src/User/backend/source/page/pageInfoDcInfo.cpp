#include "page/pageInfoDcInfo.h"
#include "page/pageMang.h"
#include <QDebug>

namespace page
{
    infoDcInfoPage::infoDcInfoPage(pageMange *pageManager)
        : pageBase(infoDcInfoPageFieldList, infoDcInfoPageQuerryCmdList, pageManager, _infoDcInfoPageAttribute)
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

    pageDataUpdateResult_t infoDcInfoPage::handlePageDataUpdate(const QByteArray &data)
    {
        return pageBase::handlePageDataUpdate(data);
    }

}