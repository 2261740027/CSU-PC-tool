#include "page/pageMang.h"
#include "page/mainPage.h"
#include "page/settingPage.h"
#include <QDebug>

namespace page
{

    pageMange::pageMange()
    {
        static mainPage page1Instance;
        registerPage("main", &page1Instance);

        static settingPage page2Instance;
        registerPage("setting", &page2Instance);
    }

    void pageMange::registerPage(const QString &pageName, pageBase *controller)
    {
        _pageHash.insert(pageName, controller);
    }

    QString pageMange::currentPage() const
    {
        return _currentPage;
    }

    void pageMange::handleDataUpdate(QByteArray data)
    {
        qDebug() << "recvData " + _currentPage;
        _pageHash[_currentPage]->handlePageDataUpdate(data);
        emit pageDataChanged();
    }

    QVariantMap pageMange::pageData()
    {

        QMap<QString, pageMapField> pageTable;

        pageTable = _pageHash[_currentPage]->getPageTable();

        QList<QString> keyList = pageTable.keys(); // 存放的就是QMap的key值
        for (int i = 0; i < keyList.size(); i++)
        {
            _currPageData[keyList[i]] = pageTable[keyList[i]].value;
        }

        return _currPageData;
    }

    void pageMange::setItemData(QString name, QVariant value)
    {
        QByteArray sendData;

        sendData = _pageHash[_currentPage]->setItemData(name, value);
        // emit
        emit toSerialSend(sendData);
    }

    void pageMange::notifyPageSwitch(const QString newPageName)
    {
        _currentPage = newPageName;
        qDebug() << "change page" + newPageName;
        _currPageData.clear();
    }
}
