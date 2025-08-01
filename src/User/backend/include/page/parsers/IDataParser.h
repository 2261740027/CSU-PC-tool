#ifndef IDATAPARSER_H
#define IDATAPARSER_H

#include <QObject>
#include <QVariant>
#include <QByteArray>
#include <QVariantMap>
#include "singleton.h"

namespace page {

    namespace parsers {

        class IDataParser : public QObject
        {
            Q_OBJECT
        public:
            explicit IDataParser(QObject *parent = nullptr): QObject(parent) {};
            virtual ~IDataParser() = default;

            virtual QVariant parseData(const QByteArray &data, const QVariantMap &config) = 0;
            virtual QString parserName() const = 0;
            virtual bool canParse(const QVariantMap &config) const = 0;
        };

        class DataParserFactory : public QObject, public Singleton<DataParserFactory>
        {
            Q_OBJECT
        public:
            explicit DataParserFactory(QObject *parent = nullptr);
            ~DataParserFactory();
    
            void registerParser(IDataParser *parser);
            IDataParser* getParser(const QVariantMap &config);
            QVariant parseData(const QByteArray &data, const QVariantMap &config);
    
        private:
            QList<IDataParser*> m_parsers;
        };

    }
}

#endif