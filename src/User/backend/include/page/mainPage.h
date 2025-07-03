#include "page/pageBase.h"
#include <QDebug>
#include <QTimer>
#include <QMap>

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
        mainPage(pageMange* pageManager);
        ~mainPage() = default;

        void refreshPageAllData() override;

        // 重写handlePageDataUpdate来处理数据接收
        void handlePageDataUpdate(const QByteArray &data) override;

    private slots:
        void onQueryTimeout();

    private:
        void queryCurrentField();
        void moveToNextField();

    private:
        bool _pageReflashState = false;
        QTimer* _queryTimer = nullptr;
        int _currentFieldIndex = 0;
        QMap<QString, int> _failureCount; // 每个字段的失败计数
        pageMange* _pageManager = nullptr;
    };
}
