#include "page/pageMang.h"
#include "page/mainPage.h"
#include "page/settingPage.h"
#include "page/pageInfoMainInfo.h"
#include "page/pageInfo10kvIsolator.h"
#include "page/pageInfoDcInfo.h"
#include "page/PageInfoAcInfo.h"
#include "page/pageInfoAlarmLog.h"
#include "page/pageConfigSys.h"
#include <QDebug>

namespace page
{
    pageMange::pageMange()
    {
        static mainPage page1Instance(this);
        registerPage("main", &page1Instance);

        static settingPage page2Instance(this);
        registerPage("setting", &page2Instance);

        static infoMainInfoPage page3Instance(this);
        registerPage("infoMainInfo", &page3Instance);

        static infoIsolatro10KvPage page4Instance(this);
        registerPage("info10KvIsolator", &page4Instance);

        static infoAcInfoPage page5Instance(this);
        registerPage("infoAcInfo", &page5Instance);

        static infoDcInfoPage dcInfoInstance(this);
        registerPage("infoDcInfo", &dcInfoInstance);

        static infoAlarmLogPage page6Instance(this);
        registerPage("alarmLog", &page6Instance);

        static pageConfigSys page7Instance(this);
        registerPage("configSys", &page7Instance);

        // 页面定时刷新
        _refreshTimer = new QTimer(this);
        connect(_refreshTimer, &QTimer::timeout, this, &pageMange::onRefreshTimer);

        // 发送队列定时器
        _sendQueueTimer = new QTimer(this);
        _sendQueueTimer->setSingleShot(true); // 设置为单次触发
        connect(_sendQueueTimer, &QTimer::timeout, this, &pageMange::onSendQueueTimeout);
    }

    void pageMange::sendRawData(const QByteArray &data, SendRequestType type)
    {
        if (!data.isEmpty())
        {
            // 将查询请求加入队列
            enqueueSendRequest(data, type);
        }
    }

    void pageMange::enqueueSendRequest(const QByteArray &data, SendRequestType type)
    {
        // 如果是手动设置请求，优先级更高，插入到队列前面
        if (type == SendRequestType::Setting)
        {
            _sendQueue.prepend(SendRequest(data, type));
            //qDebug() << "Enqueued high-priority setting request for field:" << fieldName;
        }
        else
        {
            _sendQueue.enqueue(SendRequest(data, type));
            //qDebug() << "Enqueued query request for field:" << fieldName;
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
        if (!_retryCount.contains(SLIPDATAINDEX(_currentRequest.data[0], _currentRequest.data[1], _currentRequest.data[2])))
        {
            _retryCount[SLIPDATAINDEX(_currentRequest.data[0], _currentRequest.data[1], _currentRequest.data[2])] = 0;
        }

        // 发送数据
        emit toSerialSend(_currentRequest.data);

        // 启动超时定时器
        _sendQueueTimer->start(SEND_TIMEOUT_MS);
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
        pageDataUpdateResult_t recvInfo = _pageHash[_currentPage]->handlePageDataUpdate(data);

        // 未主动发送数据不进行接收数据
        if(_currentRequest.data.size() <= 0)
        {
            return;
        }

        unsigned int index = SLIPDATAINDEX(_currentRequest.data[0], _currentRequest.data[1], _currentRequest.data[2]);
        bool isResponse = false;

        if(SendRequestType::Query == _currentRequest.type)
        {
            if((index & 0x00FF) == 0 ) // batch querry
            {
                if(recvInfo.num > 1 && recvInfo.data.contains(index + 1)) // 接收应答
                {
                    isResponse = true;
                }
            }
            else 
            {
                if(recvInfo.num >= 1 && recvInfo.data.contains(index))
                {
                    isResponse = true;
                }
            }
        }
        else if(SendRequestType::Setting == _currentRequest.type)
        {
            if(recvInfo.num >= 1 && recvInfo.data.contains(index))
            {
                emit itemSetResult(recvInfo.data[0], 0, "success");
                emit pageDataChanged();
                isResponse = true;
            }
        }
        else if(SendRequestType::Log == _currentRequest.type)
        {
            if(0 != recvInfo.num)
            {
                isResponse = true;
            }
        }


        if(isResponse)
        {
            _retryCount[index] = 0;
            _isSending = false;
            _sendQueueTimer->stop(); // 停止超时定时器
            qDebug() << "recv data success";

            if(_sendQueue.isEmpty())
            {
                _pageHash[_currentPage]->onFieldProcessed(true);
            }
            else
            {
                processSendQueue();
            }
            
            if(_pageHash[_currentPage]->getPageReflashState() == false)
            {
                emit pageDataChanged();
            }
        }
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
            enqueueSendRequest(sendData, SendRequestType::Setting);
            qDebug() << "Manual setting request for field:" << name << "with value:" << value;
        }
    }

