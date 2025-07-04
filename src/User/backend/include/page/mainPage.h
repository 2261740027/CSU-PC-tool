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

        void refreshPageAllData() override;

        QString handlePageDataUpdate(const QByteArray &data) override;

        void onFieldProcessed(const QString &fieldName, bool success) override;

    private:
        void queryCurrentField();
        void moveToNextField();

    private:
        bool _pageReflashState = false;
        int _currentFieldIndex = 0;
    };
}
