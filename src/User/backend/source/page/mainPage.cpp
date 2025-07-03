#include "page/mainPage.h"
#include "page/pageMang.h"
#include <QDebug>

namespace page
{
    mainPage::mainPage(pageMange* pageManager) 
        : pageBase(mainPageFieldList, pageManager)
        , _pageManager(pageManager)
    {
        // 初始化定时器
        _queryTimer = new QTimer(this);
        _queryTimer->setSingleShot(true);
        _queryTimer->setInterval(200); // 200ms
        
        connect(_queryTimer, &QTimer::timeout, this, &mainPage::onQueryTimeout);
        
        // 初始化失败计数器
        for (const auto& field : mainPageFieldList) {
            _failureCount[field.name] = 0;
        }
    }

    void mainPage::refreshPageAllData()
    {
        if (_pageReflashState) {
            return; // 已在轮询中，避免重复启动
        }
        
        _pageReflashState = true;
        _currentFieldIndex = 0;
        _failureCount.clear();
        
        // 初始化失败计数器
        for (const auto& field : mainPageFieldList) {
            _failureCount[field.name] = 0;
        }
        
        queryCurrentField();
    }

    void mainPage::handlePageDataUpdate(const QByteArray &data)
    {
        pageBase::handlePageDataUpdate(data);
        
        if (_pageReflashState) {
            // 收到数据，重置当前字段的失败计数
            if (_currentFieldIndex < mainPageFieldList.size()) {
                QString currentFieldName = mainPageFieldList[_currentFieldIndex].name;
                _failureCount[currentFieldName] = 0;
            }
            
            // 停止超时定时器，继续下一个字段
            _queryTimer->stop();
            moveToNextField();
        }
    }

    void mainPage::onQueryTimeout()
    {
        if (!_pageReflashState || _currentFieldIndex >= mainPageFieldList.size()) {
            return;
        }
        
        QString currentFieldName = mainPageFieldList[_currentFieldIndex].name;
        _failureCount[currentFieldName]++;
        
        qDebug() << "Query timeout for field:" << currentFieldName 
                 << "failure count:" << _failureCount[currentFieldName];
        
        if (_failureCount[currentFieldName] >= 3) {
            // 连续3次超时，跳过该字段
            qDebug() << "Skipping field after 3 failures:" << currentFieldName;
            moveToNextField();
        } else {
            // 重试当前字段
            queryCurrentField();
        }
    }

    void mainPage::queryCurrentField()
    {
        if (_currentFieldIndex >= mainPageFieldList.size()) {
            // 所有字段都查询完成
            _pageReflashState = false;
            qDebug() << "All fields queried, cycle complete";
            return;
        }
        
        QString fieldName = mainPageFieldList[_currentFieldIndex].name;
        qDebug() << "Querying field:" << fieldName;
        
        // 通过pageMange发送查询数据
        if (_pageManager) {
            QByteArray queryData = querryItemData(fieldName);
            if (!queryData.isEmpty()) {
                _pageManager->sendRawData(queryData);
            }
        }
        
        // 启动超时定时器
        _queryTimer->start();
    }
    
    void mainPage::moveToNextField()
    {
        _currentFieldIndex++;
        queryCurrentField();
    }
} 