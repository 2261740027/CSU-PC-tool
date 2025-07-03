#ifndef PAGEMANG_H
#define PAGEMANG_H

#include <QString>
#include <QHash>
#include <QOBject>
// #include "page/IpageController.h"
#include "page/pageBase.h"

namespace page
{

    class pageMange : public QObject
    {
        Q_OBJECT
        Q_PROPERTY(QVariantMap pageData READ pageData NOTIFY pageDataChanged)

    public:
        pageMange();
        ~pageMange() = default;

        // Q_INVOKABLE void getPageData(QString name);                 // 获取单个数据
        Q_INVOKABLE void setItemData(QString name, QVariant value);   // 设置单个数据
        Q_INVOKABLE void notifyPageSwitch(const QString newPageName); // qml界面切换页面

        void refreshPage();          // 刷新当前页面所有数据
        QString currentPage() const; // 获取当前页面名称
        QVariantMap pageData();      // UI界面获取当前界面数据

    private:
        void updatePageData();                                            // 刷新mang向qml界面显示缓冲
        void registerPage(const QString &pageName, pageBase *controller); // 注册页面控制器

        QVariantMap _currPageData; // 当前页面数据
                                   // 全局数据
        QHash<QString, pageBase *> _pageHash;
        QString _currentPage = "main";

    signals:
        void toSerialSend(QByteArray data);
        void currentControllerChanged();
        void pageDataChanged(); // 通知UI界面数据发生变化

    public slots:
        void handleDataUpdate(QByteArray data); // 处理数据更新
    };

}

#endif
