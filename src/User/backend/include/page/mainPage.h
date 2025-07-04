#include "page/pageBase.h"
#include <QDebug>

namespace page
{
    class pageMange;

    const static QList<PageField> mainPageFieldList = {
        {"Voltage", "ushort", 2, 0x50, 0x10, 0x01},
        {"Current", "ushort", 2, 0x50, 0x11, 0x01}};

    class mainPage : public pageBase
    {
        Q_OBJECT
    public:
        mainPage(pageMange *pageManager);
        ~mainPage() = default;

        // 基类已经实现了所有轮询功能，只需要重写handlePageDataUpdate来添加特殊处理（如果需要）
        QString handlePageDataUpdate(const QByteArray &data) override;
    };
}
