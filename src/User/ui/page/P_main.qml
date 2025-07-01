import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0


FluContentPage{

    title: qsTr("Main")


    FluButton {
        id:testButton
        anchors.centerIn: parent
        font:FluTextStyle.caption

        text: "send"
        onClicked: {
            if (serial.isOpen) {
                serial.send("test");
            }
        }
    }

    FluText {
        width:50
        height: 50
        x:300
        y:100
        z:50
        //text: pageManager.getPageData("Voltage")
        text:pageManager.pageData["Voltage"]
        //text: pageManager.testfunc()
    }

    FluFrame{
        // Layout.fillWidth: true
        // Layout.preferredHeight: 200
        //width: 400
        //height: 400
        padding: 10

        // Connections {
        //     target: serial

        //     function onReceivedRaw(data) {
        //         console.log("receivedata  "+ data )
        //     }
        // }

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
                font:FluTextStyle.caption

                text: serial.isOpen ? "close" : "open"
                checked:  serial.isOpen ? true : false


                onClicked: {
                    if (serial.isOpen) {
                        serial.disconnectPort()
                    } else {
                        serial.connectPort(comBox.currentText,
                                            parseInt(badRateBox.currentText),
                                            parseInt(dataBitsBox.currentText),
                                            stopBitsBox.currentIndex === 0 ? 1 : stopBitsBox.currentIndex === 1 ? 3 : 2,
                                            parityBox.currentIndex === 0 ? 0 : parityBox.currentIndex === 1 ? 2 : 3
                                            )
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
                font:FluTextStyle.caption

                editable: false
                model: serial.availablePorts
                onCurrentIndexChanged: {

                }
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
                font:FluTextStyle.caption

                editable: false
                model: ["9600", "115200"]
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
                font:FluTextStyle.caption

                editable: false
                model: ["5", "6", "7", "8"]
            }

            FluText {
                Layout.row: 3
                Layout.column: 0
                Layout.alignment: Qt.AlignVCenter
                font: FluTextStyle.Caption
                text: "stopBits:"
            }

            FluComboBox {
                id:stopBitsBox
                Layout.row: 3
                Layout.column: 1
                Layout.alignment: Qt.AlignVCenter
                Layout.preferredWidth: 100
                Layout.preferredHeight: 25
                font:FluTextStyle.caption

                editable: false
                model: ["1", "1.5", "2"]
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
                font:FluTextStyle.caption

                editable: false
                model: ["无", "奇校验", "偶校验"]
            }

        }
    }
}
