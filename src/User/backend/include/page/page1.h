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

        QByteArray parpareQuerryValueData(QString name, QVariant value) override{
            QByteArray data;
            if (_pageField._valueMap.contains(name)) {
                data.append( _pageField._valueMap[name].group); // group
                data.append(_pageField._valueMap[name].category); // category
                data.append(_pageField._valueMap[name].number);
            }

            return data;
        };
        
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
            return _pageField.getValueMap();
        }


    private:

        QList<PageField> pageField{
            { "Voltage", "short", 2, 0x50, 0x10, 0x01 },
            { "Current", "short", 2, 0x50, 0x11, 0x01 },
        };
        PageFieldTable _pageField;

    };
}

#endif // PAGE1_H
