#include "page/mainPage.h"
#include "page/pageMang.h"
#include <QDebug>

namespace page
{
    mainPage::mainPage(pageMange *pageManager)
        : pageBase(mainPageFieldList, mainPageQuerryCmdList,pageManager, _mainPageAttribute)
    {
        // 所有轮询功能都由基类实现，构造函数只需要传递字段列表
    }

    pageDataUpdateResult_t mainPage::handlePageDataUpdate(const QByteArray &data)
    {
        return pageBase::handlePageDataUpdate(data);
    }
}