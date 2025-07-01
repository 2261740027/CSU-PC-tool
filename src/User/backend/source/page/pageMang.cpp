#include "page/pageMang.h"
#include "QDebug"

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
    }

    QVariant pageMange::getPageData(QString name)
    {
        IpageController * currentPage;
        currentPage = _pageHash[_currentPage];
        //currentPage->getData(name);
        //currentPage->fieldTable()

        return currentPage->getData(name);
    }

    QVariantMap pageMange::pageData() const {
        QVariantMap map;
        // 假设你有字段名列表
        for (const QString& key : ) {
            map[key] = getPageData(key);
        }
        return map;
    }

}
