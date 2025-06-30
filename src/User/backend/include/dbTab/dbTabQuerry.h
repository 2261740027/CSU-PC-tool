#ifndef DBTABQUERRY_H
#define DBTABQUERRY_H

#include "dbTab/dbTable.h"

namespace dbTable
{
    class tabQuery: public Tab
    {
        public:
            tabQuery(const Detail& detail)
            :Tab(detail)
            {
                // Constructor implementation
            }
            ~tabQuery() = default;
    };
}

#endif
