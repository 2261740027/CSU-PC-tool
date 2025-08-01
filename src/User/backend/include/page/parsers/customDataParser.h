#ifndef CUSTOMDATAPARSER_H
#define CUSTOMDATAPARSER_H

#include <QJsonObject>    
#include <QJsonArray>
#include "IDataParser.h"
#include "singleton.h"

namespace page {
    namespace parsers {

        class customDataParser : public IDataParser, public Singleton<customDataParser>
        {
            Q_OBJECT
        public:
            explicit customDataParser(QObject *parent = nullptr): IDataParser(parent) {};
            ~customDataParser() = default;

            QVariant parseData(const QByteArray &data, const QVariantMap &config) override;
            QString parserName() const override { return "customDataParser"; }
            bool canParse(const QVariantMap &config) const override;
        
        private:
            QVariant parseCalendarData(const QByteArray &data, const QVariantMap &config);
            
        };
    }
}

#endif