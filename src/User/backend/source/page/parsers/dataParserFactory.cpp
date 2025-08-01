#include "page/parsers/IDataParser.h"
#include "page/parsers/basicDataParser.h"
#include "page/parsers/customDataParser.h"
#include <QDebug>

namespace page {

    namespace parsers {

        DataParserFactory::DataParserFactory(QObject *parent) : QObject(parent)
        {
            registerParser(basicDataParser::getInstance());
            registerParser(customDataParser::getInstance());
        }

        DataParserFactory::~DataParserFactory()
        {

        }

        void DataParserFactory::registerParser(IDataParser *parser)
        {
            if(parser && !m_parsers.contains(parser))
            {
                m_parsers.append(parser);
                qDebug() << "Registered parser:" << parser->parserName();
            }
        }

        IDataParser* DataParserFactory::getParser(const QVariantMap &config)
        {
            for(IDataParser *parser : m_parsers)
            {
                if(parser->canParse(config))
                {
                    return parser;
                }
            }

            qWarning() << "No suitable parser found for config:" << config;
            return nullptr;
        }

        QVariant DataParserFactory::parseData(const QByteArray &data, const QVariantMap &config)
        {
            if(!(config.contains("type") && config.contains("length")))
            {
                qWarning() << "Config missing type or length";
                return QVariant();
            }

            IDataParser *parser = getParser(config);
            if (parser) {
                return parser->parseData(data, config);
            }
            
            qWarning() << "Failed to parse data, no suitable parser found";
            return QVariant();
        }
    }
}

