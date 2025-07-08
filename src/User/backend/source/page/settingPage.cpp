#include "page/settingPage.h"
#include "page/pageMang.h"
#include <QDebug>

namespace page
{
    settingPage::settingPage(pageMange *pageManager)
        : pageBase(settingPageFieldList, settingPageQuerryCmdList, pageManager, _settingPageAttribute)
    {
        // 所有轮询功能都由基类实现，构造函数只需要传递字段列表
    }

    pageDataUpdateResult_t settingPage::handlePageDataUpdate(const QByteArray &data)
    {
        return pageBase::handlePageDataUpdate(data);
    }
} 