import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0

FluContentPage {

    title: qsTr("setting")

    Component.onCompleted: {
        // 连接信号到C++槽函数
        pageManager.notifyPageSwitch("setting");
    }

    Component.onDestruction: {

    }

    FluButton {
        text: "push"
        anchors.centerIn: parent
    }
}
