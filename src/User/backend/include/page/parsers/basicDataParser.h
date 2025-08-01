#ifndef BASICDATAPARSER_H
#define BASICDATAPARSER_H

#include "IDataParser.h"
#include "singleton.h"

namespace page{

    namespace parsers {

        class basicDataParser : public IDataParser , public Singleton<basicDataParser>
        {
            Q_OBJECT
        public:
            explicit basicDataParser(QObject *parent = nullptr): IDataParser(parent) {};

            QVariant parseData(const QByteArray &data, const QVariantMap &config) override;
            QString parserName() const override { return "basicDataParser"; }
            bool canParse(const QVariantMap &config) const override;

        private:
            QVariant parseInteger(const QByteArray &data, const QVariantMap &config);
            QVariant parseFloat(const QByteArray &data, const QVariantMap &config);
            QVariant parseBoolean(const QByteArray &data, const QVariantMap &config);
            QVariant parseString(const QByteArray &data, const QVariantMap &config);
        };

    }
}

#endif