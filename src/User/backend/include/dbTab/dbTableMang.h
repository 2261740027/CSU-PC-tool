#ifndef DBTABLEMANG_H
#define DBTABLEMANG_H

#include <QMap>
#include "dbTab/dbTable.h"

namespace dbTable
{
class dbTableMang {

public:
    dbTableMang();
    ~dbTableMang() = default;

    QMap<unsigned short,DBItem> &findTab(unsigned char group);
    void setTabData(unsigned char group, unsigned char category, QVariant &data);
    //void readTabData(unsigned char group, unsigned char category, unsigned char dataId, DBItem &item);

protected:
    QMap<unsigned char,Tab*> _tabMap;

};
}

#endif
