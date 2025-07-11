import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0

FluContentPage {
    title: qsTr("Main Info")

    Component.onCompleted: {
        // 连接信号到C++槽函数
        pageManager.notifyPageSwitch("infoMainInfo");
    }

    Component.onDestruction: {
        // 页面销毁时的清理工作
        //deviceData = null;
        deviceData = null;
        // 强制垃圾回收
        gc();
    }

    // 数据连接 - 实时绑定串口数据
    property var deviceData: pageManager.pageData || {}

    anchors.fill: parent

    ColumnLayout
    {
        anchors.fill: parent
        anchors.topMargin: 4
        anchors.bottomMargin: 4
        spacing: 8

        // 上部区域 - 数据卡片
        GridLayout {
            id: cardsGrid
            Layout.fillWidth: true
            columns: 1

            columnSpacing: 8
            rowSpacing: 8

            // 系统概览卡片 - Hero Card
            FluFrame {
                Layout.fillWidth: true
                Layout.preferredHeight: 100

                GridLayout {
               anchors.fill: parent
                    anchors.leftMargin: 16
                    anchors.rightMargin: 16
                    anchors.topMargin: 8
                    anchors.bottomMargin: 8
                    columns: 4
                    columnSpacing: 16
                    rowSpacing: 0

                    FluentDataItem {
                        label: qsTr("Sys Volt:")
                        value: (deviceData && deviceData.sysVolt || 0).toFixed(2)
                        unit: "V"
                        Layout.fillWidth: true
                    }

                    FluentDataItem {
                        label: qsTr("Sys Curr:")
                        value: (deviceData && deviceData.sysCurr || 0).toFixed(2)
                        unit: "A"
                        Layout.fillWidth: true
                    }

                    FluentDataItem {
                        label: qsTr("Sys Power:")
                        value: (deviceData && deviceData.sysPower || 0).toFixed(2)
                        unit: "W"
                        Layout.fillWidth: true
                    }

                    FluentDataItem {
                        label: qsTr("Load:")
                        value: (deviceData && deviceData.load || 0).toFixed(1)
                        unit: "％"
                        Layout.fillWidth: true
                    }

                    FluentDataItem {
                        label: qsTr("Load Volt:")
                        value: (deviceData && deviceData.loadVolt || 0).toFixed(2)
                        unit: "V"
                        Layout.fillWidth: true
                    }

                    FluentDataItem {
                        label: qsTr("Load Curr:")
                        value: (deviceData && deviceData.loadCurr || 0).toFixed(2)
                        unit: "A"
                        Layout.fillWidth: true
                    }

                    FluentDataItem {
                        label: qsTr("Sys Energy:")
                        value: (deviceData && deviceData.sysEnergy || 0).toFixed(2)
                        unit: "W"
                        Layout.fillWidth: true
                    }

                    FluentDataItem {
                        label: qsTr("Ambi Temp:")
                        value: (deviceData && deviceData.ambiTemp || 0).toFixed(1)
                        unit: "℃"
                        Layout.fillWidth: true
                    }
                }
            }

            // 电池信息卡片
            FluFrame {
                Layout.fillWidth: true
                Layout.preferredHeight: 100

                GridLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 16
                    anchors.rightMargin: 16
                    anchors.topMargin: 8
                    anchors.bottomMargin: 8
                    columns: 4
                    columnSpacing: 16
                    rowSpacing: 0

                    FluentDataItem {
                        label: qsTr("BattA Volt:")
                        value: (deviceData && deviceData.BattAVolt || 0).toFixed(2)
                        unit: "V"
                        Layout.fillWidth: true
                    }

                    FluentDataItem {
                        label: qsTr("BattA Curr:")
                        value: (deviceData && deviceData.BattACurr || 0).toFixed(2)
                        unit: "A"
                        Layout.fillWidth: true
                    }

                    FluentDataItem {
                        label: qsTr("BattA Temp:")
                        value: (deviceData && deviceData.BattATemp || 0).toFixed(2)
                        unit: "℃"
                        Layout.fillWidth: true
                    }

                    FluentDataItem {
                        label: qsTr("BattA Brk:")
                        value: getBreakerStatus(deviceData && deviceData.BattABrk || 0)
                        Layout.fillWidth: true
                    }

                    FluentDataItem {
                        label: qsTr("BattB Volt:")
                        value: (deviceData && deviceData.BattBVolt || 0).toFixed(2)
                        unit: "V"
                        Layout.fillWidth: true
                    }

                    FluentDataItem {
                        label: qsTr("BattB Curr:")
                        value: (deviceData && deviceData.BattBCurr || 0).toFixed(2)
                        unit: "A"
                        Layout.fillWidth: true
                    }

                    FluentDataItem {
                        label: qsTr("BattB Temp:")
                        value: (deviceData && deviceData.BattBTemp || 0).toFixed(2)
                        unit: "℃"
                        Layout.fillWidth: true
                    }

                    FluentDataItem {
                        label: qsTr("BattB Brk:")
                        value: getBreakerStatus(deviceData && deviceData.BattBBrk || 0)
                        Layout.fillWidth: true
                    }
                }
            }
        }

        Item {
            Layout.fillHeight: true
            Layout.minimumHeight: 4
        }

        RowLayout {
            id: bottomInfoLayout
            Layout.fillWidth: true
            Layout.preferredHeight: 300

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: parent.width * 0.6

                ColumnLayout {
                    anchors.fill: parent
                    anchors.topMargin: 4
                    anchors.bottomMargin: 4

                    spacing: 8

                    // AC 1 区域
                    FluFrame {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 98

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 12
                            spacing: 8

                            FluText {
                                text: "AC 1"
                                font.pixelSize: 15
                                font.weight: Font.DemiBold
                                color: FluTheme.fontPrimaryColor
                                Layout.alignment: Qt.AlignVCenter
                                Layout.rightMargin: 12
                                Layout.leftMargin: 8
                            }

                            GridLayout {
                                columns: 7
                                rowSpacing: 6
                                columnSpacing: 8
                                Layout.fillWidth: true
                                Layout.alignment: Qt.AlignVCenter

                                // 第一行 - 电压
                                FluTextBox {
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    text: (deviceData && deviceData.AC1Phase1Volt || 0).toFixed(2)
                                    readOnly: true
                                    font.pixelSize: 11
                                }
                                FluText { text: "V"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }

                                FluTextBox {
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    text: (deviceData && deviceData.AC1Phase2Volt || 0).toFixed(2)
                                    readOnly: true
                                    font.pixelSize: 11
                                }
                                FluText { text: "V"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }

                                FluTextBox {
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    text: (deviceData && deviceData.AC1Phase3Volt || 0).toFixed(2)
                                    readOnly: true
                                    font.pixelSize: 11
                                }
                                FluText { text: "V"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }

                                RowLayout {
                                    spacing: 4
                                    FluTextBox {
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true
                                        text: (deviceData && deviceData.AC1Freq || 0).toFixed(2)
                                        readOnly: true
                                        font.pixelSize: 11
                                    }
                                    FluText { text: "Hz"; font.pixelSize: 12 }

                                    FluTextBox {
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true

                                        text: getAc2SupplyStatus(deviceData && deviceData.supplyPower || 0)
                                        readOnly: true
                                        font.pixelSize: 11
                                    }
                                }

                                // 第二行 - 电流
                                FluTextBox {
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    text:(deviceData && deviceData.AC1Phase1Curr || 0).toFixed(2)
                                    readOnly: true
                                    font.pixelSize: 11
                                }
                                FluText { text: "A"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }

                                FluTextBox {
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    text: (deviceData && deviceData.AC1Phase2Curr || 0).toFixed(2)
                                    readOnly: true
                                    font.pixelSize: 11
                                }
                                FluText { text: "A"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }

                                FluTextBox {
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    text: (deviceData && deviceData.AC1Phase3Curr || 0).toFixed(2)
                                    readOnly: true
                                    font.pixelSize: 11
                                }
                                FluText { text: "A"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }

                                Item { Layout.fillWidth: true }
                            }
                        }
                    }

                    // AC 2 区域
                    FluFrame {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 98

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 12
                            spacing: 6

                            FluText {
                                text: "AC 2"
                                font.pixelSize: 15
                                font.weight: Font.DemiBold
                                color: FluTheme.fontPrimaryColor
                                Layout.alignment: Qt.AlignVCenter
                                Layout.rightMargin: 12
                                Layout.leftMargin: 8
                            }

                            GridLayout {
                                columns: 7
                                rowSpacing: 6
                                columnSpacing: 8
                                Layout.fillWidth: true
                                Layout.alignment: Qt.AlignVCenter

                                // 第一行 - 电压
                                FluTextBox {
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    text: (deviceData && deviceData.AC2Phase1Volt || 0).toFixed(2)
                                    readOnly: true
                                    font.pixelSize: 11
                                }
                                FluText { text: "V"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }

                                FluTextBox {
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    text: (deviceData && deviceData.AC2Phase2Volt || 0).toFixed(2)
                                    readOnly: true
                                    font.pixelSize: 11
                                }
                                FluText { text: "V"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }

                                FluTextBox {
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    text: (deviceData && deviceData.AC2Phase3Volt || 0).toFixed(2)
                                    readOnly: true
                                    font.pixelSize: 11
                                }
                                FluText { text: "V"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }

                                RowLayout {
                                    spacing: 4
                                    FluTextBox {
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true

                                        text: (deviceData && deviceData.AC2Freq || 0).toFixed(2)
                                        readOnly: true
                                        font.pixelSize: 11
                                    }

                                    FluText { text: "Hz"; font.pixelSize: 12 }

                                    FluTextBox {
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true

                                        text: getAc2SupplyStatus(deviceData && deviceData.supplyPower || 0)
                                        readOnly: true
                                        font.pixelSize: 11
                                    }
                                }

                                // 第二行 - 电流
                                FluTextBox {
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    text: (deviceData && deviceData.AC2Phase1Curr || 0).toFixed(2)
                                    readOnly: true
                                    font.pixelSize: 11
                                }
                                FluText { text: "A"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }

                                FluTextBox {
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    text: (deviceData && deviceData.AC2Phase2Curr || 0).toFixed(2)
                                    readOnly: true
                                    font.pixelSize: 11
                                }
                                FluText { text: "A"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }

                                FluTextBox {
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    text: (deviceData && deviceData.AC2Phase2Curr || 0).toFixed(2)
                                    readOnly: true
                                    font.pixelSize: 11
                                }
                                FluText { text: "A"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }

                                Item { Layout.fillWidth: true }
                            }
                        }
                    }

                    // 底部状态区域
                    FluFrame {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: 110

                        GridLayout {
                            anchors.fill: parent
                            anchors.margins: 12
                            columns: 2
                            rowSpacing: 6
                            columnSpacing: 12

                            // 状态指示器组件
                            StatusIndicator {
                                label: "CAN1Status"
                                status: "Interrupt"
                            }
                            StatusIndicator {
                                label: "CAN2Status"
                                status: "Interrupt"
                            }
                            StatusIndicator {
                                label: "RS4851Status"
                                status: "Interrupt"
                            }
                            StatusIndicator {
                                label: "RS4852Status"
                                status: "Interrupt"
                            }
                        }
                    }
                }
            }

            // 右侧区域包装器
            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: parent.width * 0.4

                FluFrame {
                    anchors.fill: parent
                    //anchors.margins: 4
                    anchors.topMargin: 4
                    anchors.leftMargin: 4
                    anchors.bottomMargin: 4

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 12

                        // 表格头部
                        GridLayout {
                            columns: 4
                            Layout.fillWidth: true
                            Layout.topMargin: 12
                            columnSpacing: 6

                            Item { Layout.preferredWidth: 60 }

                            HeaderCell { text: "CSU A" }
                            HeaderCell { text: "CSU B" }
                            HeaderCell { text: "CSU C" }
                        }

                        // 表格内容
                        GridLayout {
                            columns: 4
                            Layout.fillWidth: true
                            columnSpacing: 6
                            rowSpacing: 6

                            // 系统状态行
                            RowLabel { labelText: qsTr("Sys Status") }
                            DataCell {
                                text: getSysStatus(deviceData && deviceData.CSUASysStatus || 0)
                                cellColor: "#e8f5e8"
                            }
                            DataCell {
                                text: getSysStatus(deviceData && deviceData.CSUBSysStatus || 0)
                                cellColor: "#e8f5e8"
                            }
                            DataCell {
                                text: getSysStatus(deviceData && deviceData.CSUCSysStatus || 0)
                                cellColor: "#e8f5e8"
                            }

                            // 运行模块行
                            RowLabel { labelText: qsTr("Rect Num") }
                            DataCell { text: (deviceData && deviceData.CSUARectNum || 0) }
                            DataCell { text: (deviceData && deviceData.CSUBRectNum || 0) }
                            DataCell { text: (deviceData && deviceData.CSUCRectNum || 0) }

                            // 系统告警行
                            RowLabel { labelText: qsTr("Sys Alarm") }
                            DataCell { text: getSysAlarmStatus(deviceData && deviceData.sysAlarm || 0)
                                cellColor: getSysAlarmStatusColor(deviceData && deviceData.sysAlarm || 0) }
                            Item { Layout.fillWidth: true }
                            Item { Layout.fillWidth: true }

                            RowLabel { labelText: qsTr("MCUMode") }
                            DataCell { text: "Master"}

                        }

                        // 垂直填充空间
                        Item {
                            Layout.fillHeight: true
                            Layout.minimumHeight: 5
                        }

                        // 底部状态区域
                        GridLayout {
                            columns: 3
                            Layout.fillWidth: true
                            columnSpacing: 12
                            rowSpacing: 8

                            // COM状态和效能
                            RowLayout {
                                spacing: 8

                                FluText {
                                    text: "COM"
                                    font.pixelSize: 13
                                    color: FluTheme.fontPrimaryColor
                                }
                                StatusDot { dotColor: getComStatus(serial.isOpen) }

                                Item { Layout.minimumWidth: 12 }

                                FluText {
                                    text: qsTr("EFFS")
                                    font.pixelSize: 13
                                    color: FluTheme.fontPrimaryColor
                                }
                                StatusDot { dotColor: getEFFSStatus(deviceData && deviceData.sysEFFS || 0) }
                            }

                            RowLayout {
                                Layout.row:1
                                spacing: 8

                                FluText {
                                    text: qsTr("RTC Voltage")
                                    font.pixelSize: 13
                                    color: FluTheme.fontPrimaryColor
                                }
                                DataCell { text: (deviceData && deviceData.RTCBattVolt || 0).toFixed(2) }
                                FluText {
                                    text: "V";
                                    font.pixelSize: 13;
                                    color: FluTheme.fontPrimaryColor
                                }
                                Item { Layout.fillWidth: true }
                            }

                            // 系统时间
                            RowLayout {
                                spacing: 8
                                Layout.row:2
                                Layout.columnSpan: 3

                                FluText {
                                    text: qsTr("System Time")
                                    font.pixelSize: 13
                                    color: FluTheme.fontPrimaryColor
                                }
                                FluFrame {
                                    Layout.preferredWidth: 100
                                    Layout.preferredHeight: 28
                                    padding: 4

                                    FluText {
                                        anchors.centerIn: parent
                                        text: "00:00:00\nyyyy/MM/DD"
                                        font.pixelSize: 9
                                        horizontalAlignment: Text.AlignHCenter
                                        color: FluTheme.fontSecondaryColor
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // Fluent Design: 卡片组件 - 优化版本
    component FluentCard: Item {
        property string title: ""
        property string cardType: "default" // hero, default

        width: parent.width
        height: parent.height

        Rectangle {
            id: cardBackground
            anchors.fill: parent
            border.color: FluTheme.dark ? Qt.rgba(255, 255, 255, 0.1) : Qt.rgba(0, 0, 0, 0.1)

            // 优化：简化阴影效果或使用更轻量的替代
            // 可以选择完全移除layer效果以节省内存
            //layer.enabled: false // 禁用阴影以节省内存

            layer.enabled: true
            layer.effect: FluShadow {
                elevation: mouseArea.containsMouse ? 8 : 4
                Behavior on elevation {
                    NumberAnimation { duration: 167; easing.type: Easing.OutCubic }
                }
            }

        }

        // 卡片标题
        FluText {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.margins: 20
            text: title
            font.pixelSize: cardType === "hero" ? 20 : 18
            font.weight: cardType === "hero" ? Font.Medium : Font.DemiBold
            color: FluTheme.fontPrimaryColor
        }

        // 悬停效果 - 简化版本
        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.NoButton
        }
        /*
        //优化：简化或移除缩放动画
        scale: mouseArea.containsMouse ? 1.02 : 1.0
        Behavior on scale {
        NumberAnimation { duration: 167; easing.type: Easing.OutCubic }
        }
        */
    }

    // Fluent数据项组件
    component FluentDataItem: Item {
        property string label: ""
        property string value: ""
        property string unit: ""

        height: 44 // 优化高度

        // 横向文本区域
        Row {
            id: dataRow
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            spacing: 4

            FluText {
                id: labelText
                text: label
                font.pixelSize: 15
                font.weight: Font.Normal
                color: FluTheme.fontSecondaryColor
                width: Math.max(implicitWidth, dataRow.width * 0.4)
                elide: Text.ElideRight
                opacity: 0.9
                anchors.verticalCenter: parent.verticalCenter
            }

            Row {
                spacing: 4
                height: parent.height
                anchors.verticalCenter: parent.verticalCenter

                FluText {
                    id: valueText
                    text: value
                    font.pixelSize: 17
                    font.weight: Font.DemiBold
                    color: FluTheme.fontPrimaryColor
                    anchors.verticalCenter: parent.verticalCenter
                }
                FluText {
                    text: unit
                    font.pixelSize: 15
                    font.weight: Font.Normal
                    color: FluTheme.fontTertiaryColor
                    anchors.verticalCenter: parent.verticalCenter
                    opacity: 0.8
                }
            }
        }
    }

    // 优化的状态指示器组件
    component StatusIndicator: RowLayout {
        property string label: ""
        property string status: ""

        spacing: 8

        FluText {
            text: label
            font.pixelSize: 13
            Layout.preferredWidth: 85
            elide: Text.ElideRight
            color: FluTheme.fontPrimaryColor
        }

        FluFrame {
            Layout.preferredWidth: 70
            Layout.preferredHeight: 30
            padding: 4

            Rectangle {
                anchors.fill: parent
                radius: 4

                FluText {
                    anchors.centerIn: parent
                    text: status
                    font.pixelSize: 11
                    color: FluTheme.fontPrimaryColor
                }
            }
        }
    }

    // 表格头部单元格组件
    component HeaderCell: Rectangle {
        property string text: ""

        Layout.fillWidth: true
        height: 28
        color: FluTheme.dark ? "#404040" : "#e3f2fd"
        border.color: FluTheme.dark ? "#555" : "#bbdefb"
        border.width: 1
        radius: 4

        FluText {
            anchors.centerIn: parent
            text: parent.text
            font.weight: Font.DemiBold
            font.pixelSize: 12
            color: FluTheme.fontPrimaryColor
        }
    }

    // 数据单元格组件
    component DataCell: Rectangle {
        property string text: ""
        property string cellColor: FluTheme.dark ? "#2d2d2d" : "#f8f9fa"
        property string textColor: ""

        Layout.fillWidth: true
        height: 26
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

    // 行标签组件
    component RowLabel: FluText {
        property string labelText: ""

        text: labelText
        font.pixelSize: 11
        font.weight: Font.Medium
        Layout.preferredWidth: 60
        Layout.alignment: Qt.AlignVCenter
        color: FluTheme.fontSecondaryColor
        elide: Text.ElideRight
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

    // 断路器状态转换函数
    function getBreakerStatus(value)
    {
        var intValue = parseInt(value) || 0;
        switch(intValue)
        {
        case 0x0001: // 1
            return "On";
        case 0x0002: // 2
            return "Off";
        case 0x0003: // 3
            return "Trip";
        default:
            return "---";
        }
    }

    // 通信状态转换函数
    function getComStatus(isOpen)
    {
        return isOpen ? "#4caf50" : "#f44336";
    }

    function getAc1SupplyStatus(value)
    {
        var intValue = (parseInt(value) & 0x0001) || 0;
        switch(intValue)
        {
        case 0x0001:
            return "ON";
        default:
            return "OFF";
        }
    }

    function getAc2SupplyStatus(value)
    {
        var intValue = (parseInt(value) & 0x0010) || 0;
        switch(intValue)
        {
        case 0x0010:
            return "ON";
        default:
            return "OFF";
        }
    }

    function getSysStatus(value)
    {
        var intValue = parseInt(value) || 0;
        switch(intValue)
        {
        case 0x0100:
            return qsTr("Floating"); // 浮充
        case 0x0201:
            return qsTr("Buffer Limit"); // 缓冲限流
        case 0x0302:
            return qsTr("Manual Equalize"); // 手动均充
        case 0x0303:
            return qsTr("Cycle Equalize"); // 周期均充
        case 0x0304:
            return qsTr("Capacity Equalize"); // 容量触发均充
        case 0x0305:
            return qsTr("Current Equalize"); // 电流触发均充
        case 0x0306:
            return qsTr("Voltage Equalize"); // 电压触发均充
        case 0x0507:
            return qsTr("Manual Battery Test"); // 手动电池测试
        case 0x0508:
            return qsTr("Cycle Battery Test"); // 周期电池测试
        case 0x0609:
            return qsTr("No Module"); // 无模块
        case 0x070a:
            return qsTr("Battery Discharge"); // 电池放电
        case 0x080b:
            return qsTr("Soft Start"); // 软启动
        case 0x090c:
            return qsTr("Input Power Limit"); // 输入限功率
        case 0x040d:
            return qsTr("Manual Diode Test"); // 手动二极管测试
        case 0x040e:
            return qsTr("Cycle Diode Test"); // 周期二极管测试
        case 0x0A0F:
            return qsTr("Energy Management"); // 储能管理
        default:
            return qsTr("Unknown"); // 未知状态
        }
    }

    function getSysAlarmStatus(value)
    {
        var intValue = parseInt(value) || 0;
        switch(intValue)
        {
        case 0x0:
            return qsTr("OK"); // 正常
        case 0x1:
            return qsTr("Alarm"); // 告警
        case 0x2:
            return qsTr("Fault"); // 故障
        default:
            return qsTr("Unknown"); // 未知
        }
    }

    function getSysAlarmStatusColor(value)
    {
        var intValue = parseInt(value) || 0;
        switch(intValue)
        {
        case 0x0:
            return "#e8f5e8"; // 正常 - 绿色
        case 0x1:
            return "#fff3e0"; // 告警 - 橙色
        case 0x2:
            return "#ffebee"; // 故障 - 红色
        default:
            return "#f5f5f5"; // 未知 - 灰色
        }
    }

    // EFFS状态转换函数
    function getEFFSStatus(value)
    {
        var intValue = parseInt(value) || 0;
        switch(intValue)
        {
        case 0x0000:
            return "#f44336";
        case 0x0001:
            return "#4caf50";
        default:
            return "#ffffff"
        }
    }
}
