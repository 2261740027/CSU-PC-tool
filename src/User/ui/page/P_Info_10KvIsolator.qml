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
        //createTab();
        gc();
    }

    Component.onDestruction: {}

    property var deviceData: pageManager.pageData || {}

    // 数据变量，更易维护
    readonly property real uab: (deviceData && deviceData.AC1Phase1Voltage10Kv || 0)
    readonly property real ubc: (deviceData && deviceData.AC1Phase2Voltage10Kv || 0)
    readonly property real uca: (deviceData && deviceData.AC1Phase3Voltage10Kv || 0)
    readonly property real freq: (deviceData && deviceData.AcFrequency10Kv || 0)
    readonly property string breaker: getBreakerStatus(deviceData && deviceData.ACBreaker10Kv || 0)
    readonly property real iab: (deviceData && deviceData.AC1Phase1Current10Kv || 0)
    readonly property real ibc: (deviceData && deviceData.AC1Phase2Current10Kv || 0)
    readonly property real ica: (deviceData && deviceData.AC1Phase3Current10Kv || 0)

    readonly property real prTempStatus: (deviceData && deviceData.TransformerPriTempStatus || 0)
    readonly property real prAphaseTemp: (deviceData && deviceData.TransformerPriTempA || 0)
    readonly property real prBphaseTemp: (deviceData && deviceData.TransformerPriTempB || 0)
    readonly property real prCphaseTemp: (deviceData && deviceData.TransformerPriTempC || 0)
    readonly property real secTempStatus: (deviceData && deviceData.TransformerSecTempStatus || 0)
    readonly property real secAphaseTemp: (deviceData && deviceData.TransformerSecTempA || 0)
    readonly property real secBphaseTemp: (deviceData && deviceData.TransformerSecTempB || 0)
    readonly property real secCphaseTemp: (deviceData && deviceData.TransformerSecTempC || 0)

    readonly property real fan1Status: (deviceData && deviceData.Fan1Status || 0)
    readonly property real fan1Speed: (deviceData && deviceData.Fan1Speed || 0)
    readonly property real fan1BreakerStatus: (deviceData && deviceData.Fan1BreakerStatus || 0)
    readonly property real fan1ContactorStatus: (deviceData && deviceData.Fan1ContactorStatus || 0)
    readonly property real fan1Temp: (deviceData && deviceData.Fan1Temp || 0)
    readonly property real fan2Status: (deviceData && deviceData.Fan2Status || 0)
    readonly property real fan2Speed: (deviceData && deviceData.Fan2Speed || 0)
    readonly property real fan2BreakerStatus: (deviceData && deviceData.Fan2BreakerStatus || 0)
    readonly property real fan2ContactorStatus: (deviceData && deviceData.Fan2ContactorStatus || 0)
    readonly property real fan2Temp: (deviceData && deviceData.Fan2Temp || 0)
    readonly property real fan3Status: (deviceData && deviceData.Fan3Status || 0)
    readonly property real fan3Speed: (deviceData && deviceData.Fan3Speed || 0)
    readonly property real fan3BreakerStatus: (deviceData && deviceData.Fan3BreakerStatus || 0)
    readonly property real fan3ContactorStatus: (deviceData && deviceData.Fan3ContactorStatus || 0)
    readonly property real fan3Temp: (deviceData && deviceData.Fan3Temp || 0)
    readonly property real fan4Status: (deviceData && deviceData.Fan4Status || 0)
    readonly property real fan4Speed: (deviceData && deviceData.Fan4Speed || 0)
    readonly property real fan4BreakerStatus: (deviceData && deviceData.Fan4BreakerStatus || 0)
    readonly property real fan4ContactorStatus: (deviceData && deviceData.Fan4ContactorStatus || 0)
    readonly property real fan4Temp: (deviceData && deviceData.Fan4Temp || 0)

    readonly property real entryCabinetDoor: (deviceData && deviceData.EntryCabinetDoor || 0)
    readonly property real phaseShiftingDoor: (deviceData && deviceData.PhaseShiftingDoor || 0)
    

    ColumnLayout {
        anchors.fill: parent
        anchors.topMargin: 4
        anchors.bottomMargin: 8
        anchors.rightMargin: 4
        spacing: 4

        FluFrame {
            Layout.fillWidth: true
            Layout.preferredHeight: 110

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

                    // Row 1 
                    FluTextBox { text: uab.toFixed(2); Layout.fillWidth: true; Layout.fillHeight: true; readOnly: true; font.pixelSize: 11 }
                    FluText { text: "kV"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }
                    FluTextBox { text: ubc.toFixed(2); Layout.fillWidth: true; Layout.fillHeight: true; readOnly: true; font.pixelSize: 11 }
                    FluText { text: "kV"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }
                    FluTextBox { text: uca.toFixed(2); Layout.fillWidth: true; Layout.fillHeight: true; readOnly: true; font.pixelSize: 11 }
                    FluText { text: "kV"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }
                    FluTextBox { text: freq.toFixed(2); Layout.fillWidth: true; Layout.fillHeight: true; readOnly: true; font.pixelSize: 11 }
                    FluText { text: "Hz"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }
                    DataCell{ text:breaker}
                    //FluTextBox { text: breaker; Layout.fillWidth: true; Layout.fillHeight: true; readOnly: true; font.pixelSize: 11 }

                    // Row 2
                    FluTextBox { text: iab.toFixed(2); Layout.fillWidth: true; Layout.fillHeight: true; readOnly: true; font.pixelSize: 11 }
                    FluText { text: "A"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }
                    FluTextBox { text: ibc.toFixed(2); Layout.fillWidth: true; Layout.fillHeight: true; readOnly: true; font.pixelSize: 11 }
                    FluText { text: "A"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }
                    FluTextBox { text: ica.toFixed(2); Layout.fillWidth: true; Layout.fillHeight: true; readOnly: true; font.pixelSize: 11 }
                    FluText { text: "A"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }
                }
            }
        }

        FluFrame{
            Layout.fillWidth: true
            Layout.preferredHeight: 32

            RowLayout {

                spacing:8

                FluText {
                    Layout.margins: 8
                    text: qsTr("Entry cabinet door")
                    font.pixelSize: 13
                    color: FluTheme.fontPrimaryColor
                }
                StatusDot { dotColor: getDoorState(entryCabinetDoor) }

                Item { Layout.minimumWidth: 50 }

                FluText {
                    text: qsTr("Phase-shifting door")
                    font.pixelSize: 13
                    color: FluTheme.fontPrimaryColor
                }
                StatusDot { dotColor: getDoorState(phaseShiftingDoor) }
            }
        }

        GridLayout{
            columns: 2
            rowSpacing: 8
            columnSpacing: 8
            Layout.fillWidth: true
            Layout.fillHeight: true

            //变压器原边
            Item{
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.preferredWidth: parent.width * 0.5

                FluFrame{
                    anchors.fill: parent

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 8

                        RowLayout {
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignHCenter
                            spacing: 8

                            FluText {
                                text: "Transformer primary side"
                                font.pixelSize: 13
                                color: FluTheme.fontPrimaryColor
                            }

                        }

                        RowLayout {
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter
                            spacing: 8

                            FluText {
                                text: "Temperature module status:"
                                font.pixelSize: 13
                                //font.weight: Font.DemiBold
                                color: FluTheme.fontPrimaryColor
                            }

                            DataCell{
                                Layout.leftMargin:8
                                Layout.fillWidth: false
                                Layout.preferredWidth: 100
                                text:prTempStatus
                                color: "#e8f5e8"
                            }
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter
                            spacing: 8

                            FluText {
                                text: "A phase: "
                                font.pixelSize: 13
                                //font.weight: Font.DemiBold
                                color: FluTheme.fontPrimaryColor
                            }
                            DataCell{
                                text:prAphaseTemp.toFixed(2) + "℃"
                            }

                            FluText {
                                text: "B phase: "
                                font.pixelSize: 13
                                //font.weight: Font.DemiBold
                                color: FluTheme.fontPrimaryColor
                            }
                            DataCell{
                                text:prBphaseTemp.toFixed(2) + "℃"
                            }

                            FluText {
                                text: "C phase: "
                                font.pixelSize: 13
                                //font.weight: Font.DemiBold
                                color: FluTheme.fontPrimaryColor
                            }
                            DataCell{
                                text:prCphaseTemp.toFixed(2) + "℃"
                            }
                        }
                    }
                }
            }

            //变压器副边
            Item{
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.preferredWidth: parent.width * 0.5

                FluFrame{
                    anchors.fill: parent

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 8

                        RowLayout {
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignHCenter
                            spacing: 8

                            FluText {
                                text: "Transformer secondary  side"
                                font.pixelSize: 13
                                color: FluTheme.fontPrimaryColor
                            }

                        }

                        RowLayout {
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter
                            spacing: 8

                            FluText {
                                text: "Temperature secondary  status:"
                                font.pixelSize: 13
                                color: FluTheme.fontPrimaryColor
                            }

                            DataCell{
                                Layout.leftMargin:8
                                Layout.fillWidth: false
                                Layout.preferredWidth: 100
                                text:secTempStatus
                                color: "#e8f5e8"
                            }
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter
                            spacing: 8

                            FluText {
                                text: "A phase: "
                                font.pixelSize: 13
                                //font.weight: Font.DemiBold
                                color: FluTheme.fontPrimaryColor
                            }
                            DataCell{
                                text:secAphaseTemp.toFixed(2) + "℃"
                            }

                            FluText {
                                text: "B phase: "
                                font.pixelSize: 13
                                //font.weight: Font.DemiBold
                                color: FluTheme.fontPrimaryColor
                            }
                            DataCell{
                                text:secAphaseTemp.toFixed(2) + "℃"
                            }

                            FluText {
                                text: "C phase: "
                                font.pixelSize: 13
                                //font.weight: Font.DemiBold
                                color: FluTheme.fontPrimaryColor
                            }
                            DataCell{
                                text:secAphaseTemp.toFixed(2) + "℃"
                            }
                        }
                    }
                }
            }
            //风扇1信息
            Item{
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.preferredWidth: parent.width * 0.5

                FluFrame{
                    anchors.fill: parent

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 8

                        RowLayout {
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignHCenter
                            spacing: 8

                            FluText {
                                text: "Fan1 Info"
                                font.pixelSize: 13
                                color: FluTheme.fontPrimaryColor
                            }

                        }

                        GridLayout{
                            columns: 6
                            rowSpacing: 8
                            columnSpacing: 8
                            Layout.fillWidth: true
                            Layout.fillHeight: true

                            FluText {
                                text: "Fan Status: "
                                font.pixelSize: 13
                                //font.weight: Font.DemiBold
                                Layout.alignment: Qt.AlignVCenter
                                color: FluTheme.fontPrimaryColor
                            }
                            DataCell{
                                text: fan1Status
                            }

                            FluText {
                                text: "Fan Speed: "
                                font.pixelSize: 13
                                //font.weight: Font.DemiBold
                                Layout.alignment: Qt.AlignVCenter
                                color: FluTheme.fontPrimaryColor
                            }
                            DataCell{
                                text: fan1Speed.toFixed(0)
                            }

                            FluText {
                                text: "Fan temp: "
                                font.pixelSize: 13
                                //font.weight: Font.DemiBold
                                Layout.alignment: Qt.AlignVCenter
                                color: FluTheme.fontPrimaryColor
                            }
                            DataCell{
                                text: fan1Temp.toFixed(1) + "℃"
                            }

                            FluText {
                                text: "Breaker: "
                                font.pixelSize: 13
                                Layout.alignment: Qt.AlignVCenter
                                color: FluTheme.fontPrimaryColor
                            }
                            DataCell{
                                text: getFanDigitalStatus(fan1BreakerStatus)
                            }

                            FluText {
                                text: "Contactor: "
                                font.pixelSize: 13
                                Layout.alignment: Qt.AlignVCenter
                                color: FluTheme.fontPrimaryColor
                            }
                            DataCell{
                                text: getFanDigitalStatus(fan1ContactorStatus)
                            }

                            FluText {
                                text: "Fan test: "
                                font.pixelSize: 13
                                Layout.alignment: Qt.AlignVCenter
                                color: FluTheme.fontPrimaryColor
                            }
                            FluToggleButton{
                                text: qsTr("start")
                                font.pixelSize: 11
                                Layout.fillWidth: true
                                Layout.alignment: Qt.AlignVCenter
                            }
                        }

                    }
                }
            }
            //风扇2信息
            Item{
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.preferredWidth: parent.width * 0.5

                FluFrame{
                    anchors.fill: parent

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 8

                        RowLayout {
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignHCenter
                            spacing: 8

                            FluText {
                                text: "Fan2 Info"
                                font.pixelSize: 13
                                color: FluTheme.fontPrimaryColor
                            }

                        }

                        GridLayout{
                            columns: 6
                            rowSpacing: 8
                            columnSpacing: 8
                            Layout.fillWidth: true
                            Layout.fillHeight: true

                            FluText {
                                text: "Fan Status: "
                                font.pixelSize: 13
                                //font.weight: Font.DemiBold
                                Layout.alignment: Qt.AlignVCenter
                                color: FluTheme.fontPrimaryColor
                            }
                            DataCell{
                                text: fan2Status
                            }

                            FluText {
                                text: "Fan Speed: "
                                font.pixelSize: 13
                                //font.weight: Font.DemiBold
                                Layout.alignment: Qt.AlignVCenter
                                color: FluTheme.fontPrimaryColor
                            }
                            DataCell{
                                text: fan2Speed.toFixed(0) 
                            }

                            FluText {
                                text: "Fan temp: "
                                font.pixelSize: 13
                                //font.weight: Font.DemiBold
                                Layout.alignment: Qt.AlignVCenter
                                color: FluTheme.fontPrimaryColor
                            }
                            DataCell{
                                text: fan2Temp.toFixed(1) + "℃"
                            }

                            FluText {
                                text: "Breaker: "
                                font.pixelSize: 13
                                Layout.alignment: Qt.AlignVCenter
                                color: FluTheme.fontPrimaryColor
                            }
                            DataCell{
                                text: getFanDigitalStatus(fan2BreakerStatus)
                            }

                            FluText {
                                text: "Contactor: "
                                font.pixelSize: 13
                                Layout.alignment: Qt.AlignVCenter
                                color: FluTheme.fontPrimaryColor
                            }
                            DataCell{
                                text: getFanDigitalStatus(fan2ContactorStatus)
                            }

                            FluText {
                                text: "Fan test: "
                                font.pixelSize: 13
                                Layout.alignment: Qt.AlignVCenter
                                color: FluTheme.fontPrimaryColor
                            }
                            FluToggleButton{
                                text: qsTr("start")
                                font.pixelSize: 11
                                Layout.fillWidth: true
                                Layout.alignment: Qt.AlignVCenter
                            }
                        }

                    }
                }
            }
            //风扇3信息
            Item{
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.preferredWidth: parent.width * 0.5

                FluFrame{
                    anchors.fill: parent

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 8

                        RowLayout {
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignHCenter
                            spacing: 8

                            FluText {
                                text: "Fan3 Info"
                                font.pixelSize: 13
                                color: FluTheme.fontPrimaryColor
                            }

                        }

                        GridLayout{
                            columns: 6
                            rowSpacing: 8
                            columnSpacing: 8
                            Layout.fillWidth: true
                            Layout.fillHeight: true

                            FluText {
                                text: "Fan Status: "
                                font.pixelSize: 13
                                //font.weight: Font.DemiBold
                                Layout.alignment: Qt.AlignVCenter
                                color: FluTheme.fontPrimaryColor
                            }
                            DataCell{
                                text: fan3Status
                            }

                            FluText {
                                text: "Fan Speed: "
                                font.pixelSize: 13
                                //font.weight: Font.DemiBold
                                Layout.alignment: Qt.AlignVCenter
                                color: FluTheme.fontPrimaryColor
                            }
                            DataCell{
                                text: fan3Speed.toFixed(0)
                            }

                            FluText {
                                text: "Fan temp: "
                                font.pixelSize: 13
                                //font.weight: Font.DemiBold
                                Layout.alignment: Qt.AlignVCenter
                                color: FluTheme.fontPrimaryColor
                            }
                            DataCell{
                                text: fan3Temp.toFixed(1) + "℃"
                            }

                            FluText {
                                text: "Breaker: "
                                font.pixelSize: 13
                                Layout.alignment: Qt.AlignVCenter
                                color: FluTheme.fontPrimaryColor
                            }
                            DataCell{
                                text: getFanDigitalStatus(fan3BreakerStatus)
                            }

                            FluText {
                                text: "Contactor: "
                                font.pixelSize: 13
                                Layout.alignment: Qt.AlignVCenter
                                color: FluTheme.fontPrimaryColor
                            }
                            DataCell{
                                text: getFanDigitalStatus(fan3ContactorStatus)
                            }

                            FluText {
                                text: "Fan test: "
                                font.pixelSize: 13
                                Layout.alignment: Qt.AlignVCenter
                                color: FluTheme.fontPrimaryColor
                            }

                            FluToggleButton{
                                text: qsTr("start")
                                font.pixelSize: 11
                                Layout.fillWidth: true
                                Layout.alignment: Qt.AlignVCenter
                            }
                        }

                    }
                }
            }
            //风扇4信息
            Item{
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.preferredWidth: parent.width * 0.5

                FluFrame{
                    anchors.fill: parent

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 8

                        RowLayout {
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignHCenter
                            spacing: 8

                            FluText {
                                text: "Fan4 Info"
                                font.pixelSize: 13
                                color: FluTheme.fontPrimaryColor
                            }

                        }

                        GridLayout{
                            columns: 6
                            rowSpacing: 8
                            columnSpacing: 8
                            Layout.fillWidth: true
                            Layout.fillHeight: true

                            FluText {
                                text: "Fan Status: "
                                font.pixelSize: 13
                                //font.weight: Font.DemiBold
                                Layout.alignment: Qt.AlignVCenter
                                color: FluTheme.fontPrimaryColor
                            }
                            DataCell{
                                text: fan4Status
                            }

                            FluText {
                                text: "Fan Speed: "
                                font.pixelSize: 13
                                //font.weight: Font.DemiBold
                                Layout.alignment: Qt.AlignVCenter
                                color: FluTheme.fontPrimaryColor
                            }
                            DataCell{
                                text: fan4Speed.toFixed(0)
                            }

                            FluText {
                                text: "Fan temp: "
                                font.pixelSize: 13
                                //font.weight: Font.DemiBold
                                Layout.alignment: Qt.AlignVCenter
                                color: FluTheme.fontPrimaryColor
                            }
                            DataCell{
                                text: fan4Temp.toFixed(1) + "℃"
                            }

                            FluText {
                                text: "Breaker: "
                                font.pixelSize: 13
                                Layout.alignment: Qt.AlignVCenter
                                color: FluTheme.fontPrimaryColor
                            }
                            DataCell{
                                text: getFanDigitalStatus(fan4BreakerStatus)
                            }

                            FluText {
                                text: "Contactor: "
                                font.pixelSize: 13
                                Layout.alignment: Qt.AlignVCenter
                                color: FluTheme.fontPrimaryColor
                            }
                            DataCell{
                                text: getFanDigitalStatus(fan4ContactorStatus)
                            }

                            FluText {
                                text: "Fan test: "
                                font.pixelSize: 13
                                Layout.alignment: Qt.AlignVCenter
                                color: FluTheme.fontPrimaryColor
                            }

                            FluToggleButton{
                                text: qsTr("start")
                                font.pixelSize: 11
                                Layout.fillWidth: true
                                Layout.alignment: Qt.AlignVCenter
                            }

                        }
                    }
                }
            }

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

        // // 闪烁效果（可选）
        // SequentialAnimation {
        // running: true
        // loops: Animation.Infinite
        // NumberAnimation { target: parent; property: "opacity"; to: 0.3; duration: 1000 }
        // NumberAnimation { target: parent; property: "opacity"; to: 1.0; duration: 1000 }
        // }
    }

    function getBreakerStatus(status){
        var intValue = parseInt(status) || 0;
        switch(intValue)
        {
        case 0x0000:
            return qsTr("open");
        case 0x0001:
            return qsTr("close");
        case 0x0002:
            return qsTr("grand");
        case 0x0003:
            return qsTr("unknown");
        default:
            return "---";
        }
    }

    function getDoorState(status){
        var intValue = parseInt(status) || 0;
        switch(intValue)
        {
        case 0x0000:
            return "#f44336";
        case 0x0001:
            return "#4caf50" ;
        default:
            return "#f44336";
        }
    }

    function getFanDigitalStatus(status){
        var intValue = parseInt(status) || 0;

        switch(intValue)
        {
        case 0x0000:
            return qsTr("on");
        case 0x0001:
            return qsTr("off");
        default:
            return "---";
        }
    }


    // 数据单元格组件
    component DataCell: Rectangle {
        property string text: ""
        property string cellColor: FluTheme.dark ? "#2d2d2d" : "#f8f9fa"
        property string textColor: ""

        // 大小控制选项：
        Layout.fillWidth: true
        Layout.preferredWidth: 65
        Layout.preferredHeight: 26

        color: cellColor
        border.color: FluTheme.dark ? "#555" : "#e0e0e0"
        border.width: 1
        radius: 2

        FluText {
            anchors.centerIn: parent
            text: parent.text
            font.pixelSize: 11
            color: textColor || FluTheme.fontPrimaryColor
        }
    }


    // Component{
    // id:info10KvIsolatorTab1
    // Rectangle{
    // anchors.fill: parent
    // }
    // }

    // function createTab(){
    // tab_view.appendTab("qrc:/image/favicon.ico",qsTr("10Kv AC Isolator Info1"),info10KvIsolatorTab1,{})
    // tab_view.appendTab("qrc:/image/favicon.ico",qsTr("10Kv AC Isolator Info2"),info10KvIsolatorTab1,{})
    // }

    // FluFrame{
    // anchors.fill: parent
    // anchors.bottomMargin: 12
    // anchors.rightMargin: 12

    // //padding: 8
    // FluTabView{
    // id:tab_view
    // addButtonVisibility: false
    // closeButtonVisibility: FluTabViewType.Never
    // tabWidthBehavior: FluTabViewType.Equal
    // onNewPressed:{
    // createTab()
    // }
    // }
    // }

}
