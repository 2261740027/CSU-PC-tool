#include "page/pageBase.h"
#include <QDebug>

namespace page
{
    class pageMange;

    const static QList<PageField> settingPageFieldList = {
        {"bus1", "ushort", 2, 0x60, 0x10, 0x01},
        {"bus2", "ushort", 2, 0x60, 0x11, 0x01}};

    class settingPage : public pageBase
    {
        Q_OBJECT
    public:
        settingPage(pageMange *pageManager);
        ~settingPage() = default;

        // 基类已经实现了所有轮询功能，只需要重写handlePageDataUpdate来添加特殊处理（如果需要）
        QString handlePageDataUpdate(const QByteArray &data) override;
    };
}
