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
    class pageBase : public QObject
    {
    public:
        pageBase(QList<PageField> pageFieldList, pageMange *pageManager);
        ~pageBase() = default;

        virtual void setCmd(QString cmd) {}; // 发送命令
        virtual void refreshPageAllData() {};
        virtual QByteArray querryItemData(const QString &name);
        virtual QByteArray setItemData(const QString &name, const QVariant &value);

        virtual QString handlePageDataUpdate(const QByteArray &data);
        virtual void onFieldProcessed(const QString &fieldName, bool success) {}; // 字段处理完成回调
        const QMap<QString, pageMapField> &getPageValueMap() const;

        const QMap<QString, pageMapField> &getPageTable() const
        {
            return _pageFieldTable.getValueMap();
        }

    protected:
        pageMange *_pageManager = nullptr; // pageMange引用，供派生类使用

    private:
        QByteArray packSettingData(const QString &name, const QVariant &value);
        QVariant unpackRecvQueryData(const QString &name, const QByteArray &data);

        QList<PageField> _pageFieldList;
        PageFieldTable _pageFieldTable;
    };
}

#endif
