#include "page/pageMang.h"
#include "page/mainPage.h"
#include "page/settingPage.h"
#include <QDebug>

namespace page
{
    pageMange::pageMange()
    {
        static mainPage page1Instance(this);
        registerPage("main", &page1Instance);

        static settingPage page2Instance(this);
        registerPage("setting", &page2Instance);

        // 页面定时刷新
        _refreshTimer = new QTimer(this);
        connect(_refreshTimer, &QTimer::timeout, this, &pageMange::onRefreshTimer);

        // 发送队列定时器
        _sendQueueTimer = new QTimer(this);
        _sendQueueTimer->setSingleShot(true); // 设置为单次触发
        connect(_sendQueueTimer, &QTimer::timeout, this, &pageMange::onSendQueueTimeout);
    }

    void pageMange::sendRawData(const QByteArray &data, const QString &fieldName)
    {
        if (!data.isEmpty())
        {
            // 将查询请求加入队列
            enqueueSendRequest(data, SendRequestType::Query, fieldName);
        }
    }

    void pageMange::enqueueSendRequest(const QByteArray &data, SendRequestType type, const QString &fieldName)
    {
        // 如果是手动设置请求，优先级更高，插入到队列前面
        if (type == SendRequestType::Setting)
        {
            _sendQueue.prepend(SendRequest(data, type, fieldName));
            qDebug() << "Enqueued high-priority setting request for field:" << fieldName;
        }
        else
        {
            _sendQueue.enqueue(SendRequest(data, type, fieldName));
            qDebug() << "Enqueued query request for field:" << fieldName;
        }

        // 尝试立即处理队列
        processSendQueue();
    }

    void pageMange::processSendQueue()
    {
        if (_sendQueue.isEmpty() || _isSending)
        {
            return;
        }

        _currentRequest = _sendQueue.dequeue();
        _isSending = true;

        // 如果是新字段，重置重试计数
        if (!_retryCount.contains(_currentRequest.fieldName))
        {
            _retryCount[_currentRequest.fieldName] = 0;
        }

        qDebug() << "Processing send request:" << _currentRequest.fieldName
                 << "Type:" << (_currentRequest.type == SendRequestType::Query ? "Query" : "Setting")
                 << "Retry count:" << _retryCount[_currentRequest.fieldName];

        // 发送数据
        emit toSerialSend(_currentRequest.data);

        // 启动超时定时器
        _sendQueueTimer->start(SEND_TIMEOUT_MS);
    }

    void pageMange::onSendQueueTimeout()
    {
        if (_isSending)
        {
            QString fieldName = _currentRequest.fieldName;
            _retryCount[fieldName]++;

            qDebug() << "Send timeout for field:" << fieldName
                     << "retry count:" << _retryCount[fieldName];

            if (_retryCount[fieldName] < MAX_RETRY_COUNT)
            {
                // 重试当前请求
                qDebug() << "Retrying field:" << fieldName;
                emit toSerialSend(_currentRequest.data);
                _sendQueueTimer->start(SEND_TIMEOUT_MS);
                return;
            }
            else
            {
                // 超过最大重试次数，跳过该字段
                qDebug() << "Max retries reached for field:" << fieldName << ", skipping";
                _retryCount[fieldName] = 0; // 重置计数

                // 直接调用页面的onFieldProcessed方法
                _pageHash[_currentPage]->onFieldProcessed(fieldName, false);
            }
        }

        // 处理完成或失败，继续下一个请求
        _isSending = false;
        processSendQueue();
    }

    bool pageMange::canSendNow()
    {
        return !_isSending && _sendQueue.isEmpty();
    }

    void pageMange::registerPage(const QString &pageName, pageBase *controller)
    {
        _pageHash.insert(pageName, controller);
    }

    QString pageMange::currentPage() const
    {
        return _currentPage;
    }

