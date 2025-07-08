#include "page/pageInfoMainInfo.h"
#include "page/pageMang.h"
#include <QDebug>

namespace page
{
    infoMainInfoPage::infoMainInfoPage(pageMange *pageManager)
        : pageBase(infoMainInfoPageFieldList, infoMainInfoPageQuerryCmdList, pageManager, _infoMainInfoPageAttribute)
    {

    }

    pageDataUpdateResult_t infoMainInfoPage::handlePageDataUpdate(const QByteArray &data)
    {
        return pageBase::handlePageDataUpdate(data);
    }
}