#ifndef PAGE1_H
#define PAGE1_H

#include <QObject>
#include "page/IpageController.h"
#include "page/PageFieldTable.h"

namespace page
{
    class page1:public IpageController
    {
    public:

        page1(){
            _pageField.loadFields(pageField);
        }

        void setValue(QString name, QVariant value) override{};
        void setCmd(QString cmd) override{};
        QVariant getData(QString name) override
        {
            return _pageField.uiGetValue(name);
        };
        void readlAllPage() override{};
        void setActive(bool state) override{};


        //数据解析
        void upPageData(QByteArray data) override{
            _pageField.fieldUpdated(data);
        }

         QMap<QString, pageMapField> &getPageTable() override{
            return _pageField.;
        }


    private:

        QList<PageField> pageField{
            { "Voltage", "short", 2, 0x50, 0x10 },
            { "Current", "short", 2, 0x50, 0x11 },
        };
        PageFieldTable _pageField;

    };
}

#endif // PAGE1_H
