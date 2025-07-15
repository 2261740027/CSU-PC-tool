#include "page/PageFieldTable.h"

namespace page
{
    PageFieldTable::PageFieldTable(QObject *parent)
        : QObject(parent) {}

    void PageFieldTable::loadFields(const QList<PageField> &fields)
    {
        for (const PageField &f : fields)
        {
            _valueMap[f.name].value = 77;
            _valueMap[f.name].valueType = f.valueType;
            _valueMap[f.name].length = f.length;
            _valueMap[f.name].group = f.group;
            _valueMap[f.name].category = f.category;
            _valueMap[f.name].number = f.number;

            _reValueMap.insert(SLIPDATAINDEX(f.group, f.category, f.number), f.name);
        }
    }

    void PageFieldTable::fieldUpdata(const unsigned int index, const QVariant &value)
    {
        QString name;
        if (_reValueMap.contains(index))
        {
            name = _reValueMap[index];
            _valueMap[name].value = value;
        }
        else
        {
            qDebug() << Q_FUNC_INFO << "index not found" << index;
        }
    }

    const QString PageFieldTable::indexToName(const unsigned int index) const
    {

        if (_reValueMap.contains(index))
        {
            return _reValueMap[index];
        }

        return QString();
    }
}
