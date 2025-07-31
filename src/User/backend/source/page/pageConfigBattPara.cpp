#include "pageConfigBattPara.h"

namespace page
{
    pageConfigBattPara::pageConfigBattPara(pageMange *pageManager)
        : pageBase(configBattParaPageFieldList, configBattParaPageQuerryCmdList,pageManager, _configBattParaPageAttribute)
    {
        appendBattParaWithRange(appendConfigBattParaWithRang);
        appendBattParaOption(appendConfigBattParaOption);
    }

    void pageConfigBattPara::appendBattParaWithRange(QList<PageField> &pageFieldList)
    {
        QList<PageField> appendFieldList;

        for(auto &field : pageFieldList)
        {
            for(int i = 0; i < 3; i++)
            {
                if(0x50 == field.group)
                {
                    appendFieldList.append(PageField(field.name + QString::number(i+1), field.valueType, field.length, field.group, field.category, (0x10 * i) + field.number, field.extra));
                    appendFieldList.append(PageField(field.name + QString::number(i+1) + "Max", field.valueType, field.length, field.group + 2, field.category, (0x10 * i) + field.number, field.extra));
                    appendFieldList.append(PageField(field.name + QString::number(i+1) + "Min", field.valueType, field.length, field.group + 4, field.category, (0x10 * i) + field.number, field.extra));
                }
            }
        }

        appendPageField(appendFieldList);
    }

    void pageConfigBattPara::appendBattParaOption(QList<PageField> &pageFieldList)
    {
        QList<PageField> appendFieldList;

        for(auto &field : pageFieldList)
        {
            for(int i = 0; i < 3; i++)
            {
               appendFieldList.append(PageField(field.name + QString::number(i+1), field.valueType, field.length, field.group, field.category, (0x10 * i) + field.number, field.extra));
            }
        }

        appendPageField(appendFieldList);
    }
}









