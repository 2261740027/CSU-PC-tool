#ifndef PAGEMANG_H
#define PAGEMANG_H

#include <QString>
#include <QHash>
#include <QOBject>
// #include "page/IpageController.h"
#include "page/pageBase.h"
#include <QTimer>
#include <QQueue>
#include <QMap>

namespace page
{
    // 发送请求类型
    enum class SendRequestType
    {
        Query,  // 查询请求
        Setting, // 设置请求
        Log
    };

    // 发送请求结构
    struct SendRequest
    {
        QByteArray data;
        SendRequestType type;

        SendRequest() : type(SendRequestType::Query) {}

        SendRequest(const QByteArray &d, SendRequestType t)
            : data(d), type(t){}
    };

    class pageMange : public QObject
    {
        Q_OBJECT
        Q_PROPERTY(QVariantMap pageData READ pageData NOTIFY pageDataChanged)

    public:
        pageMange();
        ~pageMange() = default;

        //Q_INVOKABLE void getPageData(QString name);                 // 获取单个数据
        Q_INVOKABLE void setItemData(QString name, QVariant value);   // 设置单个数据
        Q_INVOKABLE void notifyPageSwitch(const QString newPageName); // qml界面切换页面

        // 定时刷新
        Q_INVOKABLE void manualRefreshPage() {};
        Q_INVOKABLE void startAutoRefresh();
        Q_INVOKABLE void stopAutoRefresh();
        Q_INVOKABLE bool autoRefreshEnabled() const { return _autoRefreshEnabled; }
        Q_INVOKABLE void setAutoRefreshEnabled(bool enabled);
        Q_INVOKABLE int refreshInterval() const { return _refreshInterval; }
        Q_INVOKABLE void setRefreshInterval(int interval);

        void refreshPage();          // 刷新当前页面所有数据
        QString currentPage() const; // 获取当前页面名称
        QVariantMap pageData();      // UI界面获取当前界面数据
        void sendRawData(const QByteArray &data, SendRequestType type);

        // 获取当前请求
        SendRequest getCurrentRequest() const { return _currentRequest; }

    private:
        void updatePageData();                                            // 刷新mang向qml界面显示缓冲
        void registerPage(const QString &pageName, pageBase *controller); // 注册页面控制器

        // 发送队列相关方法
        void enqueueSendRequest(const QByteArray &data, SendRequestType type);
        void processSendQueue();
        bool canSendNow();

        QVariantMap _currPageData; // 当前页面数据
                                   // 全局数据 --- 暂定
        QHash<QString, pageBase *> _pageHash;
        QString _currentPage = "main";

        // 定时刷新
        QTimer *_refreshTimer;
        bool _autoRefreshEnabled = true;
        int _refreshInterval = 60 * 1000; // 定时刷新间隔1min

        // 发送队列机制
        QQueue<SendRequest> _sendQueue;         // 发送队列
        bool _isSending = false;                // 当前是否正在处理请求（发送+等待响应）
        QTimer *_sendQueueTimer;                // 队列处理定时器
        static const int SEND_TIMEOUT_MS = 500; // 发送超时时间

        // 重试机制
        QMap<unsigned short, int> _retryCount;      // 每个字段的重试计数
        static const int MAX_RETRY_COUNT = 3;       // 最大重试次数
        SendRequest _currentRequest;                // 当前正在处理的请求

    signals:
        void toSerialSend(QByteArray data);
        void currentControllerChanged();
        void pageDataChanged(); // 通知UI界面数据发生变化
        void itemSetResult(const QString &name, int resultCode, const QString &message = QString());  // 通知UI界面设置结果

    public slots:
        void handleDataUpdate(QByteArray data); // 处理数据更新

    private slots:
        void onRefreshTimer();
        void onSendQueueTimeout(); // 发送队列超时处理
    };

}

#endif
