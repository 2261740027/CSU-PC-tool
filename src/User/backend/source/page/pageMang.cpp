#include "page/pageMang.h"
#include "page/mainPage.h"
#include "page/settingPage.h"
#include <QDebug>

namespace page
{

    pageMange::pageMange()
    {
        static mainPage page1Instance;
        registerPage("main", &page1Instance);

        static settingPage page2Instance;
        registerPage("setting", &page2Instance);

        // 页面定时刷新
        _refreshTimer = new QTimer(this);
        connect(_refreshTimer, &QTimer::timeout, this, &pageMange::onRefreshTimer);
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
        _pageHash[_currentPage]->handlePageDataUpdate(data);
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
        // emit
        emit toSerialSend(sendData);
    }

    void pageMange::notifyPageSwitch(const QString newPageName)
    {
        _currentPage = newPageName;
        qDebug() << "change page" + newPageName;
        _currPageData.clear();
    }

    void pageMange::setAutoRefreshEnabled(bool enabled)
    {
        if (_autoRefreshEnabled != enabled)
        {
            _autoRefreshEnabled = enabled;

            // if (enabled)
            // {
            //     startAutoRefresh();
            // }
            // else
            // {
            //     stopAutoRefresh();
            // }
        }
    }

    void pageMange::setRefreshInterval(int interval)
    {
        if (_refreshInterval != interval && interval > 0)
        {
            _refreshInterval = interval;

            // 页面跳转时，开启自动刷新定时器

            // // 如果定时器正在运行，重新启动以应用新的间隔
            // if (_refreshTimer && _refreshTimer->isActive())
            // {
            //     _refreshTimer->stop();
            //     _refreshTimer->start(_refreshInterval);
            //     qDebug() << "Refresh interval updated to:" << _refreshInterval << "ms";
            // }
        }
    }

    void pageMange::onRefreshTimer()
    {
        qDebug() << "Auto refresh triggered for page:" << _currentPage;
    }
}
