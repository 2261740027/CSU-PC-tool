#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QTranslator>
#include <QIcon>
#include "SerialController.h"
#include "page/pageMang.h"
#include "Log/logManager.h"
#include "Log/alarmLogModel.h"

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QGuiApplication app(argc, argv);

    // 设置应用程序图标（任务管理器中显示的图标）
    app.setWindowIcon(QIcon(":/image/Ace.ico"));
    
    // 注册LogModel类型到QML系统
    qmlRegisterType<Log::LogModel>("Log", 1, 0, "LogModel");

    QTranslator translator;
    const QStringList uiLanguages = QLocale::system().uiLanguages();
    for (const QString &locale : uiLanguages) {
        const QString baseName = "fluentUiPcTool_" + QLocale(locale).name();
        if (translator.load("./i18n/"+ baseName)) {
            app.installTranslator(&translator);
            break;
        }
    }
    QQmlApplicationEngine engine;

    //qmlRegisterType<SerialController>("Serial", 1, 0, "SerialController");
    SerialController *serialControllerI = SerialController::getInstance();
    page::pageMange *pageMangeI = new page::pageMange();
    Log::LogManager *logManagerI = Log::LogManager::getInstance();
    
    QObject::connect(serialControllerI, &SerialController::notificationsPageRecvData, pageMangeI, &page::pageMange::handleDataUpdate);
    QObject::connect(pageMangeI, &page::pageMange::toSerialSend, serialControllerI, &SerialController::handlePageSendData);

    engine.rootContext()->setContextProperty("pageManager", pageMangeI);
    engine.rootContext()->setContextProperty("serial", serialControllerI);
    engine.rootContext()->setContextProperty("logManager", logManagerI);

    const QUrl url(QStringLiteral("qrc:/App.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
        &app, [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
