#include "page/pageMang.h"
#include <QDebug>

namespace page
{

    void pageMange::switchPage(QString page)
    {
        IpageController *currPagController = _pageHash[_currentPage];
        currPagController->setActive(false);

        IpageController *PagController = _pageHash[page];
        PagController->setActive(true);

        _currentPage = page;
        emit currentControllerChanged();
    }

    void pageMange::registerPage(const QString &pageName, IpageController *controller)
    {
        _pageHash.insert(pageName, controller);
        if (pageName == _currentPage)
        {
            emit currentControllerChanged();
        }
    }

    QString pageMange::currentPage() const
    {
        return _currentPage;
    }

    void pageMange::handleDataUpdate(QByteArray data)
    {
        qDebug() << "recvData " + _currentPage;
        _pageHash[_currentPage]->upPageData(data);
        emit pageDataChanged();
    }

    QVariant pageMange::getPageData(QString name)
    {
        IpageController * currentPage;
        currentPage = _pageHash[_currentPage];
        //currentPage->getData(name);
        //currentPage->fieldTable()

        return currentPage->getData(name);
    }

    QVariantMap pageMange::pageData() {

        QMap<QString, pageMapField> pageTable;

        pageTable = _pageHash[_currentPage]->getPageTable();
        
        QList<QString> keyList = pageTable.keys(); // 存放的就是QMap的key值
        for(int i=0;i<keyList.size();i++)
        {
            _currPageData[keyList[i]] = pageTable[keyList[i]].value;
        }

        return _currPageData;

    }

    void pageMange::setDeviceData(QString name, QVariant value)
    {
        QByteArray sendData;

        sendData = _pageHash[_currentPage]->parpareQuerryValueData(name,value);
        //emit 
        emit toSerialSend(sendData);
    }

}
