#include "page/pageInfo10kvIsolator.h"
#include "page/pageMang.h"
#include <QDebug>

namespace page
{
    infoIsolatro10KvPage::infoIsolatro10KvPage(pageMange *pageManager)
        : pageBase(infoIsolatro10KvPageFieldList, pageManager, _isolatro10KvInfoPageAttribute)
    {
        // 所有轮询功能都由基类实现，构造函数只需要传递字段列表
    }

    QString infoIsolatro10KvPage::handlePageDataUpdate(const QByteArray &data)
    {
        QString result = pageBase::handlePageDataUpdate(data);

        if (!result.isEmpty())
        {
            qDebug() << "infoMainInfoPage: Data processed successfully for field:" << result;
        }

        return result;
    }
}