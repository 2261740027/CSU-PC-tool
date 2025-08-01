#include "page/parsers/basicDataParser.h"

namespace page {

    namespace parsers {

        QVariant basicDataParser::parseData(const QByteArray &data, const QVariantMap &config)
        {
            QString dataType = config.value("type").toString().toLower();
            
            if (dataType == "int" || dataType == "int8" || dataType == "int16" || 
                dataType == "int32" || dataType == "short" || dataType == "char") 
            {
                return parseInteger(data, config);
            } 
            else if (dataType == "uint" || dataType == "uint8" || dataType == "uint16" || 
                    dataType == "uint32" || dataType == "ushort" || dataType == "uchar") 
            {
                return parseInteger(data, config);
            } 
            else if (dataType == "float" || dataType == "double") 
            {
                return parseFloat(data, config);
            } 
            else if (dataType == "bool" || dataType == "boolean") 
            {
                return parseBoolean(data, config);
            } 
            else if (dataType == "string" || dataType == "char*") 
            {
                return parseString(data, config);
            }
            
            qWarning() << "Unsupported data type:" << dataType;
            return QVariant();
        }

        bool basicDataParser::canParse(const QVariantMap &config) const
        {
            QString dataType = config.value("type").toString().toLower();
            QStringList supportedTypes = {
                "int", "int8", "int16", "int32", "short", "char",
                "uint", "uint8", "uint16", "uint32", "ushort", "uchar",
                "float", "double", "bool", "boolean", "string", "char*"
            };
            
            return supportedTypes.contains(dataType);
        }

        QVariant basicDataParser::parseInteger(const QByteArray &data, const QVariantMap &config)
        {
            QString dataType = config.value("type").toString().toLower();
            int length = config.value("length", 4).toInt();
            int decimals = config.value("decimals", 0).toInt();
            // 默认小端方式传输
            //bool isLittleEndian = config.value("littleEndian", true).toBool();
            
            if (data.size() < length) {
                qWarning() << "Data size too small for type:" << dataType << "expected:" << length << "got:" << data.size();
                return QVariant();
            }
            
            qint64 value = 0;
            bool isSigned = dataType.startsWith("int") || dataType == "short" || dataType == "char";
            
            // 根据字节序读取数据
            for (int i = 0; i < length; ++i) {
                //int byteIndex = isLittleEndian ? i : (length - 1 - i);
                int byteIndex = i;
                quint8 byte = static_cast<quint8>(data[byteIndex]);
                value |= static_cast<qint64>(byte) << (i * 8);
            }
            
            // 处理有符号数
            if (isSigned && length < 8) {
                qint64 signBit = 1ULL << (length * 8 - 1);
                if (value & signBit) {
                    value -= (1ULL << (length * 8));
                }
            }
            
            // 应用小数位
            if (decimals > 0) {
                return QVariant(static_cast<double>(value) / std::pow(10, decimals));
            }
            
            return QVariant(value);
        }
        
        QVariant basicDataParser::parseFloat(const QByteArray &data, const QVariantMap &config)
        {
            QString dataType = config.value("type").toString().toLower();
            int length = config.value("length", 4).toInt();
            int decimals = config.value("decimals", 0).toInt();
            
            if (data.size() < length) {
                qWarning() << "Data size too small for type:" << dataType;
                return QVariant();
            }
            
            double value = 0.0;
            
            if (dataType == "float" && length == 4) {
                float floatValue;
                memcpy(&floatValue, data.constData(), sizeof(float));
                value = static_cast<double>(floatValue);
            } else if (dataType == "double" && length == 8) {
                memcpy(&value, data.constData(), sizeof(double));
            } else {
                qWarning() << "Unsupported float type or length:" << dataType << length;
                return QVariant();
            }
            
            // 应用小数位
            if (decimals > 0) {
                value /= std::pow(10, decimals);
            }
            
            return QVariant(value);
        }

        QVariant basicDataParser::parseBoolean(const QByteArray &data, const QVariantMap &config)
        {
            if (data.isEmpty()) {
                return QVariant(false);
            }
            
            quint8 value = static_cast<quint8>(data[0]);
            return QVariant(value != 0);
        }

        QVariant basicDataParser::parseString(const QByteArray &data, const QVariantMap &config)
        {
            int maxLength = config.value("maxLength", data.size()).toInt();
            bool nullTerminated = config.value("nullTerminated", true).toBool();
            
            QByteArray stringData = data.left(maxLength);
            
            if (nullTerminated) {
                int nullPos = stringData.indexOf('\0');
                if (nullPos >= 0) {
                    stringData = stringData.left(nullPos);
                }
            }
            
            return QVariant(QString::fromUtf8(stringData));
        }
    }
}