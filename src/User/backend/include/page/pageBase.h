#ifndef PAGEBASE_H
#define PAGEBASE_H

#include <QObject>
// #include "page/IpageController.h"
#include "page/PageFieldTable.h"

namespace page { class pageMange; }

namespace page
{
    class pageBase : public QObject
    {
    public:
        pageBase(QList<PageField> pageFieldList, pageMange* pageManager);
        ~pageBase() = default;

        virtual void setCmd(QString cmd) {}; // 发送命令
        virtual void refreshPageAllData() {};
        virtual QByteArray querryItemData(const QString &name);
        virtual QByteArray setItemData(const QString &name, const QVariant &value);

        virtual void handlePageDataUpdate(const QByteArray &data);
        const QMap<QString, pageMapField> &getPageValueMap() const;

        const QMap<QString, pageMapField> &getPageTable() const
        {
            return _pageFieldTable.getValueMap();
        }

        pageMange* _pageManager = nullptr;  // 添加pageMange引用

    private:
        QByteArray packSettingData(const QString &name, const QVariant &value);
        QVariant unpackRecvQueryData(const QString &name, const QByteArray &data);

        QList<PageField> _pageFieldList;
        PageFieldTable _pageFieldTable;



        
    };
}

#endif 
