import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0

FluContentPage {
    id: root
    title: qsTr("10Kv Isolator")

    property var colors: [FluColors.Yellow, FluColors.Orange, FluColors.Red, FluColors.Magenta, FluColors.Purple, FluColors.Blue, FluColors.Teal, FluColors.Green]

    // ==================== 第1层：清理任务管理 ====================
    property var cleanupTasks: []
    property bool isPageActive: false

    // ==================== 第2层：数据缓存层 ====================
    // 分组数据结构 - 便于管理和清理
    property var acData: ({
        uab: 0.0,
        ubc: 0.0, 
        uca: 0.0,
        freq: 0.0,
        breaker: 0,
        iab: 0.0,
        ibc: 0.0,
        ica: 0.0
    })

    property var transformerPrimaryData: ({
        tempStatus: 0,
        tempA: 0.0,
        tempB: 0.0,
        tempC: 0.0
    })

    property var transformerSecondaryData: ({
        tempStatus: 0,
        tempA: 0.0,
        tempB: 0.0,
        tempC: 0.0
    })

    property var fanData: ({
        fan1: createFanDataStructure(),
        fan2: createFanDataStructure(),
        fan3: createFanDataStructure(),
        fan4: createFanDataStructure()
    })

    property var doorData: ({
        entryCabinet: 0,
        phaseShifting: 0
    })

    // ==================== 第3层：连接管理层 ====================
    // 使用 Connections 替代直接绑定
    Connections {
        id: dataConnection
        target: pageManager
        enabled: root.isPageActive

        function onPageDataChanged() {
            if (!root.isPageActive) return;
            updateLocalData();
        }
    }

    // 注册清理任务
    Component.onCompleted: {
        console.log("10KvIsolator page created");
        root.isPageActive = true;
        
        // 注册所有需要清理的连接
        cleanupTasks.push(dataConnection);
        
        // 通知页面切换
        pageManager.notifyPageSwitch("info10KvIsolator");
        
        // 初始化数据
        updateLocalData();
    }

    Component.onDestruction: {
        console.log("10KvIsolator page destruction started");
        performCleanup();
    }

    // ==================== 第4层：数据更新函数 ====================
    function createFanDataStructure() {
            return Qt.createQmlObject('import QtQuick 2.0; QtObject
                                  { property real status: 0;
                                  property real speed: 0;
                                  property real breakerStatus: 0;
                                  property real contactorStatus: 0; 
                                  property real temp: 0}', root);
    }

    function updateLocalData() {
        if (!pageManager.pageData) {
            console.warn("pageManager.pageData is null");
            return;
        }

        // 缓存原始数据引用（避免重复访问）
        var sourceData = pageManager.pageData;
        
        // 更新AC数据

        acData = {
            uab: sourceData.AC1Phase1Voltage10Kv || 0,
            ubc: sourceData.AC1Phase2Voltage10Kv || 0,
            uca: sourceData.AC1Phase3Voltage10Kv || 0,
            freq: sourceData.AcFrequency10Kv || 0,
            breaker: sourceData.ACBreaker10Kv || 0,
            iab: sourceData.AC1Phase1Current10Kv || 0,
            ibc: sourceData.AC1Phase2Current10Kv || 0,
            ica: sourceData.AC1Phase3Current10Kv || 0
        }

        // 更新变压器原边数据
        transformerPrimaryData = {
            tempStatus: sourceData.TransformerPriTempStatus || 0,
            tempA: sourceData.TransformerPriTempA || 0,
            tempB: sourceData.TransformerPriTempB || 0,
            tempC: sourceData.TransformerPriTempC || 0
        }

        // 更新变压器副边数据
        transformerSecondaryData = {
            tempStatus: sourceData.TransformerSecTempStatus || 0,
            tempA: sourceData.TransformerSecTempA || 0,
            tempB: sourceData.TransformerSecTempB || 0,
            tempC: sourceData.TransformerSecTempC || 0
        }

        // 更新风扇数据
        updateFanData(fanData.fan1, sourceData, "Fan1");
        updateFanData(fanData.fan2, sourceData, "Fan2");
        updateFanData(fanData.fan3, sourceData, "Fan3");
        updateFanData(fanData.fan4, sourceData, "Fan4");

        // 更新门状态数据
        doorData = {
            entryCabinet: sourceData.EntryCabinetDoor || 0,
            phaseShifting: sourceData.PhaseShiftingDoor || 0
        }

    }

    function updateFanData(fanObj, sourceData, fanPrefix) {
        fanObj.status = sourceData[fanPrefix + "Status"] || 0;
        fanObj.speed = sourceData[fanPrefix + "Speed"] || 0;
        fanObj.breakerStatus = sourceData[fanPrefix + "BreakerStatus"] || 0;
        fanObj.contactorStatus = sourceData[fanPrefix + "ContactorStatus"] || 0;
        fanObj.temp = sourceData[fanPrefix + "Temp"] || 0;
    }

    // ==================== 第5层：清理管理层 ====================
    function performCleanup() {
        console.log("Starting layered cleanup for 10KvIsolator page");
        
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
            console.log("10KvIsolator page cleanup completed");
        });
    }

    function clearDataStructures() {
        // 清理所有数据对象
        acData = null;
        transformerPrimaryData = null;
        transformerSecondaryData = null;
        fanData = null;
        doorData = null;
        
        console.log("Data structures cleared");
    }

    // ==================== UI 层 ====================
    ColumnLayout {
        anchors.fill: parent
        anchors.topMargin: 4
        anchors.bottomMargin: 8
        anchors.rightMargin: 4
        spacing: 4

        // AC 信息框架
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

                    // Row 1 - 电压
                    FluTextBox { 
                        text: acData ? acData.uab.toFixed(2) : "---"
                        Layout.fillWidth: true; Layout.fillHeight: true; readOnly: true; font.pixelSize: 11 
                    }
                    FluText { text: "kV"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }
                    FluTextBox { 
                        text: acData ? acData.ubc.toFixed(2) : "---"
                        Layout.fillWidth: true; Layout.fillHeight: true; readOnly: true; font.pixelSize: 11 
                    }
                    FluText { text: "kV"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }
                    FluTextBox { 
                        text: acData ? acData.uca.toFixed(2) : "---"
                        Layout.fillWidth: true; Layout.fillHeight: true; readOnly: true; font.pixelSize: 11 
                    }
                    FluText { text: "kV"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }
                    FluTextBox { 
                        text: acData ? acData.freq.toFixed(2) : "---"
                        Layout.fillWidth: true; Layout.fillHeight: true; readOnly: true; font.pixelSize: 11 
                    }
                    FluText { text: "Hz"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }
                    DataCell { 
                        text: acData ? getBreakerStatus(acData.breaker) : "---"
                    }

                    // Row 2 - 电流
                    FluTextBox { 
                        text: acData ? acData.iab.toFixed(2) : "---"
                        Layout.fillWidth: true; Layout.fillHeight: true; readOnly: true; font.pixelSize: 11 
                    }
                    FluText { text: "A"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }
                    FluTextBox { 
                        text: acData ? acData.ibc.toFixed(2) : "---"
                        Layout.fillWidth: true; Layout.fillHeight: true; readOnly: true; font.pixelSize: 11 
                    }
                    FluText { text: "A"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }
                    FluTextBox { 
                        text: acData ? acData.ica.toFixed(2) : "---"
                        Layout.fillWidth: true; Layout.fillHeight: true; readOnly: true; font.pixelSize: 11 
                    }
                    FluText { text: "A"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }
                }
            }
        }

        // 门状态框架
        FluFrame {
            Layout.fillWidth: true
            Layout.preferredHeight: 32

            RowLayout {
                spacing: 8

                FluText {
                    Layout.margins: 8
                    text: qsTr("Entry cabinet door")
                    font.pixelSize: 13
                    color: FluTheme.fontPrimaryColor
                }
                StatusDot { 
                    dotColor: doorData ? getDoorState(doorData.entryCabinet) : "#f44336"
                }

                Item { Layout.minimumWidth: 50 }

                FluText {
                    text: qsTr("Phase-shifting door")
                    font.pixelSize: 13
                    color: FluTheme.fontPrimaryColor
                }
                StatusDot { 
                    dotColor: doorData ? getDoorState(doorData.phaseShifting) : "#f44336"
                }
            }
        }

        // 主要内容网格
        GridLayout {
            columns: 2
            rowSpacing: 8
            columnSpacing: 8
            Layout.fillWidth: true
            Layout.fillHeight: true

            // 变压器原边
            TransformerPrimaryInfo {
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.preferredWidth: parent.width * 0.5
                tempData: transformerPrimaryData
            }

            // 变压器副边
            TransformerSecondaryInfo {
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.preferredWidth: parent.width * 0.5
                tempData: transformerSecondaryData
            }

            // 风扇信息
            FanInfo {
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.preferredWidth: parent.width * 0.5
                fanNumber: 1
                fanData: root.fanData ? root.fanData.fan1 : null
            }

            FanInfo {
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.preferredWidth: parent.width * 0.5
                fanNumber: 2
                fanData: root.fanData ? root.fanData.fan2 : null
            }

            FanInfo {
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.preferredWidth: parent.width * 0.5
                fanNumber: 3
                fanData: root.fanData ? root.fanData.fan3 : null
            }

            FanInfo {
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.preferredWidth: parent.width * 0.5
                fanNumber: 4
                fanData: root.fanData ? root.fanData.fan4 : null
            }
        }
    }

    // ==================== 组件定义 ====================
    
    // 变压器原边信息组件
    component TransformerPrimaryInfo: Item {
        property var tempData: null

        FluFrame {
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
                        color: FluTheme.fontPrimaryColor
                    }

                    DataCell {
                        Layout.leftMargin: 8
                        Layout.fillWidth: false
                        Layout.preferredWidth: 100
                        text: tempData ? tempData.tempStatus.toString() : "---"
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
                        color: FluTheme.fontPrimaryColor
                    }
                    DataCell {
                        text: tempData ? (tempData.tempA.toFixed(2) + "℃") : "---"
                    }

                    FluText {
                        text: "B phase: "
                        font.pixelSize: 13
                        color: FluTheme.fontPrimaryColor
                    }
                    DataCell {
                        text: tempData ? (tempData.tempB.toFixed(2) + "℃") : "---"
                    }

                    FluText {
                        text: "C phase: "
                        font.pixelSize: 13
                        color: FluTheme.fontPrimaryColor
                    }
                    DataCell {
                        text: tempData ? (tempData.tempC.toFixed(2) + "℃") : "---"
                    }
                }
            }
        }
    }

    // 变压器副边信息组件
    component TransformerSecondaryInfo: Item {
        property var tempData: null

        FluFrame {
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
                        text: "Transformer secondary side"
                        font.pixelSize: 13
                        color: FluTheme.fontPrimaryColor
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter
                    spacing: 8

                    FluText {
                        text: "Temperature secondary status:"
                        font.pixelSize: 13
                        color: FluTheme.fontPrimaryColor
                    }

                    DataCell {
                        Layout.leftMargin: 8
                        Layout.fillWidth: false
                        Layout.preferredWidth: 100
                        text: tempData ? tempData.tempStatus.toString() : "---"
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
                        color: FluTheme.fontPrimaryColor
                    }
                    DataCell {
                        text: tempData ? (tempData.tempA.toFixed(2) + "℃") : "---"
                    }

                    FluText {
                        text: "B phase: "
                        font.pixelSize: 13
                        color: FluTheme.fontPrimaryColor
                    }
                    DataCell {
                        text: tempData ? (tempData.tempB.toFixed(2) + "℃") : "---"
                    }

                    FluText {
                        text: "C phase: "
                        font.pixelSize: 13
                        color: FluTheme.fontPrimaryColor
                    }
                    DataCell {
                        text: tempData ? (tempData.tempC.toFixed(2) + "℃") : "---"
                    }
                }
            }
        }
    }

    // 风扇信息组件
    component FanInfo: Item {
        property int fanNumber: 1
        property var fanData: null

        //property var fanItemData: fanData.fan1

        FluFrame {
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
                        text: "Fan" + fanNumber + " Info"
                        font.pixelSize: 13
                        color: FluTheme.fontPrimaryColor
                    }
                }

                GridLayout {
                    columns: 6
                    rowSpacing: 8
                    columnSpacing: 8
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    FluText {
                        text: "Fan Status: "
                        font.pixelSize: 13
                        Layout.alignment: Qt.AlignVCenter
                        color: FluTheme.fontPrimaryColor
                    }
                    DataCell {
                        text: fanData ? fanData.status : "---"
                    }

                    FluText {
                        text: "Fan Speed: "
                        font.pixelSize: 13
                        Layout.alignment: Qt.AlignVCenter
                        color: FluTheme.fontPrimaryColor
                    }
                    DataCell {
                        text: fanData ? fanData.speed.toFixed(0) : "---"
                    }

                    FluText {
                        text: "Fan temp: "
                        font.pixelSize: 13
                        Layout.alignment: Qt.AlignVCenter
                        color: FluTheme.fontPrimaryColor
                    }
                    DataCell {
                        text: fanData ? (fanData.temp.toFixed(1) + "℃") : "---"
                    }

                    FluText {
                        text: "Breaker: "
                        font.pixelSize: 13
                        Layout.alignment: Qt.AlignVCenter
                        color: FluTheme.fontPrimaryColor
                    }
                    DataCell {
                        text: fanData ? getFanDigitalStatus(fanData.breakerStatus) : "---"
                    }

                    FluText {
                        text: "Contactor: "
                        font.pixelSize: 13
                        Layout.alignment: Qt.AlignVCenter
                        color: FluTheme.fontPrimaryColor
                    }
                    DataCell {
                        text: fanData ? getFanDigitalStatus(fanData.contactorStatus) : "---"
                    }

                    FluText {
                        text: "Fan test: "
                        font.pixelSize: 13
                        Layout.alignment: Qt.AlignVCenter
                        color: FluTheme.fontPrimaryColor
                    }
                    FluToggleButton {
                        text: qsTr("start")
                        font.pixelSize: 11
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignVCenter
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
    }

    // 数据单元格组件
    component DataCell: Rectangle {
        property string text: ""
        property string cellColor: FluTheme.dark ? "#2d2d2d" : "#f8f9fa"
        property string textColor: ""

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

    // ==================== 辅助函数 ====================
    function getBreakerStatus(status) {
        var intValue = parseInt(status) || 0;
        switch(intValue) {
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

    function getDoorState(status) {
        var intValue = parseInt(status) || 0;
        switch(intValue) {
        case 0x0000:
            return "#f44336";
        case 0x0001:
            return "#4caf50";
        default:
            return "#f44336";
        }
    }

    function getFanDigitalStatus(status) {
        var intValue = parseInt(status) || 0;
        switch(intValue) {
        case 0x0000:
            return qsTr("on");
        case 0x0001:
            return qsTr("off");
        default:
            return "---";
        }
    }
}
