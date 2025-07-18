#ifndef PAGEINFOALARMLOG_H
#define PAGEINFOALARMLOG_H

#include "pageBase.h"

namespace page
{

    class pageMange;

    static QList<PageField> infoAlarmLogPageFieldList = {
    };

    const static QList<QByteArray> infoAlarmLogPageQuerryCmdList = {
    };

    class infoAlarmLogPage : public pageBase
    {
        Q_OBJECT
    public:
        infoAlarmLogPage(pageMange *pageManager);
        ~infoAlarmLogPage() = default;

        pageDataUpdateResult_t handlePageDataUpdate(const QByteArray &data) override;


    private:
        static QList<PageField> &initAcInfoPageFieldList();

        virtual void onFieldProcessed(bool success) override;
        virtual void queryCurrentField() override;

        static constexpr pageAttribute_t _infoAlarmLogPageAttribute = {
            .isRefresh = 1};

        uint32_t _askAlarmLogIndex = 0;            // 最大2000条
        uint32_t _totalAlarmLogNum = 0;
        uint32_t _logAskLength = 0;
    };
}



#endif
