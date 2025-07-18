import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0

FluContentPage {

    title: qsTr("Alarm Log")

    Component.onCompleted: {
        // 连接信号到C++槽函数
        pageManager.notifyPageSwitch("alarmLog");
    }

    Component.onDestruction: {}

    FluFrame {
        anchors.fill: parent
        anchors.bottomMargin: 8
        anchors.topMargin: 4
        anchors.rightMargin: 4

        ListView {
            id: alarmLogListView
            anchors.fill: parent
            anchors.margins: 20
            model: logManager.alarmLogModel

            // 添加垂直滚动条
            ScrollBar.vertical: FluScrollBar {
                anchors.right: parent.right
                anchors.rightMargin: 2
            }

            delegate: FluRectangle {
                height: 32
                radius: 8
                color: FluTheme.dark ? Qt.rgba(1, 1, 1, 0.05) : Qt.rgba(0, 0, 0, 0.05)

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 24

                    FluText {
                        text: "Index: " + model.eventIndex
                        font: FluTextStyle.BodyStrong
                        //Layout.preferredWidth: 80
                        Layout.minimumWidth: 60
                        Layout.fillWidth: true
                    }

                    FluText {
                        text: "Status: " + (model.status === 1 ? "Alarm" : "Normal")
                        color: model.status === 1 ? "#d13438" : "#107c10"
                        font: FluTextStyle.Body
                        Layout.minimumWidth: 100
                        Layout.fillWidth: true
                    }

                    FluText {
                        text: "ID: " + model.eventName
                        font: FluTextStyle.Body
                        Layout.minimumWidth: 200
                        Layout.fillWidth: true
                    }

                    FluText {
                        text: "Time: " + (model.timeYear+2000) + "/" + (model.timeMonth < 10 ? "0" + model.timeMonth : model.timeMonth) + "/" + (model.timeDay < 10 ? "0" + model.timeDay : model.timeDay) + " " + (model.timeHour < 10 ? "0" + model.timeHour : model.timeHour) + ":" + (model.timeMinutes < 10 ? "0" + model.timeMinutes : model.timeMinutes) + ":" + (model.timeSecond < 10 ? "0" + model.timeSecond : model.timeSecond)
                        font: FluTextStyle.Body
                        Layout.minimumWidth: 220
                        Layout.fillWidth: true
                    }
                }
            }

            FluText {
                anchors.centerIn: parent
                text: qsTr("No alarm logs available")
                visible: alarmLogListView.count === 0
                //font: FluTextStyle.BodyLarge
                color: FluTheme.dark ? Qt.rgba(1, 1, 1, 0.6) : Qt.rgba(0, 0, 0, 0.6)
            }
        }
    }
}
