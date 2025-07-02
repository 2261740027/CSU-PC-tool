#include "page/PageFieldTable.h"


namespace page {
    PageFieldTable::PageFieldTable(QObject* parent)
        : QObject(parent) {}

    void PageFieldTable::loadFields(const QList<PageField>& fields) {
        for (const PageField& f : fields) {
            _valueMap[f.name].value = 77;
            _valueMap[f.name].valueType = f.valueType;
            _valueMap[f.name].length = f.length;
            _valueMap[f.name].group = f.group;
            _valueMap[f.name].category = f.category;
            _valueMap[f.name].number = f.number;

            _reValueMap.insert( ((f.group << 8)|f.category), f.name);
        }
    }

    QVariant PageFieldTable::uiGetValue(const QString& name) const {
        return _valueMap[name].value;
    }

    void PageFieldTable::uiSetValue(const QString& name, const QVariant val)
    {
        unsigned short index;
        index =  (_valueMap[name].group << 8) |  _valueMap[name].category;
    }


    void PageFieldTable::fieldUpdated(QByteArray &recValue)
    {
        QString valueName;

        if(recValue.length() < 2)
        {
            return;
        }
        unsigned short group = recValue[0];
        unsigned short category = recValue[1];

        valueName = _reValueMap[(group << 8) | category];

        if(recValue.length() < (_valueMap[valueName].length + 3))
        {
            return;
        }

        unsigned short value = ((unsigned short)recValue[3] << 8 | (recValue[4] & 0xFF));
        _valueMap[valueName].value = value;
    }
}

