import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0

FluContentPage {
    id: root
    title: qsTr("AC Info")

    Component.onCompleted: {
        //pageManager.notifyPageSwitch("ACInfo");
        createTab();
    }

    property var deviceData: pageManager.pageData || {}

    // 通用AC信息组件
    Component {
        id: acInfoComponent

        FluFrame {
            // 接收TabView传入的参数
            //property var argument

            // 从argument中获取传入的参数
            property string acNumber: argument ? argument.acNumber || "1" : "1"
            property string dataPrefix: argument ? argument.dataPrefix || "AC1" : "AC1"

            ColumnLayout{
                anchors.fill: parent
                Item{
                    Layout.fillWidth: true
                    Layout.preferredHeight: 100

                    RowLayout{
                        anchors.fill: parent
                        spacing: 50

                        // AC标题
                        FluText {
                            Layout.alignment: Qt.AlignCenter
                            text: "AC " + acNumber + ":"
                            font.pixelSize: 15
                            font.weight: Font.DemiBold
                            color: FluTheme.fontPrimaryColor
                        }

                        // 数据表格
                        GridLayout {
                            Layout.alignment: Qt.AlignCenter
                            columns: 11
                            rowSpacing: 6
                            columnSpacing: 8
                            Layout.fillWidth: true

                            // 表头
                            FluText { text: "Uab"; font.pixelSize: 13; Layout.alignment: Qt.AlignHCenter }
                            Item { Layout.fillWidth: true }
                            FluText { text: "Ubc"; font.pixelSize: 13; Layout.alignment: Qt.AlignHCenter }
                            Item { Layout.fillWidth: true }
                            FluText { text: "Uca"; font.pixelSize: 13; Layout.alignment: Qt.AlignHCenter }
                            Item { Layout.fillWidth: true }
                            FluText { text: "Freq"; font.pixelSize: 13; Layout.alignment: Qt.AlignHCenter }
                            Item { Layout.fillWidth: true }
                            FluText { text: "AC Breaker"; font.pixelSize: 13; Layout.alignment: Qt.AlignHCenter }
                            Item { Layout.fillWidth: true }
                            FluText { text: "SPD" + acNumber; font.pixelSize: 13; Layout.alignment: Qt.AlignHCenter }

                            // 电压行
                            DataCell { text: getACVoltage(dataPrefix + "Phase1Volt").toFixed(1); }
                            FluText { text: "V"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }
                            DataCell { text: getACVoltage(dataPrefix + "Phase2Volt").toFixed(1); }
                            FluText { text: "V"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }
                            DataCell { text: getACVoltage(dataPrefix + "Phase3Volt").toFixed(1); }
                            FluText { text: "V"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }
                            DataCell { text: getACFrequency(dataPrefix + "Freq").toFixed(2); }
                            FluText { text: "Hz"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }
                            DataCell { text: "on"; }
                            Item { Layout.fillWidth: true }
                            StatusDot { dotColor: "#4caf50" }

                            // 电流行
                            DataCell { text: getACCurrent(dataPrefix + "Phase1Curr").toFixed(1); }
                            FluText { text: "A"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }
                            DataCell { text: getACCurrent(dataPrefix + "Phase2Curr").toFixed(1); }
                            FluText { text: "A"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }
                            DataCell { text: getACCurrent(dataPrefix + "Phase3Curr").toFixed(1); }
                            FluText { text: "A"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }
                            Item { Layout.fillWidth: true; Layout.columnSpan: 5 }
                        }
                    }

                }
                Item{
                    Layout.fillWidth: true
                    Layout.preferredHeight: 100
                    //anchors.fill: parent
                    anchors.margins: 12

                    RowLayout{
                        anchors.fill: parent
                        spacing: 50

                        // AC标题
                        FluText {
                            Layout.alignment: Qt.AlignCenter
                            text: "AC " + acNumber + ":"
                            font.pixelSize: 15
                            font.weight: Font.DemiBold
                            color: FluTheme.fontPrimaryColor
                        }

                        // 数据表格
                        GridLayout {
                            Layout.alignment: Qt.AlignCenter
                            columns: 11
                            rowSpacing: 6
                            columnSpacing: 8
                            Layout.fillWidth: true

                            // 表头
                            FluText { text: "Uab"; font.pixelSize: 13; Layout.alignment: Qt.AlignHCenter }
                            Item { Layout.fillWidth: true }
                            FluText { text: "Ubc"; font.pixelSize: 13; Layout.alignment: Qt.AlignHCenter }
                            Item { Layout.fillWidth: true }
                            FluText { text: "Uca"; font.pixelSize: 13; Layout.alignment: Qt.AlignHCenter }
                            Item { Layout.fillWidth: true }
                            FluText { text: "Freq"; font.pixelSize: 13; Layout.alignment: Qt.AlignHCenter }
                            Item { Layout.fillWidth: true }
                            FluText { text: "AC Breaker"; font.pixelSize: 13; Layout.alignment: Qt.AlignHCenter }
                            Item { Layout.fillWidth: true }
                            FluText { text: "SPD" + acNumber; font.pixelSize: 13; Layout.alignment: Qt.AlignHCenter }

                            // 电压行
                            DataCell { text: getACVoltage(dataPrefix + "Phase1Volt").toFixed(1); }
                            FluText { text: "V"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }
                            DataCell { text: getACVoltage(dataPrefix + "Phase2Volt").toFixed(1); }
                            FluText { text: "V"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }
                            DataCell { text: getACVoltage(dataPrefix + "Phase3Volt").toFixed(1); }
                            FluText { text: "V"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }
                            DataCell { text: getACFrequency(dataPrefix + "Freq").toFixed(2); }
                            FluText { text: "Hz"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }
                            DataCell { text: "on"; }
                            Item { Layout.fillWidth: true }
                            StatusDot { dotColor: "#4caf50" }

                            // 电流行
                            DataCell { text: getACCurrent(dataPrefix + "Phase1Curr").toFixed(1); }
                            FluText { text: "A"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }
                            DataCell { text: getACCurrent(dataPrefix + "Phase2Curr").toFixed(1); }
                            FluText { text: "A"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }
                            DataCell { text: getACCurrent(dataPrefix + "Phase3Curr").toFixed(1); }
                            FluText { text: "A"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }
                            Item { Layout.fillWidth: true; Layout.columnSpan: 5 }
                        }
                    }

                }

                Item{
                    Layout.fillWidth: true
                    Layout.preferredHeight: 100
                    //anchors.fill: parent
                    anchors.margins: 12

                    RowLayout{
                        anchors.fill: parent
                        spacing: 50

                        // AC标题
                        FluText {
                            Layout.alignment: Qt.AlignCenter
                            text: "AC " + acNumber + ":"
                            font.pixelSize: 15
                            font.weight: Font.DemiBold
                            color: FluTheme.fontPrimaryColor
                        }

                        // 数据表格
                        GridLayout {
                            Layout.alignment: Qt.AlignCenter
                            columns: 11
                            rowSpacing: 6
                            columnSpacing: 8
                            Layout.fillWidth: true

                            // 表头
                            FluText { text: "Uab"; font.pixelSize: 13; Layout.alignment: Qt.AlignHCenter }
                            Item { Layout.fillWidth: true }
                            FluText { text: "Ubc"; font.pixelSize: 13; Layout.alignment: Qt.AlignHCenter }
                            Item { Layout.fillWidth: true }
                            FluText { text: "Uca"; font.pixelSize: 13; Layout.alignment: Qt.AlignHCenter }
                            Item { Layout.fillWidth: true }
                            FluText { text: "Freq"; font.pixelSize: 13; Layout.alignment: Qt.AlignHCenter }
                            Item { Layout.fillWidth: true }
                            FluText { text: "AC Breaker"; font.pixelSize: 13; Layout.alignment: Qt.AlignHCenter }
                            Item { Layout.fillWidth: true }
                            FluText { text: "SPD" + acNumber; font.pixelSize: 13; Layout.alignment: Qt.AlignHCenter }

                            // 电压行
                            DataCell { text: getACVoltage(dataPrefix + "Phase1Volt").toFixed(1); }
                            FluText { text: "V"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }
                            DataCell { text: getACVoltage(dataPrefix + "Phase2Volt").toFixed(1); }
                            FluText { text: "V"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }
                            DataCell { text: getACVoltage(dataPrefix + "Phase3Volt").toFixed(1); }
                            FluText { text: "V"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }
                            DataCell { text: getACFrequency(dataPrefix + "Freq").toFixed(2); }
                            FluText { text: "Hz"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }
                            DataCell { text: "on"; }
                            Item { Layout.fillWidth: true }
                            StatusDot { dotColor: "#4caf50" }

                            // 电流行
                            DataCell { text: getACCurrent(dataPrefix + "Phase1Curr").toFixed(1); }
                            FluText { text: "A"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }
                            DataCell { text: getACCurrent(dataPrefix + "Phase2Curr").toFixed(1); }
                            FluText { text: "A"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }
                            DataCell { text: getACCurrent(dataPrefix + "Phase3Curr").toFixed(1); }
                            FluText { text: "A"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }
                            Item { Layout.fillWidth: true; Layout.columnSpan: 5 }
                        }
                    }

                }

                Item{
                    Layout.fillWidth: true
                    Layout.preferredHeight: 100
                    //anchors.fill: parent
                    anchors.margins: 12

                    RowLayout{
                        anchors.fill: parent
                        spacing: 50

                        // AC标题
                        FluText {
                            Layout.alignment: Qt.AlignCenter
                            text: "AC " + acNumber + ":"
                            font.pixelSize: 15
                            font.weight: Font.DemiBold
                            color: FluTheme.fontPrimaryColor
                        }

                        // 数据表格
                        GridLayout {
                            Layout.alignment: Qt.AlignCenter
                            columns: 11
                            rowSpacing: 6
                            columnSpacing: 8
                            Layout.fillWidth: true

                            // 表头
                            FluText { text: "Uab"; font.pixelSize: 13; Layout.alignment: Qt.AlignHCenter }
                            Item { Layout.fillWidth: true }
                            FluText { text: "Ubc"; font.pixelSize: 13; Layout.alignment: Qt.AlignHCenter }
                            Item { Layout.fillWidth: true }
                            FluText { text: "Uca"; font.pixelSize: 13; Layout.alignment: Qt.AlignHCenter }
                            Item { Layout.fillWidth: true }
                            FluText { text: "Freq"; font.pixelSize: 13; Layout.alignment: Qt.AlignHCenter }
                            Item { Layout.fillWidth: true }
                            FluText { text: "AC Breaker"; font.pixelSize: 13; Layout.alignment: Qt.AlignHCenter }
                            Item { Layout.fillWidth: true }
                            FluText { text: "SPD" + acNumber; font.pixelSize: 13; Layout.alignment: Qt.AlignHCenter }

                            // 电压行
                            DataCell { text: getACVoltage(dataPrefix + "Phase1Volt").toFixed(1); }
                            FluText { text: "V"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }
                            DataCell { text: getACVoltage(dataPrefix + "Phase2Volt").toFixed(1); }
                            FluText { text: "V"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }
                            DataCell { text: getACVoltage(dataPrefix + "Phase3Volt").toFixed(1); }
                            FluText { text: "V"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }
                            DataCell { text: getACFrequency(dataPrefix + "Freq").toFixed(2); }
                            FluText { text: "Hz"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }
                            DataCell { text: "on"; }
                            Item { Layout.fillWidth: true }
                            StatusDot { dotColor: "#4caf50" }

                            // 电流行
                            DataCell { text: getACCurrent(dataPrefix + "Phase1Curr").toFixed(1); }
                            FluText { text: "A"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }
                            DataCell { text: getACCurrent(dataPrefix + "Phase2Curr").toFixed(1); }
                            FluText { text: "A"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }
                            DataCell { text: getACCurrent(dataPrefix + "Phase3Curr").toFixed(1); }
                            FluText { text: "A"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }
                            Item { Layout.fillWidth: true; Layout.columnSpan: 5 }
                        }
                    }

                }

            }
            
            

        }
    }

    FluFrame {
        anchors.fill: parent
        anchors.bottomMargin: 12
        anchors.rightMargin: 12

        FluTabView {
            id: tab_view
            anchors.fill: parent
            addButtonVisibility: false
            closeButtonVisibility: FluTabViewType.Never
            tabWidthBehavior: FluTabViewType.Equal
        }
    }

    function createTab() {
        // 创建8个AC信息标签页
        for(var i = 1; i <= 8; i++) {
            tab_view.appendTab("qrc:/image/favicon.ico", 
                              qsTr("AC Info " + i), 
                              acInfoComponent, 
                              {
                                  "acNumber": i.toString(),
                                  "dataPrefix": "AC" + i
                              })
        }
    }

    // 数据获取函数
    function getACVoltage(fieldName) {
        return (deviceData && deviceData[fieldName]) || 0;
    }

    function getACCurrent(fieldName) {
        return (deviceData && deviceData[fieldName]) || 0;
    }

    function getACFrequency(fieldName) {
        return (deviceData && deviceData[fieldName]) || 0;
    }

    // 数据单元格组件
    component DataCell: Rectangle {
        property string text: ""
        
        Layout.fillWidth: true
        Layout.preferredHeight: 26
        color: FluTheme.dark ? "#2d2d2d" : "#f8f9fa"
        border.color: FluTheme.dark ? "#555" : "#e0e0e0"
        border.width: 1
        radius: 2

        FluText {
            anchors.centerIn: parent
            text: parent.text
            font.pixelSize: 11
            color: FluTheme.fontPrimaryColor
        }
    }

    // 状态指示灯组件
    component StatusDot: Rectangle {
        property string dotColor: "#666"
        
        width: 16
        height: 16
        radius: 8
        color: dotColor
        border.color: FluTheme.dark ? "#888" : "#ccc"
        border.width: 1
    }
}