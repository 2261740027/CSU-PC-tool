#include "page/pageInfoAlarmLog.h"
#include "page/pageMang.h"
#include "Log/logManager.h"
#include <QDebug>

namespace page
{
    infoAlarmLogPage::infoAlarmLogPage(pageMange *pageManager)
        : pageBase(infoAlarmLogPageFieldList, infoAlarmLogPageQuerryCmdList, pageManager, _infoAlarmLogPageAttribute)
    {

    }

    void infoAlarmLogPage::queryCurrentField()
    {
        
        if((_askAlarmLogIndex >= _totalAlarmLogNum) && (_totalAlarmLogNum != 0))
        {
            // 页面数据问询完毕
            Log::LogManager::getInstance()->getAlarmLogModel()->refreshLog();
            _pageReflashState = false;
            _totalAlarmLogNum = 0;
            _askAlarmLogIndex = 0;
            return;
        }
        
        QByteArray queryData;
        queryData.append(0x40);
        queryData.append(0x01);
        queryData.append(0x01);
        queryData.append((_askAlarmLogIndex + 1) & 0xFF);
        queryData.append((_askAlarmLogIndex >> 8) & 0xFF);
        

        if(_totalAlarmLogNum == 0)
        {
            queryData.append(0x01);
            queryData.append(static_cast<char>(0x00));
            _pageManager->sendRawData(queryData, SendRequestType::Log);
        }
        else 
        {
            uint32_t remainLogNum = _totalAlarmLogNum - (_askAlarmLogIndex);

            if(remainLogNum >= 20)
            {
                _logAskLength = 20;
                queryData.append(0x14);
                queryData.append(static_cast<char>(0x00));
                _pageManager->sendRawData(queryData, SendRequestType::Log);
            }
            else 
            {
                _logAskLength = remainLogNum;
                queryData.append(remainLogNum & 0xFF);
                queryData.append((remainLogNum >> 8) & 0xFF);
                _pageManager->sendRawData(queryData, SendRequestType::Log);
            }

        }

        qDebug() << "----> querryData:" << queryData.toHex();

    }

    void infoAlarmLogPage::onFieldProcessed(bool success)
    {
        if(_pageReflashState)
        {
            if(!success)
            {
                // 日志读取失败，重新开始问询
                _pageReflashState = false;
                _totalAlarmLogNum = 0;
                _askAlarmLogIndex = 0;
            }
            else
            {
                moveToNextField();
            }
        }
    }

    typedef struct logTime
    {
        short second;
        short minutes;
        short hour;
        short day;
        short month;
        short yuear;
    }logTime_t;

    pageDataUpdateResult_t infoAlarmLogPage::handlePageDataUpdate(const QByteArray &data)
    {
        uint32_t logsum = 0;
        pageDataUpdateResult_t result;
        result.num = 0;

        qDebug() << data.toHex();

        if(data.size() < 15)
        {
            return result;
        }
        else
        {
            // 获取总日志条数
            if(_totalAlarmLogNum == 0)
            {
                Log::LogManager::getInstance()->getAlarmLogModel()->clearLogs();
                _totalAlarmLogNum = ((data[2] << 8) & 0xFF00) | data[1] & 0xFF;
            }
            else  // 解析日志
            {
                _askAlarmLogIndex += _logAskLength;
                uint16_t eventId = 0;

                uint32_t logSum = (data.size() - 3) / 12;
                result.num = logSum;
                qDebug() << "----> recvLogsum:" << logSum;

                std::vector<Log::alarmLogItem_t> logItems;
                logItems.reserve(logSum);

                for(int i = 0; i < logSum; i ++)
                {
                    Log::alarmLogItem_t alarmLogItem;
                    uint8_t dataOffset = 3;
                    alarmLogItem.eventIndex = ((data[(12*i) +1 +dataOffset] << 8) & 0xFF00) | (data[(12*i) +dataOffset] & 0xFF);
                    dataOffset += 4;
                    alarmLogItem.status = (data[(12*i) +1 + dataOffset] & 0x80) >> 7;
                    eventId = ((data[(12*i) +1 + dataOffset] & 0x7F) << 9) | (data[(12*i) + dataOffset] & 0x7F) | ((data[(12*i) + dataOffset] & 0x80) << 1);
                    alarmLogItem.eventName = Log::LogManager::getInstance()->convertLogName(eventId, Log::LogType::AlarmLog);
                    dataOffset += 2;
                    alarmLogItem.timeSecond = data[(12*i) + dataOffset];
                    alarmLogItem.timeMinutes = data[(12*i) + 1 + dataOffset];
                    alarmLogItem.timeHour = data[(12*i) + 2 + dataOffset];
                    alarmLogItem.timeDay = data[(12*i) + 3 + dataOffset];
                    alarmLogItem.timeMonth = data[(12*i) + 4 + dataOffset];
                    alarmLogItem.timeYear = data[(12*i) + 5 + dataOffset];

                    logItems.push_back(alarmLogItem);

                    // qDebug() << "----> eventIndex:" << alarmLogItem.eventIndex;
                    // //qDebug() << "----> csuId:" << alarmLogItem.status;
                    // qDebug() << "----> status:" << alarmLogItem.status;
                    // qDebug() << "----> eventId:" << alarmLogItem.eventId;
                    // qDebug() << "----> recvTime:" << alarmLogItem.timeSecond << ":" << alarmLogItem.timeMinutes << ":" << alarmLogItem.timeHour << ":" << alarmLogItem.timeDay << ":" << alarmLogItem.timeMonth << ":" << alarmLogItem.timeYear;

                }

                // 批量添加日志
                Log::LogManager::getInstance()->addLogs(logItems, Log::LogType::AlarmLog);

            }

        }

        return result;
    }
}
