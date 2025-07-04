#include "page/mainPage.h"
#include "page/pageMang.h"
#include <QDebug>

namespace page
{
    mainPage::mainPage(pageMange *pageManager)
        : pageBase(mainPageFieldList, pageManager)
    {
        // 移除了定时器和失败计数器的初始化，这些由pageMang统一管理
        // 现在使用直接调用方式，不需要信号连接
    }

    void mainPage::refreshPageAllData()
    {
        if (_pageReflashState)
        {
            return; // 已在轮询中，避免重复启动
        }

        _pageReflashState = true;
        _currentFieldIndex = 0;

        queryCurrentField();
    }

    QString mainPage::handlePageDataUpdate(const QByteArray &data)
    {
        QString result = pageBase::handlePageDataUpdate(data);

        if (!result.isEmpty())
        {
            qDebug() << "Data processed successfully for current field";
        }

        return result;
    }

    void mainPage::queryCurrentField()
    {
        if (_currentFieldIndex >= mainPageFieldList.size())
        {
            // 所有字段都查询完成
            _pageReflashState = false;
            qDebug() << "All fields queried, cycle complete";
            return;
        }

        QString fieldName = mainPageFieldList[_currentFieldIndex].name;
        qDebug() << "Querying field:" << fieldName;

        // 通过pageMange发送查询数据，超时和重试由pageMang处理
        if (_pageManager)
        {
            QByteArray queryData = querryItemData(fieldName);
            if (!queryData.isEmpty())
            {
                _pageManager->sendRawData(queryData, fieldName);
            }
        }
    }

    void mainPage::moveToNextField()
    {
        _currentFieldIndex++;
        queryCurrentField();
    }

    void mainPage::onFieldProcessed(const QString &fieldName, bool success)
    {
        if (_pageReflashState)
        {
            qDebug() << "Field processed:" << fieldName << "success:" << success;
            // 无论成功还是失败，都继续下一个字段
            moveToNextField();
        }
    }
}