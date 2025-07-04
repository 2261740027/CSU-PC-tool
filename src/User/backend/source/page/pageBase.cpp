#include <QByteArray>
#include "pageBase.h"
#include "page/PageFieldTable.h"
// #include "page/IpageController.h"

namespace page
{
    pageBase::pageBase(QList<PageField> pageFieldList, pageMange *pageManager)
        : _pageManager(pageManager)
    {
        _pageFieldTable.loadFields(pageFieldList);
    }

    QByteArray pageBase::querryItemData(const QString &name)
    {
        QByteArray data;
        if (_pageFieldTable.getValueMap().contains(name))
        {
            data.append(_pageFieldTable.getValueMap()[name].group);    // group
            data.append(_pageFieldTable.getValueMap()[name].category); // category
            data.append(_pageFieldTable.getValueMap()[name].number);
        }
        return data;
    }

    QByteArray pageBase::packSettingData(const QString &name, const QVariant &value)
    {
        const pageMapField &field = _pageFieldTable.getValueMap()[name];
        QByteArray retData;

        if (field.valueType == "int")
        {
            // 处理整数类型
            if (field.length == 1)
            {
                // 8位整数
                qint8 intValue = static_cast<qint8>(value.toInt());
                retData.append(intValue);
            }
            else if (field.length == 2)
            {
                // 16位整数
                qint16 intValue = static_cast<qint16>(value.toInt());
                retData.append(reinterpret_cast<const char *>(&intValue), sizeof(intValue));
            }
            else if (field.length == 4)
            {
                // 32位整数
                qint32 intValue = value.toInt();
                retData.append(reinterpret_cast<const char *>(&intValue), sizeof(intValue));
            }
        }
        else if (field.valueType == "float")
        {
            if (field.length == 4)
            {
                // 32位浮点数
                float floatValue = value.toFloat();
                retData.append(reinterpret_cast<const char *>(&floatValue), sizeof(floatValue));
            }
            else if (field.length == 8)
            {
                // 64位双精度浮点数
                double doubleValue = value.toDouble();
                retData.append(reinterpret_cast<const char *>(&doubleValue), sizeof(doubleValue));
            }
        }
        else if (field.valueType == "short")
        {
            // 16位短整数
            qint16 shortValue = static_cast<qint16>(value.toInt());
            retData.append(reinterpret_cast<const char *>(&shortValue), sizeof(shortValue));
        }
        else if (field.valueType == "ushort" || field.valueType == "uint16")
        {
            // 16位无符号短整数
            quint16 ushortValue = static_cast<quint16>(value.toUInt());
            retData.append(reinterpret_cast<const char *>(&ushortValue), sizeof(ushortValue));
        }
        else if (field.valueType == "uint" || field.valueType == "uint32")
        {
            // 32位无符号整数
            quint32 uintValue = value.toUInt();
            retData.append(reinterpret_cast<const char *>(&uintValue), sizeof(uintValue));
        }
        else if (field.valueType == "char" || field.valueType == "int8")
        {
            // 8位字符/整数
            qint8 charValue = static_cast<qint8>(value.toInt());
            retData.append(charValue);
        }
        else if (field.valueType == "uchar" || field.valueType == "uint8")
        {
            // 8位无符号字符/整数
            quint8 ucharValue = static_cast<quint8>(value.toUInt());
            retData.append(ucharValue);
        }
        else if (field.valueType == "bool")
        {
            // 布尔类型
            quint8 boolValue = value.toBool() ? 1 : 0;
            retData.append(boolValue);
        }
        else
        {
            qDebug() << "valueType not support" << field.valueType;
            return QByteArray();
        }

        return retData;
    }

    QByteArray pageBase::setItemData(const QString &name, const QVariant &value)
    {
        QByteArray data;
        auto it = _pageFieldTable.getValueMap().find(name);
        if (it != _pageFieldTable.getValueMap().end()) {
            pageMapField field = it.value();
            field.value = value;
            data.append(field.group);
            data.append(field.category);
            data.append(field.number);

            QByteArray packedData = packSettingData(name, value);
            if (!packedData.isEmpty()) {
                data.append(packedData);
            }
            
            return data;
        }

        qDebug() << Q_FUNC_INFO << "name not found" << name;
        return QByteArray();
    }

