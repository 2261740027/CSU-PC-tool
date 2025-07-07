#include "page/settingPage.h"
#include "page/pageMang.h"
#include <QDebug>

namespace page
{
    settingPage::settingPage(pageMange *pageManager)
        : pageBase(settingPageFieldList, pageManager, _settingPageAttribute)
    {
        // 所有轮询功能都由基类实现，构造函数只需要传递字段列表
    }

    QString settingPage::handlePageDataUpdate(const QByteArray &data)
    {
        QString result = pageBase::handlePageDataUpdate(data);

        // 添加settingPage特有的数据处理逻辑
        if (!result.isEmpty())
        {
            qDebug() << "SettingPage: Data processed successfully for field:" << result;
        }

        return result;
    }
} 