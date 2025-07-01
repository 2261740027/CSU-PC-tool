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
        unsigned short group = recValue[0];
        unsigned short category = recValue[1];
        unsigned short value = ((unsigned short)recValue[2] << 8 | (recValue[3] & 0xFF));
        QString valueName;

        valueName = _reValueMap[(group << 8) | category];
        _valueMap[valueName].value = value;

        // 通知ui更新
    }
}

