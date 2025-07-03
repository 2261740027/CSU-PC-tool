#ifndef PAGEFIELDTABLE_H
#define PAGEFIELDTABLE_H

#include <QObject>
#include <QVariant>
#include <QMap>
#include <QList>
#include <QByteArray>

#define SLIPDATAINDEX(group, category, number) (((group << 15) & 0xFF0000) | ((category << 7) & 0xFF00) | (number & 0xFF))

namespace page
{

    struct PageField
    {
        QString name;
        QString valueType;
        unsigned short length;
        unsigned short group;
        unsigned short category;
        unsigned short number;
    };

    struct pageMapField
    {
        QString valueType;
        unsigned short length;
        unsigned short group;
        unsigned short category;
        unsigned short number;
        QVariant value;
    };

    class PageFieldTable : public QObject
    {
        Q_OBJECT
        friend class pageBase;

    public:
        explicit PageFieldTable(QObject *parent = nullptr);
        const QString indexToName(const unsigned short index) const;
        void loadFields(const QList<PageField> &fields);
        void fieldUpdata(const unsigned short index, const QVariant &value);

        const QMap<QString, pageMapField> &getValueMap() const
        {
            return _valueMap;
        }

    private:
        QMap<QString, pageMapField> _valueMap;     // name ----> value
        QMap<unsigned short, QString> _reValueMap; // (group|category) ----> name
    };
}

#endif // PAGEFIELDTABLE_H
