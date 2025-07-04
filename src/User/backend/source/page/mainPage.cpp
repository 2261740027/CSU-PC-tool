#include "page/mainPage.h"
#include "page/pageMang.h"
#include <QDebug>

namespace page
{
    mainPage::mainPage(pageMange *pageManager)
        : pageBase(mainPageFieldList, pageManager)
    {
        // 所有轮询功能都由基类实现，构造函数只需要传递字段列表
    }

    QString mainPage::handlePageDataUpdate(const QByteArray &data)
    {
        QString result = pageBase::handlePageDataUpdate(data);

        // 添加mainPage特有的数据处理逻辑
        if (!result.isEmpty())
        {
            qDebug() << "MainPage: Data processed successfully for field:" << result;
        }

        return result;
    }
}