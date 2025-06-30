#include "dbTab/querry/testpage1.h"

namespace dbTable
{
    static QMap<unsigned short,DBItem> page1Data = {
        {0x1000, {0,  {{"unit", "V"}}}},
        {0x2000, {0,  {{"unit", "A"}}}},
        {0x3000, {0,  {{"unit", "℃"}}}}
    };

    const Detail pag1Detail = 
    {
    /*group		*/0x18u,       
    /*dataSize  */2,        
    /*itemNum	*/page1Data.size(),
    /*service	*/0,               
    };

    testQuerry::testQuerry()
        : tabQuery(pag1Detail)
    {

    }

    QVariant testQuerry::getItemValue(const DataId& dataId)
    {
        if(page1Data.contains(dataId.value))
        {
            return page1Data[dataId.value].value;
        }
        else
        {
            return QVariant();
        }
    }

    void testQuerry::setItemValue(const DataId& dataId, const QVariant wrData)
    {
        if(page1Data.contains(dataId.value))
        {
            page1Data[dataId.value].value = wrData;
        }
    }

    QVariantMap testQuerry::toQMLTabData() const
    {
        QVariantMap result;

        for (auto it = page1Data.constBegin(); it != page1Data.constEnd(); ++it)
        {
            // 使用 key（unsigned short）转为 16进制字符串或十进制字符串作为 QVariantMap 的 key
            QString key = QString("0x%1").arg(it.key(), 4, 16, QLatin1Char('0')).toUpper();
            result[key] = it.value().toMap();  // 每个 DBItem 转换为 QVariantMap
        }

        return result;
    }
    
}