    const QMap<QString, pageMapField> &pageBase::getPageValueMap() const
    {
        return _pageFieldTable.getValueMap();
    }

    QVariant pageBase::unpackRecvQueryData(const QString &name, const QByteArray &data)
    {
        QString varType = _pageFieldTable.getValueMap()[name].valueType;
        int length = _pageFieldTable.getValueMap()[name].length;

        if (varType == "char" || varType == "int8")
        {
            if (length == 1)
            {
                qint8 value = static_cast<qint8>(data[0]);
                qDebug() << Q_FUNC_INFO << "Parsed int8:" << value;
                return QVariant(static_cast<int>(value));
            }
        }
        else if (varType == "uchar" || varType == "uint8")
        {
            if (length == 1)
            {
                quint8 value = static_cast<quint8>(data[0]);
                qDebug() << Q_FUNC_INFO << "Parsed uint8:" << value;
                return QVariant(static_cast<uint>(value));
            }
        }
        else if (varType == "short" || varType == "int16")
        {
            if (length == 2)
            {
                qint16 value;
                memcpy(&value, data.constData(), sizeof(qint16));
                qDebug() << Q_FUNC_INFO << "Parsed int16:" << value;
                return QVariant(static_cast<int>(value));
            }
        }
        else if (varType == "ushort" || varType == "uint16")
        {
            if (length == 2)
            {
                quint16 value;
                memcpy(&value, data.constData(), sizeof(quint16));
                qDebug() << Q_FUNC_INFO << "Parsed uint16:" << value;
                return QVariant(static_cast<uint>(value));
            }
        }
        else if (varType == "int")
        {
            if (length == 4)
            {
                // 4字节整数
                qint32 value;
                memcpy(&value, data.constData(), sizeof(qint32));
                qDebug() << Q_FUNC_INFO << "Parsed int32:" << value;
                return QVariant(value);
            }
        }
        else if (varType == "uint")
        {
            if (length == 4)
            {
                quint32 value;
                memcpy(&value, data.constData(), sizeof(quint32));
                qDebug() << Q_FUNC_INFO << "Parsed uint32:" << value;
                return QVariant(value);
            }
        }
        else if (varType == "float")
        {
            if (length == 4)
            {
                float value;
                memcpy(&value, data.constData(), sizeof(float));
                qDebug() << Q_FUNC_INFO << "Parsed float:" << value;
                return QVariant(value);
            }
        }
        else
        {
            qDebug() << Q_FUNC_INFO << "Unsupported data type:" << varType;
            return QVariant();
        }

        qDebug() << Q_FUNC_INFO << "Failed to parse data for field:" << name;
        return QVariant();
    }

    QString pageBase::handlePageDataUpdate(const QByteArray &data)
    {

        if (data.length() < 3)
        {
            return QString();
        }

        unsigned short group = data[0];
        unsigned short category = data[1];
        unsigned short number = data[2];

        if (group == 0x08) // handle setting ack
        {
        }
        else // handle query ack
        {
            // 批量问询时检查应答数据的第一个数据名是否与请求数据名一致
            QByteArray handleRxData = data.mid(1, data.length() - 1);
            QString varName = _pageFieldTable.indexToName(SLIPDATAINDEX(group, category, number));
            int valueLength = 0, valueNum = 0;

            if (!varName.isEmpty())
            {
                valueLength = _pageFieldTable.getValueMap()[varName].length;
            }

            if (handleRxData.length() % (valueLength + 2) == 0)
            {
                valueNum = handleRxData.length() / (valueLength + 2);
            }
            else
            {
                return QString();
            }

            for (int i = 0; i < valueNum; i++)
            {
                QByteArray value = handleRxData.mid(i * valueLength + 2, valueLength);
                unsigned short index = SLIPDATAINDEX(group, handleRxData[i * valueLength], handleRxData[i * valueLength + 1]);

                QVariant devalue = unpackRecvQueryData(varName, value);
                if (!devalue.isNull())
                {
                    _pageFieldTable.fieldUpdata(index, devalue);
                }
            }
            return varName;
        }
        return QString();
    }
}
