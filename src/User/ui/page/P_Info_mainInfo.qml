import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0

FluContentPage {
    id: root
    title: qsTr("Main Info")

    // ==================== 第1层：清理任务管理 ====================
    property var cleanupTasks: []
    property bool isPageActive: false

    // ==================== 第2层：数据缓存层 ====================
    // 使用分组的本地数据结构，避免深层绑定
    property var systemData: ({
        sysVolt: 0.0,
        sysCurr: 0.0,
        sysPower: 0.0,
        loadRate: 0.0,
        loadVolt: 0.0,
        loadCurr: 0.0,
        sysEnergy: 0.0,
        ambiTemp: 0.0
    })

    property var batteryData: ({
        battAVolt: 0.0,
        battACurr: 0.0,
        battATemp: 0.0,
        battABrk: 0,
        battBVolt: 0.0,
        battBCurr: 0.0,
        battBTemp: 0.0,
        battBBrk: 0
    })

    property var ac1Data: ({
        phase1Volt: 0.0,
        phase2Volt: 0.0,
        phase3Volt: 0.0,
        freq: 0.0,
        phase1Curr: 0.0,
        phase2Curr: 0.0,
        phase3Curr: 0.0
    })

    property var ac2Data: ({
        phase1Volt: 0.0,
        phase2Volt: 0.0,
        phase3Volt: 0.0,
        freq: 0.0,
        phase1Curr: 0.0,
        phase2Curr: 0.0,
        phase3Curr: 0.0
    })

    property var csuData: ({
        csuASysStatus: 0,
        csuBSysStatus: 0,
        csuCSysStatus: 0,
        csuARectNum: 0,
        csuBRectNum: 0,
        csuCRectNum: 0
    })

    property var statusData: ({
        sysAlarm: 0,
        sysEFFS: 0,
        rtcBattVolt: 0.0,
        supplyPower: 0
    })

    // ==================== 第3层：连接管理层 ====================
    // 使用 Connections 替代直接绑定
    Connections {
        id: dataConnection
        target: pageManager
        enabled: root.isPageActive

        function onPageDataChanged() {
            if (!root.isPageActive) return;
            updateAllData();
        }
    }

    // ==================== 页面生命周期管理 ====================
    Component.onCompleted: {
        console.log("MainInfo page created");
        root.isPageActive = true;
        
        // 注册清理任务
        cleanupTasks.push(dataConnection);
        
        // 通知页面切换
        pageManager.notifyPageSwitch("infoMainInfo");
        
        // 初始化数据
        updateAllData();
    }

    Component.onDestruction: {
        console.log("MainInfo page destruction started");
        performCleanup();
    }

    // ==================== 第4层：数据更新函数 ====================
    function updateAllData() {
        if (!pageManager.pageData) {
            console.warn("pageManager.pageData is null");
            return;
        }

        // 缓存原始数据引用
        var sourceData = pageManager.pageData;
        
        // 更新系统数据
        updateSystemData(sourceData);
        
        // 更新电池数据
        updateBatteryData(sourceData);
        
        // 更新AC1数据
        updateAC1Data(sourceData);
        
        // 更新AC2数据
        updateAC2Data(sourceData);
        
        // 更新CSU数据
        updateCSUData(sourceData);
        
        // 更新状态数据
        updateStatusData(sourceData);
        
        console.log("All data updated successfully");
    }

    function updateSystemData(sourceData) {
        systemData = {
            sysVolt: sourceData.sysVolt || 0,
            sysCurr: sourceData.sysCurr || 0,
            sysPower: sourceData.sysPower || 0,
            loadRate: sourceData.loadRate || 0,
            loadVolt: sourceData.loadVolt || 0,
            loadCurr: sourceData.loadCurr || 0,
            sysEnergy: sourceData.sysEnergy || 0,
            ambiTemp: sourceData.ambiTemp || 0
        };
    }

    function updateBatteryData(sourceData) {
        batteryData = {
            battAVolt: sourceData.BattAVolt || 0,
            battACurr: sourceData.BattACurr || 0,
            battATemp: sourceData.BattATemp || 0,
            battABrk: sourceData.BattABrk || 0,
            battBVolt: sourceData.BattBVolt || 0,
            battBCurr: sourceData.BattBCurr || 0,
            battBTemp: sourceData.BattBTemp || 0,
            battBBrk: sourceData.BattBBrk || 0
        };
    }

    function updateAC1Data(sourceData) {
        ac1Data = {
            phase1Volt: sourceData.AC1Phase1Volt || 0,
            phase2Volt: sourceData.AC1Phase2Volt || 0,
            phase3Volt: sourceData.AC1Phase3Volt || 0,
            freq: sourceData.AC1Freq || 0,
            phase1Curr: sourceData.AC1Phase1Curr || 0,
            phase2Curr: sourceData.AC1Phase2Curr || 0,
            phase3Curr: sourceData.AC1Phase3Curr || 0
        };
    }

    function updateAC2Data(sourceData) {
        ac2Data = {
            phase1Volt: sourceData.AC2Phase1Volt || 0,
            phase2Volt: sourceData.AC2Phase2Volt || 0,
            phase3Volt: sourceData.AC2Phase3Volt || 0,
            freq: sourceData.AC2Freq || 0,
            phase1Curr: sourceData.AC2Phase1Curr || 0,
            phase2Curr: sourceData.AC2Phase2Curr || 0,
            phase3Curr: sourceData.AC2Phase3Curr || 0
        };
    }

    function updateCSUData(sourceData) {
        csuData = {
            csuASysStatus: sourceData.CSUASysStatus || 0,
            csuBSysStatus: sourceData.CSUBSysStatus || 0,
            csuCSysStatus: sourceData.CSUCSysStatus || 0,
            csuARectNum: sourceData.CSUARectNum || 0,
            csuBRectNum: sourceData.CSUBRectNum || 0,
            csuCRectNum: sourceData.CSUCRectNum || 0
        };
    }

    function updateStatusData(sourceData) {
        statusData = {
            sysAlarm: sourceData.sysAlarm || 0,
            sysEFFS: sourceData.sysEFFS || 0,
            rtcBattVolt: sourceData.RTCBattVolt || 0,
            supplyPower: sourceData.supplyPower || 0
        };
    }

    // ==================== 第5层：清理管理层 ====================
    function performCleanup() {
        console.log("Starting layered cleanup for MainInfo page");
        
        // 第1步：标记页面为非活跃状态
        root.isPageActive = false;
        
        // 第2步：断开所有连接
        for (var i = 0; i < cleanupTasks.length; i++) {
            var task = cleanupTasks[i];
            if (task && typeof task === 'object') {
                if (task.target) {
                    task.target = null;
                }
                if (task.enabled !== undefined) {
                    task.enabled = false;
                }
            }
        }
        
        // 第3步：清理数据结构
        clearDataStructures();
        
        // 第4步：清理任务列表
        cleanupTasks = null;
        
        // 第5步：强制垃圾回收
        Qt.callLater(function() {
            gc();
            console.log("MainInfo page cleanup completed");
        });
    }

    function clearDataStructures() {
        systemData = null;
        batteryData = null;
        ac1Data = null;
        ac2Data = null;
        csuData = null;
        statusData = null;
        
        console.log("All data structures cleared");
    }

    // ==================== UI 层 ====================
    anchors.fill: parent

    ColumnLayout {
        anchors.fill: parent
        anchors.topMargin: 4
        anchors.bottomMargin: 4
        anchors.rightMargin: 4
        spacing: 8

        // 上部区域 - 数据卡片
        GridLayout {
            id: cardsGrid
            Layout.fillWidth: true
            columns: 1
            columnSpacing: 8
            rowSpacing: 8

            // 系统概览卡片
            SystemOverviewCard {
                Layout.fillWidth: true
                Layout.preferredHeight: 100
                sysData: systemData
            }

            // 电池信息卡片
            BatteryInfoCard {
                Layout.fillWidth: true
                Layout.preferredHeight: 100
                battData: batteryData
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

            // 左侧AC信息区域
            ACInfoSection {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: parent.width * 0.6
                pageAc1Data: ac1Data
                pageAc2Data: ac2Data
                supplyStatus: statusData ? statusData.supplyPower : 0
            }

            // 右侧CSU状态区域
            CSUStatusSection {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: parent.width * 0.4
                csuData: root.csuData
                statusData: root.statusData
                serialConnected: serial.isOpen
            }
        }
    }

    // ==================== 组件定义 ====================

    // 系统概览卡片组件
    component SystemOverviewCard: FluFrame {
        property var sysData: null

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
                value: sysData ? sysData.sysVolt.toFixed(2) : "---"
                unit: "V"
                Layout.fillWidth: true
            }

            FluentDataItem {
                label: qsTr("Sys Curr:")
                value: sysData ? sysData.sysCurr.toFixed(2) : "---"
                unit: "A"
                Layout.fillWidth: true
            }

            FluentDataItem {
                label: qsTr("Sys Power:")
                value: sysData ? sysData.sysPower.toFixed(2) : "---"
                unit: "W"
                Layout.fillWidth: true
            }

            FluentDataItem {
                label: qsTr("LoadRate:")
                value: sysData ? sysData.loadRate.toFixed(1) : "---"
                unit: "％"
                Layout.fillWidth: true
            }

            FluentDataItem {
                label: qsTr("Load Volt:")
                value: sysData ? sysData.loadVolt.toFixed(2) : "---"
                unit: "V"
                Layout.fillWidth: true
            }

            FluentDataItem {
                label: qsTr("Load Curr:")
                value: sysData ? sysData.loadCurr.toFixed(2) : "---"
                unit: "A"
                Layout.fillWidth: true
            }

            FluentDataItem {
                label: qsTr("Sys Energy:")
                value: sysData ? sysData.sysEnergy.toFixed(2) : "---"
                unit: "W"
                Layout.fillWidth: true
            }

            FluentDataItem {
                label: qsTr("Ambi Temp:")
                value: sysData ? sysData.ambiTemp.toFixed(1) : "---"
                unit: "℃"
                Layout.fillWidth: true
            }
        }
    }

    // 电池信息卡片组件
    component BatteryInfoCard: FluFrame {
        property var battData: null

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
                value: battData ? battData.battAVolt.toFixed(2) : "---"
                unit: "V"
                Layout.fillWidth: true
            }

            FluentDataItem {
                label: qsTr("BattA Curr:")
                value: battData ? battData.battACurr.toFixed(2) : "---"
                unit: "A"
                Layout.fillWidth: true
            }

            FluentDataItem {
                label: qsTr("BattA Temp:")
                value: battData ? battData.battATemp.toFixed(2) : "---"
                unit: "℃"
                Layout.fillWidth: true
            }

            FluentDataItem {
                label: qsTr("BattA Brk:")
                value: battData ? getBreakerStatus(battData.battABrk) : "---"
                Layout.fillWidth: true
            }

            FluentDataItem {
                label: qsTr("BattB Volt:")
                value: battData ? battData.battBVolt.toFixed(2) : "---"
                unit: "V"
                Layout.fillWidth: true
            }

            FluentDataItem {
                label: qsTr("BattB Curr:")
                value: battData ? battData.battBCurr.toFixed(2) : "---"
                unit: "A"
                Layout.fillWidth: true
            }

            FluentDataItem {
                label: qsTr("BattB Temp:")
                value: battData ? battData.battBTemp.toFixed(2) : "---"
                unit: "℃"
                Layout.fillWidth: true
            }

            FluentDataItem {
                label: qsTr("BattB Brk:")
                value: battData ? getBreakerStatus(battData.battBBrk) : "---"
                Layout.fillWidth: true
            }
        }
    }

    // AC信息区域组件
    component ACInfoSection: Item {
        id: acInfoSection
        property var pageAc1Data: null
        property var pageAc2Data: null
        property var supplyStatus: 0

        // 调试：监控 pageAc1Data/pageAc2Data 变化
        // onPageAc1DataChanged: {
        //     console.log("[ACInfoSection] pageAc1Data changed:", JSON.stringify(pageAc1Data));
        // }
        // onPageAc2DataChanged: {
        //     console.log("[ACInfoSection] pageAc2Data changed:", JSON.stringify(pageAc2Data));
        // }

        ColumnLayout {
            anchors.fill: parent
            anchors.topMargin: 4
            anchors.bottomMargin: 4
            spacing: 8

            // AC 1 区域
            ACFrame {
                Layout.fillWidth: true
                Layout.preferredHeight: 98
                acTitle: "AC 1"
                acData: acInfoSection.pageAc1Data
                supplyStatus: acInfoSection.supplyStatus
                isAC1: true
            }

            // AC 2 区域
            ACFrame {
                Layout.fillWidth: true
                Layout.preferredHeight: 98
                acTitle: "AC 2"
                acData: acInfoSection.pageAc2Data
                supplyStatus: acInfoSection.supplyStatus
                isAC1: false
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

                    StatusIndicator { label: "CAN1Status"; status: "Interrupt" }
                    StatusIndicator { label: "CAN2Status"; status: "Interrupt" }
                    StatusIndicator { label: "RS4851Status"; status: "Interrupt" }
                    StatusIndicator { label: "RS4852Status"; status: "Interrupt" }
                }
            }
        }
    }

    // AC框架组件
    component ACFrame: FluFrame {
        property string acTitle: ""
        property var acData: null
        property var supplyStatus: 0
        property bool isAC1: true

        // 调试：监控 acData 变化
        onAcDataChanged: {
            console.log("[ACFrame] acData changed for", acTitle, JSON.stringify(acData));
        }

        RowLayout {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 8

            FluText {
                text: acTitle
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
                    text: acData ? acData.phase1Volt.toFixed(2) : "---"
                    readOnly: true
                    font.pixelSize: 11
                }
                FluText { text: "V"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }

                FluTextBox {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    text: acData ? acData.phase2Volt.toFixed(2) : "---"
                    readOnly: true
                    font.pixelSize: 11
                }
                FluText { text: "V"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }

                FluTextBox {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    text: acData ? acData.phase3Volt.toFixed(2) : "---"
                    readOnly: true
                    font.pixelSize: 11
                }
                FluText { text: "V"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }

                RowLayout {
                    spacing: 4
                    FluTextBox {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        text: acData ? acData.freq.toFixed(2) : "---"
                        readOnly: true
                        font.pixelSize: 11
                    }
                    FluText { text: "Hz"; font.pixelSize: 12 }

                    FluTextBox {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        text: isAC1 ? getAc1SupplyStatus(supplyStatus) : getAc2SupplyStatus(supplyStatus)
                        readOnly: true
                        font.pixelSize: 11
                    }
                }

                // 第二行 - 电流
                FluTextBox {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    text: acData ? acData.phase1Curr.toFixed(2) : "---"
                    readOnly: true
                    font.pixelSize: 11
                }
                FluText { text: "A"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }

                FluTextBox {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    text: acData ? acData.phase2Curr.toFixed(2) : "---"
                    readOnly: true
                    font.pixelSize: 11
                }
                FluText { text: "A"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }

                FluTextBox {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    text: acData ? acData.phase3Curr.toFixed(2) : "---"
                    readOnly: true
                    font.pixelSize: 11
                }
                FluText { text: "A"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }

                Item { Layout.fillWidth: true }
            }
        }
    }

    // CSU状态区域组件
    component CSUStatusSection: Item {
        property var csuData: null
        property var statusData: null
        property bool serialConnected: false

        FluFrame {
            anchors.fill: parent
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
                        text: csuData ? getSysStatus(csuData.csuASysStatus) : "---"
                        cellColor: "#e8f5e8"
                    }
                    DataCell {
                        text: csuData ? getSysStatus(csuData.csuBSysStatus) : "---"
                        cellColor: "#e8f5e8"
                    }
                    DataCell {
                        text: csuData ? getSysStatus(csuData.csuCSysStatus) : "---"
                        cellColor: "#e8f5e8"
                    }

                    // 运行模块行
                    RowLabel { labelText: qsTr("Rect Num") }
                    DataCell { text: csuData ? csuData.csuARectNum.toString() : "---" }
                    DataCell { text: csuData ? csuData.csuBRectNum.toString() : "---" }
                    DataCell { text: csuData ? csuData.csuCRectNum.toString() : "---" }

                    // 系统告警行
                    RowLabel { labelText: qsTr("Sys Alarm") }
                    DataCell {
                        text: statusData ? getSysAlarmStatus(statusData.sysAlarm) : "---"
                        cellColor: statusData ? getSysAlarmStatusColor(statusData.sysAlarm) : "#f5f5f5"
                    }
                    Item { Layout.fillWidth: true }
                    Item { Layout.fillWidth: true }

                    RowLabel { labelText: qsTr("MCUMode") }
                    DataCell { text: "Master" }
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
                        StatusDot { dotColor: getComStatus(serialConnected) }

                        Item { Layout.minimumWidth: 12 }

                        FluText {
                            text: qsTr("EFFS")
                            font.pixelSize: 13
                            color: FluTheme.fontPrimaryColor
                        }
                        StatusDot { 
                            dotColor: statusData ? getEFFSStatus(statusData.sysEFFS) : "#ffffff"
                        }
                    }

                    RowLayout {
                        Layout.row: 1
                        spacing: 8

                        FluText {
                            text: qsTr("RTC Voltage")
                            font.pixelSize: 13
                            color: FluTheme.fontPrimaryColor
                        }
                        DataCell { 
                            text: statusData ? statusData.rtcBattVolt.toFixed(2) : "---"
                        }
                        FluText {
                            text: "V"
                            font.pixelSize: 13
                            color: FluTheme.fontPrimaryColor
                        }
                        Item { Layout.fillWidth: true }
                    }

                    // 系统时间
                    RowLayout {
                        spacing: 8
                        Layout.row: 2
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

    // ==================== 基础组件 ====================

    // Fluent数据项组件
    component FluentDataItem: Item {
        property string label: ""
        property string value: ""
        property string unit: ""

        height: 44

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

    // 状态指示器组件
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
    }

    // ==================== 辅助函数 ====================
    function getBreakerStatus(value) {
        var intValue = parseInt(value) || 0;
        switch(intValue) {
        case 0x0001: return "On";
        case 0x0002: return "Off";
        case 0x0003: return "Trip";
        default: return "---";
        }
    }

    function getComStatus(isOpen) {
        return isOpen ? "#4caf50" : "#f44336";
    }

    function getAc1SupplyStatus(value) {
        var intValue = (parseInt(value) & 0x0001) || 0;
        return intValue === 0x0001 ? "ON" : "OFF";
    }

    function getAc2SupplyStatus(value) {
        var intValue = (parseInt(value) & 0x0010) || 0;
        return intValue === 0x0010 ? "ON" : "OFF";
    }

    function getSysStatus(value) {
        var intValue = parseInt(value) || 0;
        switch(intValue) {
        case 0x0100: return qsTr("Floating");
        case 0x0201: return qsTr("Buffer Limit");
        case 0x0302: return qsTr("Manual Equalize");
        case 0x0303: return qsTr("Cycle Equalize");
        case 0x0304: return qsTr("Capacity Equalize");
        case 0x0305: return qsTr("Current Equalize");
        case 0x0306: return qsTr("Voltage Equalize");
        case 0x0507: return qsTr("Manual Battery Test");
        case 0x0508: return qsTr("Cycle Battery Test");
        case 0x0609: return qsTr("No Module");
        case 0x070a: return qsTr("Battery Discharge");
        case 0x080b: return qsTr("Soft Start");
        case 0x090c: return qsTr("Input Power Limit");
        case 0x040d: return qsTr("Manual Diode Test");
        case 0x040e: return qsTr("Cycle Diode Test");
        case 0x0A0F: return qsTr("Energy Management");
        default: return qsTr("Unknown");
        }
    }

    function getSysAlarmStatus(value) {
        var intValue = parseInt(value) || 0;
        switch(intValue) {
        case 0x0: return qsTr("OK");
        case 0x1: return qsTr("Alarm");
        case 0x2: return qsTr("Fault");
        default: return qsTr("Unknown");
        }
    }

    function getSysAlarmStatusColor(value) {
        var intValue = parseInt(value) || 0;
        switch(intValue) {
        case 0x0: return "#e8f5e8";
        case 0x1: return "#fff3e0";
        case 0x2: return "#ffebee";
        default: return "#f5f5f5";
        }
    }

    function getEFFSStatus(value) {
        var intValue = parseInt(value) || 0;
        switch(intValue) {
        case 0x0000: return "#f44336";
        case 0x0001: return "#4caf50";
        default: return "#ffffff";
        }
    }
}
