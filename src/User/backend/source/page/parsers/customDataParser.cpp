#include "page/parsers/customDataParser.h"
#include "page/parsers/basicDataParser.h"

namespace page {
    namespace parsers {

        QVariant customDataParser::parseData(const QByteArray &data, const QVariantMap &config)
        {
            QString dataType = config.value("type").toString().toLower();

            if(dataType == "calendar")
            {
                return parseCalendarData(data, config);
            }

            return QVariant();
        }

        bool customDataParser::canParse(const QVariantMap &config) const
        {
            QString dataType = config.value("type").toString().toLower();
            QStringList supportedTypes = {
                "calendar"
            };

            return supportedTypes.contains(dataType);
        }

        QVariant customDataParser::parseCalendarData(const QByteArray &data, const QVariantMap &config)
        {
            QVariantMap result;
            QJsonArray fields = config.value("fields").toJsonArray();
            int expectedLength = config.value("length").toInt();
            
            // 检查数据长度
            if (data.size() < expectedLength) {
                qWarning() << "Calendar data too small, expected:" << expectedLength << "got:" << data.size();
                return result;
            }
            
            int offset = 0;
            
            // 解析每个字段
            for (const QJsonValue &fieldValue : fields) 
            {
                QJsonObject field = fieldValue.toObject();
                QString fieldName = field["name"].toString();
                QString fieldType = field["type"].toString();
                int fieldSize = field["size"].toInt();

                int size = field["size"].toInt();
                
                if (offset + size > data.size()) {
                    qWarning() << "Field" << fieldName << "exceeds data size";
                    break;
                }

                QVariantMap config;
                config["type"] = fieldType;
                config["length"] = fieldSize;
                config["decimals"] = 0;
                
                QVariant reData =  basicDataParser::getInstance()->parseData(data.mid(offset, size), config);
                
                if (!reData.isNull()) {
                    result[fieldName] = reData;
                }
                
                offset += size;
            }

            for(auto it = result.begin(); it != result.end(); ++it)
            {
                qDebug() << "Result:" << it.key() << "=" << it.value();
            }
            
            return QVariant::fromValue(result);
        }

    }
}