    void pageMange::changePageAttribute(QString name, QVariant value)
    {
        _pageHash[_currentPage]->changePageAttribute(name, value.toInt());
        emit pageAttributeChanged();
    }

    QVariantMap pageMange::getPageAttribute()
    {
        pageAttribute_t pageAttribute = _pageHash[_currentPage]->getPageAttribute();
        QVariantMap pageAttributeMap;
        pageAttributeMap.insert("pageQuerryType", pageAttribute.pageQuerryType);
        pageAttributeMap.insert("csuIndex", pageAttribute.csuIndex);
        return pageAttributeMap;
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

        // 6. 界面属性自动刷新且设置开启自动刷新
        if  ((true== _autoRefreshEnabled )&& (1 == _pageHash[_currentPage]->getPageAttribute().isRefresh))
        {
            startAutoRefresh();
            _pageHash[_currentPage]->refreshPageAllData();
            qDebug() << "Restarted auto refresh timer for new page";
        }
    }

    void pageMange::manualRefreshPage()
    {
        if (_pageHash.contains(_currentPage))
        {
            _pageHash[_currentPage]->resetPollingState();
        }

        stopAutoRefresh();

        _sendQueue.clear();
        _isSending = false;
        _sendQueueTimer->stop();

        _retryCount.clear();

        if ((true == _autoRefreshEnabled) && (1 == _pageHash[_currentPage]->getPageAttribute().isRefresh))
        {
            startAutoRefresh();
            _pageHash[_currentPage]->forceRefreshPageAllData();
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

/*****************************************定时器回调函数*****************************************/

    void pageMange::onSendQueueTimeout()
    {
        if (_isSending)
        {
            unsigned int index = SLIPDATAINDEX(_currentRequest.data[0], _currentRequest.data[1], _currentRequest.data[2]);
            _retryCount[index]++;

            if (_retryCount[index] < MAX_RETRY_COUNT)
            {
                // 重试当前请求
                //qDebug() << "Retrying field:" << index;
                qDebug() << "Retrying field:" << _currentRequest.data.toHex();
                emit toSerialSend(_currentRequest.data);
                _sendQueueTimer->start(SEND_TIMEOUT_MS);
                return;
            }
            else
            {
                // 超过最大重试次数，跳过该字段
                qDebug() << "Max retries reached for field:" << _currentRequest.data.toHex() << ", skipping";
                
                // 设置三次后失败，通知UI界面设置失败
                if(_currentRequest.type == SendRequestType::Setting)
                {
                    emit itemSetResult("", 1, "failed");
                    emit pageDataChanged();
                }

                _retryCount[index] = 0; // 重置计数
                _isSending = false;
                 
                // 先通知页面字段处理失败（可能会向队列添加新请求）
                _pageHash[_currentPage]->onFieldProcessed(false);
            }
        }

        if(_sendQueue.isEmpty())
        {
            // 发送队列为空继续处理页面问询数据
            _pageHash[_currentPage]->onFieldProcessed(false);

        }else 
        {
            // 发送队列不为空继续处理发送队列
            processSendQueue();
        }
       
    }

    void pageMange::onRefreshTimer()
    {
        qDebug() << "Auto refresh triggered for page:" << _currentPage;
        _pageHash[_currentPage]->refreshPageAllData();
    }
}
