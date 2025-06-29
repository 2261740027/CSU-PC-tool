#ifndef DBTABLE_H
#define DBTABLE_H

#include <QString>
#include <QMap>
#include <QVariant>

namespace dbTable
{

    struct DBItem
    {
        QString dataId;
        QString logId;
        double value = 0.0;
        QMap<QString, QVariant> extraFields;

        QVariantMap toMap() const
        {
            QVariantMap map{{"dataId", dataId},
                            {"logId", logId},
                            {"value", value}};
            for (auto it = extraFields.constBegin(); it != extraFields.constEnd(); ++it)
            {
                map[it.key()] = it.value();
            }
            return map;
        }
    };

    class dbTableMange
    {

    public:
        void dbInit();

        QVariantMap currentPageData() const
        {
            QVariantMap result;
            auto page = _dbTableMap.value(_curretnPage);
            for (auto it = page.constBegin(); it != page.constEnd(); ++it)
            {
                result[it.key()] = it.value().toMap();
            }
            return result;
        }

    private:
        QString _curretnPage;
        QMap<QString, QMap<QString, DBItem>> _dbTableMap;
    };

}

#endif