#ifndef PAGEBASE_H
#define PAGEBASE_H

#include <QObject>
// #include "page/IpageController.h"
#include "page/PageFieldTable.h"

namespace page
{
    class pageMange;
}

namespace page
{
    typedef struct pageAttribute 
    {
        int isRefresh;
        int pageQuerryType = 0;      // 0: value, 1: Max, 2: Min
        int csuIndex = 0;
    }pageAttribute_t;

    typedef struct pageDataUpdateResult
    {
        int num;                         //接收数据数
        QHash<unsigned short, QString> data;   //接收数据索引
    }pageDataUpdateResult_t;

    class pageBase : public QObject
    {
    public:
        pageBase(QList<PageField> &pageFieldList, 
                QList<QByteArray> pageQuerryCmdList,
                pageMange *pageManager, 
                pageAttribute_t pageAttribute);

        ~pageBase() = default;

        void refreshPageAllData();
        void forceRefreshPageAllData();
        void resetPollingState();                                                                   // 重置轮询状态（页面切换时使用）
        
        const pageAttribute_t &getPageAttribute() const;                                            // 获取页面属性
        void changePageAttribute(QString name, int value);
        const QMap<QString, pageMapField> &getPageTable() const;
        void appendPageField(QList<PageField> &pageFieldList);
        bool appendQuerryCmd(const QByteArray &cmd);
        bool getPageReflashState() { return _pageReflashState; }

        virtual void setCmd(QString cmd) {};   
        virtual void onFieldProcessed(bool success);                                                     // 发送命令
        virtual QByteArray querryItemData(const QString &name);                                     // slip querry             
        virtual QByteArray setItemData(const QString &name, const QVariant &value);                 // slip setting value
        virtual pageDataUpdateResult_t handlePageDataUpdate(const QByteArray &data);

        
    protected:
        pageMange *_pageManager = nullptr; // pageMange引用，供派生类使用
        
        // 轮询状态管理
        bool _pageReflashState = false;
        int _currentFieldIndex = 0;
        
        // 轮询相关方法
        virtual void queryCurrentField();
        void moveToNextField();

    private:
        QByteArray packSettingData(const QString &name, const QVariant &value);
        QVariant unpackByteStream(const QString &name, const QByteArray &data);
        QByteArray getQuerryCmd();

        QList<PageField> _pageFieldList;
        PageFieldTable _pageFieldTable;
        pageAttribute_t _pageAttribute;
        QList<QByteArray> _pageQuerryCmdList;                  // 页面查询命令列表
    };
}

#endif
