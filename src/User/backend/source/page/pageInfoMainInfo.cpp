#include "page/pageInfoMainInfo.h"
#include "page/pageMang.h"
#include <QDebug>

namespace page
{
    infoMainInfoPage::infoMainInfoPage(pageMange *pageManager)
        : pageBase(infoMainInfoPageFieldList, pageManager, _infoMainInfoPageAttribute)
    {
        // 所有轮询功能都由基类实现，构造函数只需要传递字段列表
    }

    QString infoMainInfoPage::handlePageDataUpdate(const QByteArray &data)
    {
        QString result = pageBase::handlePageDataUpdate(data);

        if (!result.isEmpty())
        {
            qDebug() << "infoMainInfoPage: Data processed successfully for field:" << result;
        }

        return result;
    }
}