#include "page/pageConfigSys.h"

namespace page
{
    pageConfigSys::pageConfigSys(pageMange *pageManager)
        : pageBase(configSysPageFieldList, configSysPageQuerryCmdList,pageManager, _configSysPageAttribute)
    {
        //initPageQuerryCmdList();
    }

    // void pageConfigSys::initPageQuerryCmdList()
    // {
    //     // 不能插入未定义的值
    // }

    // pageDataUpdateResult_t pageConfigSys::handlePageDataUpdate(const QByteArray &data)
    // {
    //     return pageBase::handlePageDataUpdate(data);
    // }
}