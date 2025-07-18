#ifndef LOGMANAGER_H
#define LOGMANAGER_H

#include <QObject>
#include <QString>
#include "Singleton.h"
#include "alarmLogModel.h"

namespace Log
{
    enum LogType
    {
        AlarmLog = 1
    };

    class LogManager : public QObject, public Singleton<LogManager>
    {
        Q_OBJECT
        Q_PROPERTY(LogModel* alarmLogModel READ getAlarmLogModel CONSTANT)

    public:
        LogManager() = default;
        ~LogManager() = default;

        void addLog(void *logItem, LogType logType);
        void addLogs(const std::vector<alarmLogItem_t>& logItems, LogType logType);
        QString convertLogName(uint16_t index, LogType logType);
        
        // 获取报警日志模型
        LogModel* getAlarmLogModel() { return &_alarmLogModel; }


    private:
        LogModel _alarmLogModel;

    };
}


#endif
