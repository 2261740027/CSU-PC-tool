#include "page/pageConfigAlarmPara.h"

namespace page
{
    pageConfigAlarmPara::pageConfigAlarmPara(pageMange *pageManager)
        : pageBase(configAlarmParaPageFieldList, configAlarmParaPageQuerryCmdList,pageManager, _configAlarmParaPageAttribute)
    {
        appendAlarmParaPageFieldList(configAlarmParaPageFieldWithRangeList);
    }

    void pageConfigAlarmPara::appendAlarmParaPageFieldList(QList<PageField> &pageFieldList)
    {
        QList<PageField> appendFieldList;

        for(auto &field : pageFieldList)
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
}