    void pageMange::handleDataUpdate(QByteArray data)
    {
        qDebug() << "recvData " + _currentPage;
        QString recvDataName = _pageHash[_currentPage]->handlePageDataUpdate(data);


        
        // 只有在收到有效响应数据时，才重置重试计数并释放发送锁
        if ( (recvDataName == _currentRequest.fieldName) && _isSending)
        {
            // 成功收到有效响应，重置该字段的重试计数
            _retryCount[_currentRequest.fieldName] = 0;
            QString processedFieldName = _currentRequest.fieldName;

            _isSending = false;
            _sendQueueTimer->stop(); // 停止超时定时器
            qDebug() << "Received valid response for field:" << processedFieldName << ", releasing send lock";

            // 处理下一个请求
            processSendQueue();

            // 直接调用页面的onFieldProcessed方法
            _pageHash[_currentPage]->onFieldProcessed(processedFieldName, true);
        }

        emit pageDataChanged();
    }

    QVariantMap pageMange::pageData()
    {

        QMap<QString, pageMapField> pageTable;

        pageTable = _pageHash[_currentPage]->getPageTable();

        QList<QString> keyList = pageTable.keys(); // 存放的就是QMap的key值
        for (int i = 0; i < keyList.size(); i++)
        {
            _currPageData[keyList[i]] = pageTable[keyList[i]].value;
        }

        return _currPageData;
    }

    void pageMange::setItemData(QString name, QVariant value)
    {
        QByteArray sendData;

        sendData = _pageHash[_currentPage]->setItemData(name, value);

        if (!sendData.isEmpty())
        {
            enqueueSendRequest(sendData, SendRequestType::Setting, name);
            qDebug() << "Manual setting request for field:" << name << "with value:" << value;
        }
    }

    void pageMange::notifyPageSwitch(const QString newPageName)
    {
        // 1. 停止当前页面的轮询状态
        if (_pageHash.contains(_currentPage))
        {
            _pageHash[_currentPage]->resetPollingState();
            qDebug() << "Reset polling state for page:" << _currentPage;
        }

        // 2. 停止自动刷新定时器
        stopAutoRefresh();
        qDebug() << "Stopped auto refresh timer for page switch";

        // 3. 清空发送队列，避免发送过时的请求
        _sendQueue.clear();
        _isSending = false;
        _sendQueueTimer->stop();
        qDebug() << "Page switch: cleared send queue and reset sending state";

        // 4. 切换到新页面
        _currentPage = newPageName;
        qDebug() << "Switched to page:" + newPageName;
        _currPageData.clear();

        // 5. 重置重试计数器（避免旧页面的重试计数影响新页面）
        _retryCount.clear();
        qDebug() << "Cleared retry counters for new page";

        // 6. 重新启动自动刷新（如果启用）
        if (_autoRefreshEnabled)
        {
            startAutoRefresh();
            qDebug() << "Restarted auto refresh timer for new page";
        }
    }

    void pageMange::setAutoRefreshEnabled(bool enabled)
    {
        if (_autoRefreshEnabled != enabled)
        {
            _autoRefreshEnabled = enabled;

            if (enabled)
            {
                startAutoRefresh();
            }
            else
            {
                stopAutoRefresh();
            }
        }
    }

    void pageMange::setRefreshInterval(int interval)
    {
        if (_refreshInterval != interval && interval > 0)
        {
            _refreshInterval = interval;

            // 页面跳转时，开启自动刷新定时器
            if (_refreshTimer && _refreshTimer->isActive())
            {
                _refreshTimer->stop();
                _refreshTimer->start(_refreshInterval);
                qDebug() << "Refresh interval updated to:" << _refreshInterval << "ms";
            }
        }
    }

    void pageMange::startAutoRefresh()
    {
        if (_autoRefreshEnabled)
        {
            _refreshTimer->start(_refreshInterval);
        }
    }

    void pageMange::stopAutoRefresh()
    {
        if (_refreshTimer && _refreshTimer->isActive())
        {
            _refreshTimer->stop();
        }
    }
    void pageMange::onRefreshTimer()
    {
        qDebug() << "Auto refresh triggered for page:" << _currentPage;
        _pageHash[_currentPage]->refreshPageAllData();
    }
}
