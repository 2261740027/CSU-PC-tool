#ifndef IPAGECONTROLLER_H
#define IPAGECONTROLLER_H

#include <QObject>
#include <QString>
#include "page/PageFieldTable.h"

namespace page{

    class IpageController: public QObject {
        Q_OBJECT
    public :
        IpageController() = default;
        ~IpageController() = default;

        virtual QByteArray parpareQuerryValueData(QString name, QVariant value) = 0;
        virtual void setCmd(QString cmd) = 0;
        virtual QVariant getData(QString name) = 0;
        virtual void readlAllPage() = 0;
        virtual void setActive(bool state) = 0;
        virtual void upPageData(QByteArray data) = 0;
        virtual QMap<QString, pageMapField> &getPageTable() = 0;
    };

}



#endif // IPAGECONTROLLER_H
