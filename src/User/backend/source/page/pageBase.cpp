#include <QByteArray>
#include "pageBase.h"
#include "page/PageFieldTable.h"
#include "page/pageMang.h"
#include "serial/SlipProtocol.h"
#include <QDebug>
// #include "page/IpageController.h"

namespace page
{
    pageBase::pageBase(QList<PageField> &pageFieldList, QList<QByteArray> pageQuerryCmdList,pageMange *pageManager, pageAttribute_t pageAttribute)
        : _pageManager(pageManager), _pageQuerryCmdList(pageQuerryCmdList) ,_pageFieldList(pageFieldList), _pageAttribute(pageAttribute)
    {
        _pageFieldTable.loadFields(pageFieldList);
    }

    QByteArray pageBase::querryItemData(const QString &name)
    {
        QByteArray data;
        if (_pageFieldTable.getValueMap().contains(name))
        {
            data.append(_pageFieldTable.getValueMap()[name].group);     // group
            data.append(_pageFieldTable.getValueMap()[name].category);  // category
            data.append(_pageFieldTable.getValueMap()[name].number);    // number
        }
        return data;
    }

    QByteArray pageBase::packSettingData(const QString &name, const QVariant &value)
    {
        const pageMapField &field = _pageFieldTable.getValueMap()[name];
        QByteArray retData;

        int decimals = 1;
        if(field.extra.contains("decimals"))
        {
            decimals = field.extra["decimals"].toInt() * 10;
        }
            

        if (field.valueType == "int")
        {
            // 处理整数类型
            if (field.length == 1)
            {
                // 8位整数
                qint8 intValue = static_cast<qint8>(value.toInt() * decimals);
                retData.append(intValue);
            }
            else if (field.length == 2)
            {
                // 16位整数
                qint16 intValue = static_cast<qint16>(value.toInt() * decimals);
                retData.append(reinterpret_cast<const char *>(&intValue), sizeof(intValue));
            }
            else if (field.length == 4)
            {
                // 32位整数
                qint32 intValue = value.toInt() * decimals;
                retData.append(reinterpret_cast<const char *>(&intValue), sizeof(intValue));
            }
        }
        else if (field.valueType == "float")
        {
            if (field.length == 4)
            {
                // 32位浮点数
                float floatValue = value.toFloat() * decimals;
                retData.append(reinterpret_cast<const char *>(&floatValue), sizeof(floatValue));
            }
            else if (field.length == 8)
            {
                // 64位双精度浮点数
                double doubleValue = value.toDouble() * decimals;
                retData.append(reinterpret_cast<const char *>(&doubleValue), sizeof(doubleValue));
            }
        }
        else if (field.valueType == "short")
        {
            // 16位短整数
            qint16 shortValue = static_cast<qint16>(value.toInt() * decimals);
            retData.append(reinterpret_cast<const char *>(&shortValue), sizeof(shortValue));
        }
        else if (field.valueType == "ushort" || field.valueType == "uint16")
        {
            // 16位无符号短整数
            quint16 ushortValue = static_cast<quint16>(value.toUInt() * decimals);
            retData.append(reinterpret_cast<const char *>(&ushortValue), sizeof(ushortValue));
        }
        else if (field.valueType == "uint" || field.valueType == "uint32")
        {
            // 32位无符号整数
            quint32 uintValue = value.toUInt() * decimals;
            retData.append(reinterpret_cast<const char *>(&uintValue), sizeof(uintValue));
        }
        else if (field.valueType == "char" || field.valueType == "int8")
        {
            // 8位字符/整数
            qint8 charValue = static_cast<qint8>(value.toInt() * decimals);
            retData.append(charValue);
        }
        else if (field.valueType == "uchar" || field.valueType == "uint8")
        {
            // 8位无符号字符/整数
            quint8 ucharValue = static_cast<quint8>(value.toUInt() * decimals);
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
        
        if (_pageFieldTable.getValueMap().contains(name))
        {
            // 更新字段值
            //_pageFieldTable.getValueMap()[name].value = value;
            
            // 获取字段信息
            const pageMapField &field = _pageFieldTable.getValueMap()[name];
            
            data.append(field.group + 1);
            data.append(field.category); 
            data.append(field.number);
            
            QByteArray packedData = packSettingData(name, value);
            if (!packedData.isEmpty())
            {
                data.append(packedData);
            }
            else
            {
                return QByteArray();
            }
            return data;
        }

        qDebug() << Q_FUNC_INFO << "name not found" << name;
        return QByteArray();
    }

    const QMap<QString, pageMapField> &pageBase::getPageTable() const
    {
        return _pageFieldTable.getValueMap();
    }

    QVariant pageBase::unpackByteStream(const QString &name, const QByteArray &data)
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

    pageDataUpdateResult_t pageBase::handlePageDataUpdate(const QByteArray &data)
    {

        pageDataUpdateResult_t result;
        result.num = 0;

        if(data.length() < 3)
        {
            return result;
        }
        unsigned short group = data[0];
        // unsigned short category = data[1];
        // unsigned short number = data[2];

        if (group == 0x08) // handle setting ack
        {
            if(data.length() < 7)
            {
                return result;
            }

            unsigned int setResult = data[6];

            if(0x00 == setResult)
            {
                unsigned int index = SLIPDATAINDEX(data[3], data[4], data[5]);
                QString valueName = _pageFieldTable.indexToName(index);
                int sendlength = _pageFieldTable._valueMap[valueName].length;
                QByteArray sendData = {};

                if(_pageManager->getCurrentRequest().data.size() < (sendlength + 3) )
                {
                    result.num = 0;
                }
                else 
                {
                    sendData = _pageManager->getCurrentRequest().data.mid(3,sendlength);

                    QVariant devalue = unpackByteStream(valueName, sendData);

                    if (!devalue.isNull())
                    {
                        result.data.insert(index, valueName);
                        result.num++;
                        _pageFieldTable.fieldUpdata(index, devalue);
                    }
  
                }
               
                //_pageManager->getCurrentRequest().data
                // 通知UI设置成功
            }

        }
        else // handle query ack
        {
            // 暂时不对0x68进行处理
            int valueLength = protocol::slip::groupDataSizeMap[group];
            int valueNum = 0;

            QByteArray handleRxData = data.mid(1, data.length() - 1);
            

            if (handleRxData.length() % (valueLength + 2) == 0)
            {
                valueNum = handleRxData.length() / (valueLength + 2);
            }
            else
            {
                return result;
            }

            for (int i = 0; i < valueNum; i++)
            {
                QByteArray value = handleRxData.mid(i * (valueLength + 2) + 2, valueLength);
                unsigned int index = SLIPDATAINDEX(group, handleRxData[i * (valueLength + 2)], handleRxData[i * (valueLength + 2) + 1]);


                QString valueName = _pageFieldTable.indexToName(index);
                if(valueName.isEmpty() )
                {
                    result.data.insert(index, QString());   //未找到的数据插入空
                    result.num++;
                    continue;
                }
                QVariant devalue = unpackByteStream(valueName, value);

                if (!devalue.isNull())
                {
                    result.data.insert(index, valueName);
                    result.num++;
                    _pageFieldTable.fieldUpdata(index, devalue);
                }
            }
        }

        return result;
    }

    // 轮询相关功能实现
    void pageBase::refreshPageAllData()
    {
        if (_pageReflashState)
        {
            return; // 已在轮询中，避免重复启动
        }

        _pageReflashState = true;
        _currentFieldIndex = 0;

        queryCurrentField();
    }

    // 默认发送query
    void pageBase::queryCurrentField()
    {
        if (_currentFieldIndex >= _pageQuerryCmdList.size())
        {
            // 所有字段都查询完成
            _pageReflashState = false;
            qDebug() << "All fields queried, cycle complete";
            return;
        }

        // 通过pageMange发送查询数据，超时和重试由pageMang处理
        if (_pageManager)
        {
            if((_pageQuerryCmdList.size() > _currentFieldIndex) && (!_pageQuerryCmdList.empty()) )
            {
                QByteArray queryData = _pageQuerryCmdList[_currentFieldIndex];
                if(!queryData.isEmpty())
                {
                    _pageManager->sendRawData(queryData, SendRequestType::Query);
                }
            }
        }
    }

    void pageBase::moveToNextField()
    {
        _currentFieldIndex++;
        queryCurrentField();
    }

    void pageBase::onFieldProcessed(bool success)
    {
        if (_pageReflashState)
        {
            // 无论成功还是失败，都继续下一个字段
            moveToNextField();
        }
    }

    void pageBase::resetPollingState()
    {
        qDebug() << "Resetting polling state for page";
        _pageReflashState = false;
        _currentFieldIndex = 0;
    }

    const pageAttribute_t &pageBase::getPageAttribute() const
    {
        return _pageAttribute;
    }

    bool pageBase::appendQuerryCmd(const QByteArray &cmd)
    {
        if(cmd.isEmpty())
        {
            return false;
        }

        _pageQuerryCmdList.append(cmd);

        return true;
    }

}
