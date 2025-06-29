#include "dbTab/querry/testpage1.h"

namespace dbTable
{
    QMap<QString, DBItem> makePage1Data()
    {
        return {
            {"U1", {"U1", "L001", 0.0, {{"unit", "V"}}}},
            {"I1", {"I1", "L002", 0.0, {{"unit", "A"}}}},
            {"T1", {"T1", "L003", 0.0, {{"unit", "℃"}}}}};
    }
}
