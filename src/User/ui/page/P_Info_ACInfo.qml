import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0

FluContentPage {
    id: root
    title: qsTr("AC Info")

    // ==================== 第1层：清理任务管理 ====================
    property var cleanupTasks: []
    property var dynamicTabs: []
    property bool isPageActive: false

    // ==================== 第2层：数据缓存层 ====================
    // AC单个信息数据结构
    property var acInfoData: ({
        ac1: createACDataStructure(),
        ac2: createACDataStructure(),
        ac3: createACDataStructure(),
        ac4: createACDataStructure(),
        ac5: createACDataStructure(),
        ac6: createACDataStructure(),
        ac7: createACDataStructure(),
        ac8: createACDataStructure(),
        ac9: createACDataStructure(),
        ac10: createACDataStructure(),
        ac11: createACDataStructure(),
        ac12: createACDataStructure(),
        ac13: createACDataStructure(),
        ac14: createACDataStructure(),
        ac15: createACDataStructure(),
        ac16: createACDataStructure()
    })

    // AC总计数据
    property var acTotalData: ({
        power: 0.0,
        energy: 0.0,
        powerFactor: 0.0,
        phase1Current: 0.0,
        phase2Current: 0.0,
        phase3Current: 0.0
    })

    // AC分路数据 (1-10分路)
    property var acBranchData: ({
        branch1: createBranchDataStructure(),
        branch2: createBranchDataStructure(),
        branch3: createBranchDataStructure(),
        branch4: createBranchDataStructure(),
        branch5: createBranchDataStructure(),
        branch6: createBranchDataStructure(),
        branch7: createBranchDataStructure(),
        branch8: createBranchDataStructure(),
        branch9: createBranchDataStructure(),
        branch10: createBranchDataStructure()
    })

    // ==================== 第3层：连接管理层 ====================
    Connections {
        id: dataConnection
        target: pageManager
        enabled: root.isPageActive

        function onPageDataChanged() {
            if (!root.isPageActive) return;
            updateAllACData();
        }
    }

    // ==================== 页面生命周期管理 ====================
    Component.onCompleted: {
        console.log("ACInfo page created");
        root.isPageActive = true;

        // 注册清理任务
        cleanupTasks.push(dataConnection);

        // 通知页面切换
        pageManager.notifyPageSwitch("infoAcInfo");

        // 创建标签页
        createTab();

        // 初始化数据
        updateAllACData();
    }

    Component.onDestruction: {
        console.log("ACInfo page destruction started");
        performCleanup();
    }

    // ==================== 第4层：数据更新函数 ====================
    function createACDataStructure() {
        return {
            phase1Voltage: 0.0,
            phase2Voltage: 0.0,
            phase3Voltage: 0.0,
            frequency: 0.0,
            breakerStatus: 0,
            phase1Current: 0.0,
            phase2Current: 0.0,
            phase3Current: 0.0
        };
    }

    function createBranchDataStructure() {
        return {
            current: 0.0,
            powerFactor: 0.0,
            activePower: 0.0,
            energy: 0.0
        };
    }

    function updateAllACData() {
        if (!pageManager.pageData) {
            console.warn("pageManager.pageData is null");
            return;
        }

        var sourceData = pageManager.pageData;
        
        // 更新AC单个信息数据
        updateACInfoData(sourceData);
        
        // 更新AC总计数据
        updateACTotalData(sourceData);
        
        // 更新AC分路数据
        updateACBranchData(sourceData);
        
        console.log("All AC data updated successfully");
    }

    function updateACInfoData(sourceData) {
        for (var i = 1; i <= 16; i++) {
            var acKey = "ac" + i;
            var dataPrefix = "AC" + i;
            
            if (acInfoData[acKey]) {
                acInfoData[acKey].phase1Voltage = sourceData[dataPrefix + "Phase1Voltage"] || 0;
                acInfoData[acKey].phase2Voltage = sourceData[dataPrefix + "Phase2Voltage"] || 0;
                acInfoData[acKey].phase3Voltage = sourceData[dataPrefix + "Phase3Voltage"] || 0;
                acInfoData[acKey].frequency = sourceData[dataPrefix + "Frequency"] || 0;
                acInfoData[acKey].breakerStatus = sourceData[dataPrefix + "BreakerStatus"] || 0;
                acInfoData[acKey].phase1Current = sourceData[dataPrefix + "Phase1Current"] || 0;
                acInfoData[acKey].phase2Current = sourceData[dataPrefix + "Phase2Current"] || 0;
                acInfoData[acKey].phase3Current = sourceData[dataPrefix + "Phase3Current"] || 0;
            }
        }
    }

    function updateACTotalData(sourceData) {
        acTotalData.power = sourceData.TotalAcPower || 0;
        acTotalData.energy = sourceData.TotalAcEnergy || 0;
        acTotalData.powerFactor = sourceData.TotalAcPowerFactor || 0;
        acTotalData.phase1Current = sourceData.TotalAcPhase1Curretn || 0;
        acTotalData.phase2Current = sourceData.TotalAcPhase2Curretn || 0;
        acTotalData.phase3Current = sourceData.TotalAcPhase3Curretn || 0;
    }

    function updateACBranchData(sourceData) {
        for (var i = 1; i <= 10; i++) {
            var branchKey = "branch" + i;
            var dataPrefix = "AcBranch" + i;
            
            if (acBranchData[branchKey]) {
                acBranchData[branchKey].current = sourceData[dataPrefix + "Current"] || 0;
                acBranchData[branchKey].powerFactor = sourceData[dataPrefix + "PowerFactor"] || 0;
                acBranchData[branchKey].activePower = sourceData[dataPrefix + "ActivePower"] || 0;
                acBranchData[branchKey].energy = sourceData[dataPrefix + "Energy"] || 0;
            }
        }
    }

    // ==================== 第5层：清理管理层 ====================
    function performCleanup() {
        console.log("Starting layered cleanup for ACInfo page");
        
        // 第1步：标记页面为非活跃状态
        root.isPageActive = false;
        
        // 第2步：清理动态创建的标签页
        clearDynamicTabs();
        
        // 第3步：断开所有连接
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
        
        // 第4步：清理数据结构
        clearDataStructures();
        
        // 第5步：清理任务列表
        cleanupTasks = null;
        dynamicTabs = null;
        
        // 第6步：强制垃圾回收
        Qt.callLater(function() {
            gc();
            console.log("ACInfo page cleanup completed");
        });
    }

    function clearDynamicTabs() {
        if (tab_view && tab_view.count > 0) {
            console.log("Clearing", tab_view.count, "dynamic tabs");
            
            // 清理所有标签页
            for (var i = tab_view.count - 1; i >= 0; i--) {
                tab_view.removeTab(i);
            }
        }
        
        // 清理标签页引用
        dynamicTabs = [];
        console.log("Dynamic tabs cleared");
    }

    function clearDataStructures() {
        acInfoData = null;
        acTotalData = null;
        acBranchData = null;
        
        console.log("AC data structures cleared");
    }

    // ==================== UI 层 ====================
    FluFrame {
        anchors.fill: parent
        anchors.bottomMargin: 8
        anchors.topMargin: 4
        anchors.rightMargin: 4

        FluTabView {
            id: tab_view
            anchors.fill: parent
            addButtonVisibility: false
            closeButtonVisibility: FluTabViewType.Never
            tabWidthBehavior: FluTabViewType.Equal
        }
    }

    // ==================== 标签页创建函数 ====================
    function createTab() {
        console.log("Creating AC Info tabs");
        
        // 创建AC Info 1-4标签页
        for(var i = 1; i <= 4; i++) {
            var acTab = tab_view.appendTab("qrc:/image/favicon.ico",
                               qsTr("AC Info " + i),
                               acInfoComponentSource,
                               {
                                   "acNumber": i,
                                   "dataPrefix": "AC" + i
                               });
            dynamicTabs.push(acTab);
        }

        // 创建AC Total Info标签页
        var totalTab = tab_view.appendTab("qrc:/image/favicon.ico",
                           qsTr("AC Total Info"),
                           acTotalInfoComponentSource,
                           {
                               "dataPrefix": "TotalAc"
                           });
        dynamicTabs.push(totalTab);
        
        // 创建AC Branch Info标签页
        var branchTab = tab_view.appendTab("qrc:/image/favicon.ico",
                           qsTr("AC Branch Info"),
                           acBranchInfoComponentSource,
                           {
                               "dataPrefix": "ACBranch"
                           });
        dynamicTabs.push(branchTab);
        
        console.log("Created", dynamicTabs.length, "tabs");
    }

    // ==================== 组件定义 ====================

    // AC信息组件源
    property Component acInfoComponentSource: Component {
        ACInfoTabContent {
            acNumber: argument ? argument.acNumber || 1 : 1
            acInfoData: root.acInfoData
        }
    }

    // AC总计信息组件源
    property Component acTotalInfoComponentSource: Component {
        ACTotalInfoTabContent {
            acTotalData: root.acTotalData
        }
    }

    // AC分路信息组件源
    property Component acBranchInfoComponentSource: Component {
        ACBranchInfoTabContent {
            acBranchData: root.acBranchData
        }
    }

    // AC信息标签页内容
    component ACInfoTabContent: Item {
        property int acNumber: 1
        property var acInfoData: null

        // AC数据配置模型
        property var acDataModel: [
            { index: 1, visible: true },
            { index: 2, visible: true },
            { index: 3, visible: acNumber !== 4 },
            { index: 4, visible: acNumber !== 4 }
        ]

        ColumnLayout {
            anchors.fill: parent
            
            Repeater {
                model: acDataModel
                
                Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 100
                    Layout.rightMargin: 16
                    Layout.leftMargin: 16
                    visible: modelData.visible

                    property string acKey: "ac" + ((acNumber - 1) * 4 + modelData.index)
                    property string acIndex: "AC" + ((acNumber - 1) * 4 + modelData.index)
                    property var currentACData: acInfoData ? acInfoData[acKey] : null

                    RowLayout {
                        anchors.fill: parent
                        spacing: 50

                        FluText {
                            Layout.alignment: Qt.AlignCenter
                            text: acIndex + ":"
                            font.pixelSize: 15
                            font.weight: Font.DemiBold
                            color: FluTheme.fontPrimaryColor
                        }

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
                            FluText { 
                                text: "SPD" + ((acNumber - 1) * 4 + modelData.index)
                                font.pixelSize: 13
                                Layout.alignment: Qt.AlignHCenter 
                            }

                            // 电压行
                            DataCell { 
                                text: (visible && currentACData) ? currentACData.phase1Voltage.toFixed(2) : "---"
                            }
                            FluText { text: "V"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }
                            DataCell { 
                                text: (visible && currentACData) ? currentACData.phase2Voltage.toFixed(2) : "---"
                            }
                            FluText { text: "V"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }
                            DataCell { 
                                text: (visible && currentACData) ? currentACData.phase3Voltage.toFixed(2) : "---"
                            }
                            FluText { text: "V"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }
                            DataCell { 
                                text: (visible && currentACData) ? currentACData.frequency.toFixed(2) : "---"
                            }
                            FluText { text: "Hz"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }
                            DataCell { 
                                text: currentACData ? getAcBreakerStatus(currentACData.breakerStatus) : "---"
                            }
                            Item { Layout.fillWidth: true }
                            StatusDot { dotColor: "#4caf50"; Layout.alignment: Qt.AlignHCenter }

                            // 电流行
                            DataCell { 
                                text: (visible && currentACData) ? currentACData.phase1Current.toFixed(2) : "---"
                            }
                            FluText { text: "A"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }
                            DataCell { 
                                text: (visible && currentACData) ? currentACData.phase2Current.toFixed(2) : "---"
                            }
                            FluText { text: "A"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }
                            DataCell { 
                                text: (visible && currentACData) ? currentACData.phase3Current.toFixed(2) : "---"
                            }
                            FluText { text: "A"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }
                            Item { Layout.fillWidth: true; Layout.columnSpan: 5 }
                        }
                    }
                }
            }
        }
    }

    // AC总计信息标签页内容
    component ACTotalInfoTabContent: Item {
        property var acTotalData: null

        // 数据配置模型
        property var acDataItems: [
            { title: "Power", unit: "kWh", getValue: function() { return acTotalData ? acTotalData.power : 0; } },
            { title: "Energy", unit: "kW", getValue: function() { return acTotalData ? acTotalData.energy : 0; } },
            { title: "PF", unit: "", getValue: function() { return acTotalData ? acTotalData.powerFactor : 0; } },
            { title: "Ia", unit: "A", getValue: function() { return acTotalData ? acTotalData.phase1Current : 0; } },
            { title: "Ib", unit: "A", getValue: function() { return acTotalData ? acTotalData.phase2Current : 0; } },
            { title: "Ic", unit: "A", getValue: function() { return acTotalData ? acTotalData.phase3Current : 0; } }
        ]

        Item {
            height: 200
            width: parent.width
            anchors.centerIn: parent

            GridLayout {
                anchors.fill: parent
                anchors.leftMargin: 30
                anchors.rightMargin: 30
                anchors.topMargin: 20
                anchors.bottomMargin: 20
                columns: 3
                rows: 2
                rowSpacing: 16
                columnSpacing: 16

                Repeater {
                    model: acDataItems

                    DataUnit {
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        title: modelData.title
                        value: modelData.getValue().toFixed(2)
                        unit: modelData.unit
                    }
                }
            }
        }
    }

    // AC分路信息标签页内容
    component ACBranchInfoTabContent: Item {
        property var acBranchData: null

        // 列配置
        property var columnConfig: [
            { title: "Current", unit: "A", dataKey: "current", decimals: 1 },
            { title: "PowerFactor", unit: " ", dataKey: "powerFactor", decimals: 2 },
            { title: "Power", unit: "W", dataKey: "activePower", decimals: 0 },
            { title: "Energy", unit: "W.h", dataKey: "energy", decimals: 0 }
        ]

        readonly property int rowHeight: 40
        readonly property int labelWidth: 120
        readonly property int totalRows: 11 // 1行表头 + 10行数据

        Item {
            anchors.fill: parent

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 0

                Repeater {
                    model: totalRows

                    RowLayout {
                        id: rowLayout
                        Layout.fillWidth: true
                        Layout.preferredHeight: rowHeight
                        Layout.alignment: Qt.AlignVCenter
                        spacing: 0

                        property int currentRowIndex: index

                        // 第一列（标签列或空白）
                        Item {
                            Layout.preferredWidth: labelWidth
                            Layout.preferredHeight: rowHeight
                            Layout.alignment: Qt.AlignVCenter

                            FluText {
                                anchors.centerIn: parent
                                text: rowLayout.currentRowIndex === 0 ? "" : ("Branch" + rowLayout.currentRowIndex + ":")
                                font.pixelSize: 13
                                font.weight: Font.Medium
                                color: FluTheme.fontPrimaryColor
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignHCenter
                            }
                        }

                        // 数据列
                        Repeater {
                            model: columnConfig

                            Item {
                                Layout.fillWidth: true
                                Layout.preferredHeight: rowHeight
                                Layout.alignment: Qt.AlignVCenter

                                // 表头或数据内容
                                Loader {
                                    anchors.fill: parent
                                    sourceComponent: rowLayout.currentRowIndex === 0 ? headerCellComponent : dataCellComponent

                                    property var columnData: modelData
                                    property int rowIndex: rowLayout.currentRowIndex
                                    property int colIndex: index
                                }
                            }
                        }
                    }
                }
            }
        }

        // 表头单元格组件
        Component {
            id: headerCellComponent

            Item {
                anchors.fill: parent
                anchors.margins: 4

                RowLayout {
                    anchors.centerIn: parent
                    width: parent.width
                    height: parent.height
                    spacing: 4

                    Item {
                        Layout.fillWidth: true
                        Layout.minimumWidth: 10
                    }

                    Rectangle {
                        Layout.preferredWidth: 80
                        Layout.maximumWidth: 100
                        Layout.preferredHeight: 26
                        Layout.alignment: Qt.AlignVCenter

                        FluText {
                            anchors.centerIn: parent
                            text: columnData.title
                            font.pixelSize: 13
                            font.weight: Font.Medium
                            color: FluTheme.fontPrimaryColor
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                        }
                    }

                    FluText {
                        text: ""
                        font.pixelSize: 13
                        Layout.preferredWidth: 20
                        Layout.alignment: Qt.AlignVCenter
                    }

                    Item {
                        Layout.fillWidth: true
                        Layout.minimumWidth: 10
                    }
                }
            }
        }

        // 数据单元格组件
        Component {
            id: dataCellComponent

            Item {
                anchors.fill: parent
                anchors.margins: 4

                RowLayout {
                    anchors.centerIn: parent
                    width: parent.width
                    height: parent.height
                    spacing: 4

                    Item {
                        Layout.fillWidth: true
                        Layout.minimumWidth: 10
                    }

                    Rectangle {
                        Layout.preferredWidth: 80
                        Layout.maximumWidth: 100
                        Layout.preferredHeight: 26
                        Layout.alignment: Qt.AlignVCenter

                        color: FluTheme.dark ? Qt.rgba(0.18, 0.18, 0.18, 1) : Qt.rgba(0.97, 0.98, 0.98, 1)
                        border.color: FluTheme.dark ? Qt.rgba(0.33, 0.33, 0.33, 1) : Qt.rgba(0.88, 0.88, 0.88, 1)
                        border.width: 1
                        radius: 2

                        FluText {
                            anchors.centerIn: parent
                            text: getBranchValue(rowIndex, columnData.dataKey, columnData.decimals)
                            font.pixelSize: 13
                            color: FluTheme.fontPrimaryColor
                            elide: Text.ElideRight
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                        }
                    }

                    FluText {
                        text: columnData.unit || ""
                        font.pixelSize: 13
                        color: FluTheme.fontSecondaryColor
                        Layout.preferredWidth: 20
                        Layout.alignment: Qt.AlignVCenter
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        visible: text !== ""
                    }

                    Item {
                        Layout.fillWidth: true
                        Layout.minimumWidth: 10
                    }
                }
            }
        }

        // 获取分路数据的辅助函数
        function getBranchValue(rowIndex, dataKey, decimals) {
            if (rowIndex <= 0 || !dataKey || !acBranchData) return "---";
            
            var branchKey = "branch" + rowIndex;
            var branchInfo = acBranchData[branchKey];
            
            if (!branchInfo || !branchInfo.hasOwnProperty(dataKey)) return "---";
            
            return branchInfo[dataKey].toFixed(decimals || 2);
        }
    }

    // ==================== 基础组件 ====================

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

    // 数据单元组件
    component DataUnit: Item {
        id: dataUnit
        
        property string title: ""
        property string value: ""
        property string unit: ""
        
        Layout.fillWidth: true
        Layout.preferredHeight: 40
        
        RowLayout {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            spacing: 10
            
            FluText {
                text: dataUnit.title
                font.pixelSize: 13
                color: FluTheme.fontPrimaryColor
                Layout.preferredWidth: 80
                Layout.alignment: Qt.AlignVCenter
                horizontalAlignment: Text.AlignRight
            }
            
            Rectangle {
                Layout.preferredWidth: 120
                Layout.preferredHeight: 26
                Layout.alignment: Qt.AlignVCenter
                color: FluTheme.dark ? Qt.rgba(0.18, 0.18, 0.18, 1) : Qt.rgba(0.97, 0.98, 0.98, 1)
                border.color: FluTheme.dark ? Qt.rgba(0.33, 0.33, 0.33, 1) : Qt.rgba(0.88, 0.88, 0.88, 1)
                border.width: 1
                radius: 2
                
                FluText {
                    anchors.centerIn: parent
                    text: dataUnit.value || "---"
                    font.pixelSize: 13
                    color: FluTheme.fontPrimaryColor
                    elide: Text.ElideRight
                }
            }
            
            FluText {
                text: dataUnit.unit
                font.pixelSize: 13
                color: FluTheme.fontSecondaryColor
                Layout.preferredWidth: 40
                Layout.alignment: Qt.AlignVCenter
                horizontalAlignment: Text.AlignLeft
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

    // ==================== 辅助函数 ====================
    function getAcBreakerStatus(status) {
        var intValue = parseInt(status) || 0;
        switch(intValue) {
            case 0x0000: return qsTr("---");
            case 0x0001: return qsTr("On");
            case 0x0002: return qsTr("Off");
            case 0x0003: return qsTr("Trip");
            default: return qsTr("---");
        }
    }
}
