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
    }pageAttribute_t;

    class pageBase : public QObject
    {
    public:
        pageBase(QList<PageField> pageFieldList, pageMange *pageManager, pageAttribute_t pageAttribute);
        ~pageBase() = default;

        virtual void setCmd(QString cmd) {}; // 发送命令
        void refreshPageAllData();
        virtual QString handlePageDataUpdate(const QByteArray &data);
        void onFieldProcessed(const QString &fieldName, bool success);
        
        // 重置轮询状态（页面切换时使用）
        void resetPollingState();
        // 获取页面属性
        const pageAttribute_t &getPageAttribute() const;       
        //slip querry
        virtual QByteArray querryItemData(const QString &name);
        //slip setting value
        virtual QByteArray setItemData(const QString &name, const QVariant &value);
        // 
        const QMap<QString, pageMapField> &getPageValueMap() const;
        const QMap<QString, pageMapField> &getPageTable() const
        {
            return _pageFieldTable.getValueMap();
        }

    protected:
        pageMange *_pageManager = nullptr; // pageMange引用，供派生类使用
        
        // 轮询状态管理
        bool _pageReflashState = false;
        int _currentFieldIndex = 0;
        
        // 轮询相关方法
        void queryCurrentField();
        void moveToNextField();

    private:
        QByteArray packSettingData(const QString &name, const QVariant &value);
        QVariant unpackRecvQueryData(const QString &name, const QByteArray &data);

        QList<PageField> _pageFieldList;
        PageFieldTable _pageFieldTable;
        pageAttribute_t _pageAttribute;
    };
}

#endif
