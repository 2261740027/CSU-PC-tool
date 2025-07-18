#include "Log/logManager.h"

namespace Log
{
    void LogManager::addLog(void *logItem, LogType logType)
    {
        switch (logType)
        {
            case LogType::AlarmLog:
                //_alarmLogModel.addLog(*static_cast<alarmLogItem_t *>(logItem));
                break;
            default:
                break;
        }
    }

    void LogManager::addLogs(const std::vector<alarmLogItem_t>& logItems, LogType logType)
    {
        switch (logType)
        {
            case LogType::AlarmLog:
                _alarmLogModel.addLogs(logItems);
                break;
            default:
                break;
        }
    }

    QString LogManager::convertLogName(uint16_t index, LogType logType)
    {
        switch (logType)
        {
            case LogType::AlarmLog:
                return _alarmLogModel.convertLogName(index);
            default:
                return "";
        }
    }
    
}
