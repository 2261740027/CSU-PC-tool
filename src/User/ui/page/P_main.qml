import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0

FluContentPage {

    title: qsTr("main")

    Component.onCompleted: {
        // 连接信号到C++槽函数
        pageManager.notifyPageSwitch("main")
        pageManager.startAutoRefresh();
    }

    Component.onDestruction: {

    }

    FluFrame {

        padding: 10

        GridLayout {

            columns: 2
            rowSpacing: 5
            columnSpacing: 25

            FluToggleButton {
                Layout.row: 0
                Layout.column: 0
                Layout.alignment: Qt.AlignVCenter
                Layout.preferredWidth: 60
                Layout.preferredHeight: 25
                font: FluTextStyle.caption

                text: serial.isOpen ? "close" : "open"
                checked: serial.isOpen ? true : false

                onClicked: {
                    if (serial.isOpen) {
                        serial.disconnectPort();
                    } else {
                        serial.connectPort(comBox.currentText, parseInt(badRateBox.currentText),
                                           parseInt(dataBitsBox.currentText),
                                           stopBitsBox.currentIndex === 0 ? 1 : stopBitsBox.currentIndex === 1 ? 3 : 2,
                                           parityBox.currentIndex === 0 ? 0 : parityBox.currentIndex === 1 ? 2 : 3);
                    }
                }
            }

            FluComboBox {
                id: comBox

                Layout.row: 0
                Layout.column: 1
                Layout.alignment: Qt.AlignVCenter
                Layout.preferredWidth: 100
                Layout.preferredHeight: 25
                font: FluTextStyle.caption

                editable: false
                enabled: !serial.isOpen
                model: serial.availablePorts
                currentIndex: serial.isOpen && serial.currentPortIndex >= 0 ? serial.currentPortIndex : 0
                onCurrentIndexChanged: {}
            }

            FluText {
                Layout.row: 1
                Layout.column: 0
                Layout.alignment: Qt.AlignVCenter
                font: FluTextStyle.Caption
                text: "badRate:"
            }

            FluComboBox {
                id: badRateBox
                Layout.row: 1
                Layout.column: 1
                Layout.alignment: Qt.AlignVCenter
                Layout.preferredWidth: 100
                Layout.preferredHeight: 25
                font: FluTextStyle.caption

                editable: false
                enabled: !serial.isOpen
                model: ["9600", "115200"]
                currentIndex: serial.isOpen ? serial.currentBaudRateIndex : 1
            }

            FluText {
                Layout.row: 2
                Layout.column: 0
                Layout.alignment: Qt.AlignVCenter
                font: FluTextStyle.Caption
                text: "dataBits:"
            }

            FluComboBox {
                id: dataBitsBox
                Layout.row: 2
                Layout.column: 1
                Layout.alignment: Qt.AlignVCenter
                Layout.preferredWidth: 100
                Layout.preferredHeight: 25
                font: FluTextStyle.caption

                editable: false
                enabled: !serial.isOpen
                model: ["5", "6", "7", "8"]
                currentIndex: serial.isOpen ? serial.currentDataBitsIndex : 3
            }

            FluText {
                Layout.row: 3
                Layout.column: 0
                Layout.alignment: Qt.AlignVCenter
                font: FluTextStyle.Caption
                text: "stopBits:"
            }

            FluComboBox {
                id: stopBitsBox
                Layout.row: 3
                Layout.column: 1
                Layout.alignment: Qt.AlignVCenter
                Layout.preferredWidth: 100
                Layout.preferredHeight: 25
                font: FluTextStyle.caption

                editable: false
                enabled: !serial.isOpen
                model: ["1", "1.5", "2"]
                currentIndex: serial.isOpen ? serial.currentStopBitsIndex : 0
            }

            FluText {
                Layout.row: 4
                Layout.column: 0
                Layout.alignment: Qt.AlignVCenter
                font: FluTextStyle.Caption
                text: "parity:"
            }

            FluComboBox {
                id: parityBox
                Layout.row: 4
                Layout.column: 1
                Layout.alignment: Qt.AlignVCenter
                Layout.preferredWidth: 100
                Layout.preferredHeight: 25
                font: FluTextStyle.caption

                editable: false
                enabled: !serial.isOpen
                model: ["none", "odd", "even"]
                currentIndex: serial.isOpen ? serial.currentParityIndex : 0
            }
        }
    }
}
