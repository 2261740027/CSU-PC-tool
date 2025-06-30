#pragma once

#include "dbTab/dbTable.h"
#include "dbTab/dbTabQuerry.h"

namespace dbTable
{
    class testQuerry: public tabQuery
    {
        public:
            testQuerry();
            ~testQuerry() = default;
            QVariant getItemValue(const DataId& dataId) override;
            void setItemValue(const DataId& dataId, const QVariant wrData) override;
            QVariantMap toQMLTabData() const;

    };
}