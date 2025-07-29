#include "page/pageConfigSys.h"

namespace page
{
    pageConfigSys::pageConfigSys(pageMange *pageManager)
        : pageBase(configSysPageFieldList, configSysPageQuerryCmdList,pageManager, _configSysPageAttribute)
    {
        //initPageQuerryCmdList();
        appendPageFieldWithRange(configSysPageFieldWithRangeList);
        appendBattTempSensor(configSysPageBattTempList);
        appendManagementscreenconfig(configSysPageHmiConfigList);
    }

    void pageConfigSys::appendPageFieldWithRange(QList<PageField> &pageFieldList)
    {   
        QList<PageField> appendFieldList;

        for(const PageField &field : pageFieldList)
        {
            if(0x50 == field.group)
            {
                appendFieldList.append(field);
                appendFieldList.append(PageField(field.name + "Max", field.valueType, field.length, field.group + 2, field.category, field.number, field.extra));
                appendFieldList.append(PageField(field.name + "Min", field.valueType, field.length, field.group + 4, field.category, field.number, field.extra));
            }
        }
        
        appendPageField(appendFieldList);
    }

    void pageConfigSys::appendBattTempSensor(QList<PageField> &pageFieldList)
    {
        QList<PageField> appendFieldList;

        for(const PageField &field : pageFieldList)
        {
            for (int i = 0; i < 8; i++)
            {
                appendFieldList.append(PageField(field.name + QString::number(i+1), field.valueType, field.length, field.group, field.category, (0x10 * i) + field.number, field.extra));
            }
        }
        
        appendPageField(appendFieldList);
    }

    void pageConfigSys::appendManagementscreenconfig(QList<PageField> &pageFieldList)
    {
        QList<PageField> appendFieldList;

        for(const PageField &field : pageFieldList)
        {
            for(int i = 0; i < 3; i++)
            {
                if(0x50 == field.group)
                {
                    appendFieldList.append(PageField(field.name + QString::number(i+1), field.valueType, field.length, field.group, field.category, (0x10 * i) + field.number, field.extra));
                    appendFieldList.append(PageField(field.name + QString::number(i+1) + "Max", field.valueType, field.length, field.group + 2, field.category, (0x10 * i) + field.number, field.extra));
                    appendFieldList.append(PageField(field.name + QString::number(i+1) + "Min", field.valueType, field.length, field.group + 4, field.category, (0x10 * i) + field.number, field.extra));
                }
                else 
                {
                    appendFieldList.append(PageField(field.name + QString::number(i+1), field.valueType, field.length, field.group, field.category, (0x10 * i) + field.number, field.extra));
                }
            }
        }

        appendPageField(appendFieldList);
    }
}
