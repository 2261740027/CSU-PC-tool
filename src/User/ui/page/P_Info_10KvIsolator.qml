import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0

FluContentPage {

    title: qsTr("10Kv Isolator")

    property var colors: [FluColors.Yellow, FluColors.Orange, FluColors.Red, FluColors.Magenta, FluColors.Purple, FluColors.Blue, FluColors.Teal, FluColors.Green]

    Component.onCompleted: {
        // 连接信号到C++槽函数
        pageManager.notifyPageSwitch("info10KvIsolator");
        createTab();
    }

    Component.onDestruction: {}

    ColumnLayout {
        anchors.fill: parent
        anchors.topMargin: 4
        anchors.bottomMargin: 4
        spacing: 8

        FluFrame {
            Layout.fillWidth: true
            Layout.preferredHeight: 98

            RowLayout {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 8

                FluText {
                    text: "10Kv AC:"
                    font.pixelSize: 15
                    font.weight: Font.DemiBold
                    color: FluTheme.fontPrimaryColor
                    Layout.alignment: Qt.AlignVCenter
                    Layout.rightMargin: 12
                    Layout.leftMargin: 8
                }

                GridLayout {
                    columns: 9
                    rowSpacing: 6
                    columnSpacing: 8
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter

                    // 数据变量，更易维护
                    readonly property real uab: (deviceData && deviceData.AC1Phase1Volt || 0)
                    readonly property real ubc: (deviceData && deviceData.AC1Phase2Volt || 0)
                    readonly property real uca: (deviceData && deviceData.AC1Phase3Curr || 0)
                    readonly property real freq: (deviceData && deviceData.AC1Phase1Curr || 0)
                    //readonly property real breaker: (deviceData && deviceData.AC1Phase1Curr || 0)
                    readonly property real row2_val1: (deviceData && deviceData.AC1Phase1Volt || 0)
                    readonly property real row2_val2: (deviceData && deviceData.AC1Phase2Curr || 0)
                    readonly property real row2_val3: (deviceData && deviceData.AC1Phase3Curr || 0)

                    // Headers
                    FluText { text: "Uab"; font.pixelSize: 13; Layout.alignment: Qt.AlignHCenter }
                    Item { Layout.fillWidth: true }
                    FluText { text: "Ubc"; font.pixelSize: 13; Layout.alignment: Qt.AlignHCenter }
                    Item { Layout.fillWidth: true }
                    FluText { text: "Uca"; font.pixelSize: 13; Layout.alignment: Qt.AlignHCenter }
                    Item { Layout.fillWidth: true }
                    FluText { text: "Freq"; font.pixelSize: 13; Layout.alignment: Qt.AlignHCenter }
                    Item { Layout.fillWidth: true }
                    FluText { text: "AC Breaker"; font.pixelSize: 13; Layout.alignment: Qt.AlignHCenter }

                    // Row 1 - 使用变量和简化属性
                    FluTextBox { text: uab.toFixed(2); Layout.fillWidth: true; Layout.fillHeight: true; readOnly: true; font.pixelSize: 11 }
                    FluText { text: "kV"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }
                    FluTextBox { text: ubc.toFixed(2); Layout.fillWidth: true; Layout.fillHeight: true; readOnly: true; font.pixelSize: 11 }
                    FluText { text: "kV"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }
                    FluTextBox { text: uca.toFixed(2); Layout.fillWidth: true; Layout.fillHeight: true; readOnly: true; font.pixelSize: 11 }
                    FluText { text: "kV"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }
                    FluTextBox { text: freq.toFixed(2); Layout.fillWidth: true; Layout.fillHeight: true; readOnly: true; font.pixelSize: 11 }
                    FluText { text: "Hz"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }
                    FluTextBox { text: breaker.toFixed(2); Layout.fillWidth: true; Layout.fillHeight: true; readOnly: true; font.pixelSize: 11 }

                    // Row 2
                    FluTextBox { text: row2_val1.toFixed(2); Layout.fillWidth: true; Layout.fillHeight: true; readOnly: true; font.pixelSize: 11 }
                    FluText { text: "A"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }
                    FluTextBox { text: row2_val2.toFixed(2); Layout.fillWidth: true; Layout.fillHeight: true; readOnly: true; font.pixelSize: 11 }
                    FluText { text: "A"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }
                    FluTextBox { text: row2_val3.toFixed(2); Layout.fillWidth: true; Layout.fillHeight: true; readOnly: true; font.pixelSize: 11 }
                    FluText { text: "A"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }
                }
            }
        }
    }


    

    // Component{
    //     id:info10KvIsolatorTab1
    //     Rectangle{
    //         anchors.fill: parent
    //     }
    // }

    // function createTab(){
    //     tab_view.appendTab("qrc:/image/favicon.ico",qsTr("10Kv AC Isolator Info1"),info10KvIsolatorTab1,{})
    //     tab_view.appendTab("qrc:/image/favicon.ico",qsTr("10Kv AC Isolator Info2"),info10KvIsolatorTab1,{})
    // }

    // FluFrame{
    //     anchors.fill: parent
    //     anchors.bottomMargin: 12
    //     anchors.rightMargin: 12

    //     //padding: 8
    //     FluTabView{
    //         id:tab_view
    //         addButtonVisibility: false
    //         closeButtonVisibility: FluTabViewType.Never
    //         tabWidthBehavior: FluTabViewType.Equal
    //         onNewPressed:{
    //             createTab()
    //         }
    //     }
    // }

}
