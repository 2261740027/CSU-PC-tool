#include "Log/alarmLogModel.h"

namespace Log
{
    LogModel::LogModel(QObject *parent) : QAbstractListModel(parent) {}
    
    LogModel::~LogModel() {
        beginResetModel();
        _logs.clear();
        endResetModel();
    }

    int LogModel::rowCount(const QModelIndex &parent) const
    {
        return _logs.size();
    }

    QVariant LogModel::data(const QModelIndex &index, int role) const
    {
        if (!index.isValid() || index.row() >= _logs.size())
            return QVariant();

        alarmLogItem item;
        {
            if (index.row() >= _logs.size())
            {
                return QVariant();
            }

            item = _logs[index.row()];
        }

        switch (role)
        {
        case EventIndexRole:
            return item.eventIndex;
        case StatusRole:
            return item.status;
        case EventNameRole:
            return item.eventName;
        case TimeSecondRole:
            return item.timeSecond;
        case TimeMinutesRole:
            return item.timeMinutes;
        case TimeHourRole:
            return item.timeHour;
        case TimeDayRole:
            return item.timeDay;
        case TimeMonthRole:
            return item.timeMonth;
        case TimeYearRole:
            return item.timeYear;
        default:
            return QVariant();
        }
    }

    QHash<int, QByteArray> LogModel::roleNames() const
    {
        QHash<int, QByteArray> roles;
        roles[EventIndexRole] = "eventIndex";
        roles[StatusRole] = "status";
        roles[EventNameRole] = "eventName";
        roles[TimeSecondRole] = "timeSecond";
        roles[TimeMinutesRole] = "timeMinutes";
        roles[TimeHourRole] = "timeHour";
        roles[TimeDayRole] = "timeDay";
        roles[TimeMonthRole] = "timeMonth";
        roles[TimeYearRole] = "timeYear";
        return roles;
    }

    void LogModel::addLogs(const std::vector<alarmLogItem_t>& logItems)
    {
        if (logItems.empty())
            return;



        _logs.insert(_logs.end(), logItems.begin(), logItems.end());
    }

    void LogModel::clearLogs()
    {
        _logs.clear();
    }

    void LogModel::refreshLog()
    {
        beginResetModel();
        endResetModel();
    }

    QString LogModel::convertLogName(uint16_t index)
    {
        if(alarmItemMap.contains(index))
        {
            return alarmItemMap[index];
        }
        else
        {
            return QString::number(index);
        }
    }

}
