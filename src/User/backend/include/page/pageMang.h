#ifndef PAGEMANG_H
#define PAGEMANG_H

#include <QString>
#include <QHash>
#include <QOBject>
#include "page/IpageController.h"
#include "page/page1.h"

namespace page
{

    class pageMange : public QObject
    {
        Q_OBJECT
        Q_PROPERTY(QVariantMap pageData READ pageData NOTIFY pageDataChanged)
    public:
        pageMange()
        {
            static page1 page1Instance;
            registerPage("main", &page1Instance);
        }
        ~pageMange() = default;

        void registerPage(const QString &pageName, IpageController *controller);
        void switchPage(QString page);

        //QObject *currentController() const;

        Q_INVOKABLE QVariant getPageData(QString name);         //获取单个数据
        Q_INVOKABLE void setDeviceData(QString name, QVariant value); //设置单个数据

        QString currentPage() const;
        QVariantMap pageData(); // 返回所有数据的map

    private:

        void updatePageData();   //刷新mang向qml界面显示缓冲

        QVariantMap _currPageData;      //当前页面数据
        QHash<QString, IpageController *> _pageHash;
        QString _currentPage = "main";


    signals:
        void toSerialSend(QByteArray data);
        void currentControllerChanged(); 
        void pageDataChanged();

    public slots:
       
        void handleDataUpdate(QByteArray data);
    };

}

#endif
