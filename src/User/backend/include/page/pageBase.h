#ifndef PAGE1_H
#define PAGE1_H

#include <QObject>
// #include "page/IpageController.h"
#include "page/PageFieldTable.h"

namespace page
{
    class pageBase : public QObject
    {
    public:
        pageBase(QList<PageField> pageFieldList);
        ~pageBase() = default;

        virtual void setCmd(QString cmd) {}; // 发送命令
        virtual void refreshPageAllData() {};
        virtual QByteArray querryItemData(const QString &name);
        virtual QByteArray setItemData(const QString &name, const QVariant &value);

        void handlePageDataUpdate(const QByteArray &data);
        const QMap<QString, pageMapField> &getPageValueMap() const;

        const QMap<QString, pageMapField> &getPageTable() const
        {
            return _pageFieldTable.getValueMap();
        }

    private:
        QByteArray packSettingData(const QString &name, const QVariant &value);
        QVariant unpackRecvQueryData(const QString &name, const QByteArray &data);

        QList<PageField> _pageFieldList;
        PageFieldTable _pageFieldTable;

        // 页面属性
        bool _autoRefresh; // 自动刷新属性
    };
}

#endif // PAGE1_H
