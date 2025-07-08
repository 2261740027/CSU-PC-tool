#include "page/pageInfo10kvIsolator.h"
#include "page/pageMang.h"
#include <QDebug>

namespace page
{
    infoIsolatro10KvPage::infoIsolatro10KvPage(pageMange *pageManager)
        : pageBase(infoIsolatro10KvPageFieldList, infoIsolatro10KvPageQuerryCmdList,pageManager, _isolatro10KvInfoPageAttribute)
    {
        initPageQuerryCmdList();
    }

    void infoIsolatro10KvPage::initPageQuerryCmdList()
    {
        // 不能插入未定义的值
    }

    pageDataUpdateResult_t infoIsolatro10KvPage::handlePageDataUpdate(const QByteArray &data)
    {
        return pageBase::handlePageDataUpdate(data);
    }
}
