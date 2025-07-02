#ifndef PAGEFIELDTABLE_H
#define PAGEFIELDTABLE_H

#include <QObject>
#include <QVariant>
#include <QMap>
#include <QList>
#include <QByteArray>

namespace page {

    struct PageField {
        QString name;             // 逻辑名（例如 "Voltage"）
        QString valueType;
        unsigned short length;
        unsigned short group;
        unsigned short category;
        unsigned short number;
    };


    struct pageMapField {
        QString valueType;
        unsigned short length;
        unsigned short group;
        unsigned short category;
        unsigned short number;
        QVariant value;
    };


    class PageFieldTable : public QObject {
        Q_OBJECT
    public:
        explicit PageFieldTable(QObject* parent = nullptr);

        void loadFields(const QList<PageField>& fields);

        QVariant uiGetValue(const QString& name) const;           // ui界面获取数据
        void uiSetValue(const QString& name, const QVariant val); //发送设置数据

        void fieldUpdated(QByteArray &value);
        QMap<QString, pageMapField> &getValueMap()
        {
            return _valueMap;
        }


    // signals:
    //     void fieldUpdated(const QString& name, const QVariant& val); // 通知UI或协议发送器
        QMap<QString, pageMapField> _valueMap;     // name → value
        QMap<unsigned short, QString> _reValueMap; // (group|category) ----> name
        
    private:
        
    };
}



#endif // PAGEFIELDTABLE_H
