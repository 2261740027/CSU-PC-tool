#include "dbTab/dbTableMang.h"
#include "dbTab/querry/testpage1.h"

namespace dbTable
{

    dbTableMang::dbTableMang()
    {
        static testQuerry testPage1;
        _tabMap[testPage1.getGroup()] = &testPage1;
    }

    void dbTableMang::setTabData(unsigned char group, unsigned char category, QVariant &data)
    {

        DataId dataId;
        dataId.field.number = group;
        dataId.field.category = category;
        

        if(_tabMap.contains(group))
        {
            Tab *tab = _tabMap[group];
            if(tab)
            {
                tab->setItemValue( dataId, data);
            }
        }
    }

}