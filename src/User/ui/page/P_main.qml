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

        console.log("parent.width:" + parent.width)
        console.log("parent.height:" + parent.height)
    }

    Component.onDestruction: {

    }

    FluMultilineTextBox {
        id: textViewer
        property alias content: textViewer.text

        // 设置为只读模式
        readOnly: true

        // 样式设置 - 使用anchors填充剩余空间
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: rightFrame.left
        anchors.bottomMargin: 12 // 底部留出间距
        anchors.rightMargin: 12  // 与右侧面板留出间距

        // 允许选择文本但不允许编辑
        selectByMouse: true

        // 自动换行
        wrapMode: Text.WordWrap

        // 示例文本
        //text: "这是一个文本浏览框\n可以显示多行文本内容\n支持滚动和文本选择"

        // 滚动条样式
        ScrollBar.vertical: FluScrollBar {
            anchors.right: parent.right
            anchors.rightMargin: 2
        }
    }

    FluFrame {
        id: rightFrame
        
        padding: 8
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.rightMargin: 12
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
                checked: serial.isOpen
                
                clickListener: function() {
                }

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
                currentIndex: serial.currentBaudRateIndex
                onCurrentIndexChanged: {
                    if (currentIndex !== serial.currentBaudRateIndex) {
                        serial.setCurrentBaudRateIndex(currentIndex)
                    }
                }
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
                currentIndex: serial.currentDataBitsIndex
                onCurrentIndexChanged: {
                    if (currentIndex !== serial.currentDataBitsIndex) {
                        serial.setCurrentDataBitsIndex(currentIndex)
                    }
                }
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
                currentIndex: serial.currentStopBitsIndex
                onCurrentIndexChanged: {
                    if (currentIndex !== serial.currentStopBitsIndex) {
                        serial.setCurrentStopBitsIndex(currentIndex)
                    }
                }
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
                currentIndex: serial.currentParityIndex
                onCurrentIndexChanged: {
                    if (currentIndex !== serial.currentParityIndex) {
                        serial.setCurrentParityIndex(currentIndex)
                    }
                }
            }
        }
    }
}
