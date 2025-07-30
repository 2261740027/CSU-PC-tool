import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0

FluContentPage {
    id: root
    title: qsTr("Dc Info")

    // ==================== 第1层：清理任务管理 ====================
    property var cleanupTasks: []
    property bool isPageActive: false

    // 定义DC分支数量常量
    readonly property int _DC_BRANCH_NUM: 10

    // ==================== 第2层：数据缓存层 ====================
    property var dcData: ({
        LoadTotalCurr: 0.0, 
        SysTotalCurr: 0.0,  
        LoadVolt: 0.0,      
        SysVolt: 0.0,       
        MainVolt: 0.0,      
        ShareVoltDiff: 0.0, 
        RectLoadRate: 0.0,  
        SysEfficiency: 0.0, 
        LoadRate: 0.0,      
        SysTotalPower: 0.0, 
        SysTotalEnergy: 0.0,
        LoadTotalPwoer: 0.0,
        Sys_A_ShareCurr: 0.0,
        Sys_B_ShareCurr: 0.0,
        LoadBreaker: 0.0,   
        ShareBreaker: 0.0,  
    })

    // DC分路数据 (1-10分路) - 参照AC Info的固定声明方式
    property var dcBranchData: ({
        branch1: createDcBranchDataStructure(),
        branch2: createDcBranchDataStructure(),
        branch3: createDcBranchDataStructure(),
        branch4: createDcBranchDataStructure(),
        branch5: createDcBranchDataStructure(),
        branch6: createDcBranchDataStructure(),
        branch7: createDcBranchDataStructure(),
        branch8: createDcBranchDataStructure(),
        branch9: createDcBranchDataStructure(),
        branch10: createDcBranchDataStructure()
    })
        
            
    // ==================== 第3层：连接管理层 ====================
    // 使用 Connections 替代直接绑定
    Connections {
        id: dataConnection
        target: pageManager
        enabled: root.isPageActive

        function onPageDataChanged() {
            console.log("DC Info - pageDataChanged signal received, isPageActive:", root.isPageActive);
            if (!root.isPageActive) {
                console.log("DC Info - Page not active, skipping update");
                return;
            }
            updateAllData();
        }
    }

    // ==================== 页面生命周期管理 ====================
    Component.onCompleted: {
        console.log("DcInfo page created");
        root.isPageActive = true;
        
        // 注册清理任务
        cleanupTasks.push(dataConnection);
        
        // 通知页面切换
        pageManager.notifyPageSwitch("infoDcInfo");
        
        // 初始化数据
        updateAllData();
    }

    Component.onDestruction: {
        console.log("DcInfo page destruction started");
        performCleanup();
    }

    // ==================== 第4层：数据更新函数 ====================

    function createDcBranchDataStructure() {
        // 使用QtObject以便QML能追踪属性变化
        // 修复：属性名改为小写开头，符合QML规范
        return Qt.createQmlObject('import QtQuick 2.0; QtObject
                                { property real loadCurr: 0.0;
                                  property real activePower: 0.0;
                                  property real energy: 0.0; }', root);
    }

    function updateAllData() {
        if (!pageManager) {
            console.error("pageManager is null or undefined");
            return;
        }
        
        if (!pageManager.pageData) {
            console.warn("pageManager.pageData is null");
            return;
        }

        // 缓存原始数据引用
        var sourceData = pageManager.pageData;
        console.log("DC Info - Source data keys:", Object.keys(sourceData));
        
        // 更新dc数据
        updateDcData(sourceData);
        updateDcBranchData(sourceData);        
        
        console.log("All data updated successfully");
    }

    function updateDcData(sourceData) {
        dcData = {
            LoadTotalCurr: sourceData.LoadTotalCurr || 0,
            SysTotalCurr: sourceData.SysTotalCurr || 0,
            LoadVolt: sourceData.LoadVolt || 0,
            SysVolt: sourceData.SysVolt || 0,
            MainVolt: sourceData.MainVolt || 0,
            ShareVoltDiff: sourceData.ShareVoltDiff || 0,
            RectLoadRate: sourceData.RectLoadRate || 0,
            SysEfficiency: sourceData.SysEfficiency || 0,
            LoadRate: sourceData.LoadRate || 0,
            SysTotalPower: sourceData.SysTotalPower || 0,
            SysTotalEnergy: sourceData.SysTotalEnergy || 0,
            LoadTotalPwoer: sourceData.LoadTotalPwoer || 0,
            Sys_A_ShareCurr: sourceData.Sys_A_ShareCurr || 0,
            Sys_B_ShareCurr: sourceData.Sys_B_ShareCurr || 0,
            LoadBreaker: sourceData.LoadBreaker || 0,
            ShareBreaker: sourceData.ShareBreaker || 0,

        }
    }

    function updateDcBranchData(sourceData) {
        // 确保dcBranchData已初始化
        if (!dcBranchData) {
            console.warn("dcBranchData is not initialized, reinitializing...");
            dcBranchData = {
                branch1: createDcBranchDataStructure(),
                branch2: createDcBranchDataStructure(),
                branch3: createDcBranchDataStructure(),
                branch4: createDcBranchDataStructure(),
                branch5: createDcBranchDataStructure(),
                branch6: createDcBranchDataStructure(),
                branch7: createDcBranchDataStructure(),
                branch8: createDcBranchDataStructure(),
                branch9: createDcBranchDataStructure(),
                branch10: createDcBranchDataStructure()
            };
        }
        
        for (var i = 1; i <= _DC_BRANCH_NUM; i++) {
            var branchKey = "branch" + i;
            var dataPrefix = "DcBranch" + i;
            if (dcBranchData[branchKey]) {
                // 使用小写属性名
                dcBranchData[branchKey].loadCurr = sourceData[dataPrefix + "LoadCurr"] || 0;
                dcBranchData[branchKey].activePower = sourceData[dataPrefix + "ActivePower"] || 0;
                dcBranchData[branchKey].energy = sourceData[dataPrefix + "Energy"] || 0;
            } else {
                // 如果对象不存在，补充创建（修复函数名）
                dcBranchData[branchKey] = createDcBranchDataStructure();
                dcBranchData[branchKey].loadCurr = sourceData[dataPrefix + "LoadCurr"] || 0;
                dcBranchData[branchKey].activePower = sourceData[dataPrefix + "ActivePower"] || 0;
                dcBranchData[branchKey].energy = sourceData[dataPrefix + "Energy"] || 0;
            }
            console.log("DC分路", branchKey, "数据:", JSON.stringify({
                loadCurr: dcBranchData[branchKey].loadCurr,
                activePower: dcBranchData[branchKey].activePower,
                energy: dcBranchData[branchKey].energy
            }));
        }
    }

    // ==================== 第5层：清理管理层 ====================
    function performCleanup() {
        console.log("Starting layered cleanup for DcInfo page");
        
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
        });
    }

    function clearDataStructures() {
        dcData = null;
        dcBranchData = null;
        console.log("All data structures cleared");
    }

    // ==================== UI 层 ====================
    anchors.fill: parent

    // 定义DC Info标签页组件
    Component {
        id: dcInfoComponent
        Rectangle {
            anchors.fill: parent
            color: "transparent"
            
            // 使用Grid布局实现紧凑显示
            GridLayout {
                anchors.fill: parent
                anchors.margins: 16
                columns: 3
                rows: 2
                columnSpacing: 16
                rowSpacing: 16
                
                // 第一行第一列：电流信息
                FluFrame {
                    id: currentInfoCard
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.preferredWidth: parent.width / 3
                    
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 8
                        
                        FluText {
                            text: qsTr("Current Information")
                            font.pixelSize: 14
                            font.bold: true
                            color: FluTheme.primaryColor
                            Layout.alignment: Qt.AlignHCenter
                            Layout.preferredHeight: 20
                        }
                        
                        GridLayout {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            columns: 1
                            rowSpacing: 4
                            
                                                            // 负载总电流
                                RowLayout {
                                    Layout.fillWidth: true
                                    FluText {
                                        text: qsTr("Load TotalCurr:")
                                        font.pixelSize: 12
                                        Layout.preferredWidth: 120
                                        elide: Text.ElideRight
                                    }
                                    //Item { Layout.fillWidth: true }
                                    FluText {
                                        text: dcData.LoadTotalCurr.toFixed(2) + " A"
                                        font.bold: true
                                        font.pixelSize: 12
                                        color: FluTheme.primaryColor
                                        Layout.alignment: Qt.AlignRight
                                    }
                                }
                            
                                                            // 系统总电流
                                RowLayout {
                                    Layout.fillWidth: true
                                    FluText {
                                        text: qsTr("System TotalCurr:")
                                        font.pixelSize: 12
                                        Layout.preferredWidth: 120
                                        elide: Text.ElideRight
                                    }
                                    //Item { Layout.fillWidth: true }
                                    FluText {
                                        text: dcData.SysTotalCurr.toFixed(2) + " A"
                                        font.bold: true
                                        font.pixelSize: 12
                                        color: FluTheme.primaryColor
                                        Layout.alignment: Qt.AlignRight
                                    }
                                }
                                
                                //  占位行的高度等于字体大小
                                //  占位行1 - 平衡高度
                                Item {
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 12
                                }
                                
                                // 占位行2 - 平衡高度
                                Item {
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 12
                                }

                        }
                    }
                }
                
                // 第一行第二列：电压信息
                FluFrame {
                    id: voltageInfoCard
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.preferredWidth: parent.width / 3
                    
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 8
                        
                        FluText {
                            text: qsTr("Voltage Information")
                            font.pixelSize: 14
                            font.bold: true
                            color: FluTheme.primaryColor
                            Layout.alignment: Qt.AlignHCenter
                            Layout.preferredHeight: 20
                        }
                        
                        GridLayout {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            columns: 1
                            rowSpacing: 4
                            
                                                            // 负载电压
                                RowLayout {
                                    Layout.fillWidth: true
                                    FluText {
                                        text: qsTr("LoadVolt:")
                                        font.pixelSize: 12
                                        Layout.preferredWidth: 120
                                        elide: Text.ElideRight
                                    }
                                    //Item { Layout.fillWidth: true }
                                    FluText {
                                        text: dcData.LoadVolt.toFixed(2) + " V"
                                        font.bold: true
                                        font.pixelSize: 12
                                        color: FluTheme.primaryColor
                                        Layout.alignment: Qt.AlignRight
                                    }
                                }
                            
                                                            // 系统电压
                                RowLayout {
                                    Layout.fillWidth: true
                                    FluText {
                                        text: qsTr("SysVolt:")
                                        font.pixelSize: 12
                                        Layout.preferredWidth: 120
                                        elide: Text.ElideRight
                                    }
                                    //Item { Layout.fillWidth: true }
                                    FluText {
                                        text: dcData.SysVolt.toFixed(2) + " V"
                                        font.bold: true
                                        font.pixelSize: 12
                                        color: FluTheme.primaryColor
                                        Layout.alignment: Qt.AlignRight
                                    }
                                }
                            
                                                                // 主电压
                                RowLayout {
                                    Layout.fillWidth: true
                                    FluText {
                                        text: qsTr("MainVolt:")
                                        font.pixelSize: 12
                                        Layout.preferredWidth: 120
                                        elide: Text.ElideRight
                                    }
                                    //Item { Layout.fillWidth: true }
                                    FluText {
                                        text: dcData.MainVolt.toFixed(2) + " V"
                                        font.bold: true
                                        font.pixelSize: 12
                                        color: FluTheme.primaryColor
                                        Layout.alignment: Qt.AlignRight
                                    }
                                }
                            
                                                                // 均压差
                                RowLayout {
                                    Layout.fillWidth: true
                                    FluText {
                                        text: qsTr("ShareVoltDiff:")
                                        font.pixelSize: 12
                                        Layout.preferredWidth: 120
                                        elide: Text.ElideRight
                                    }
                                    //Item { Layout.fillWidth: true }
                                    FluText {
                                        text: dcData.ShareVoltDiff.toFixed(2) + " V"
                                        font.bold: true
                                        font.pixelSize: 12
                                        color: Math.abs(dcData.ShareVoltDiff) > 1.0 ? "#f44336" : FluTheme.primaryColor
                                        Layout.alignment: Qt.AlignRight
                                    }
                                }
                        }
                    }
                }
                
                // 第一行第三列：功率和效率信息
                FluFrame {
                    id: powerEfficiencyInfoCard
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.preferredWidth: parent.width / 3
                    
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 8
                        
                        FluText {
                            text: qsTr("Power & Efficiency")
                            font.pixelSize: 14
                            font.bold: true
                            color: FluTheme.primaryColor
                            Layout.alignment: Qt.AlignHCenter
                            Layout.preferredHeight: 20
                        }
                        
                        GridLayout {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            columns: 1
                            rowSpacing: 4
                            
                                                            // 系统总功率
                                RowLayout {
                                    Layout.fillWidth: true
                                    FluText {
                                        text: qsTr("SysTotalPower:")
                                        font.pixelSize: 12
                                        Layout.preferredWidth: 120
                                        elide: Text.ElideRight
                                    }
                                    //Item { Layout.fillWidth: true }
                                    FluText {
                                        text: dcData.SysTotalPower.toFixed(1) + " W"
                                        font.bold: true
                                        font.pixelSize: 12
                                        color: FluTheme.primaryColor
                                        Layout.alignment: Qt.AlignRight
                                    }
                                }
                            
                                                            // 负载总功率
                                RowLayout {
                                    Layout.fillWidth: true
                                    FluText {
                                        text: qsTr("LoadTotalPower:")
                                        font.pixelSize: 12
                                        Layout.preferredWidth: 120
                                        elide: Text.ElideRight
                                    }
                                    //Item { Layout.fillWidth: true }
                                    FluText {
                                        text: dcData.LoadTotalPwoer.toFixed(1) + " W"
                                        font.bold: true
                                        font.pixelSize: 12
                                        color: FluTheme.primaryColor
                                        Layout.alignment: Qt.AlignRight
                                    }
                                }
                            
                                                            // 系统效率
                                RowLayout {
                                    Layout.fillWidth: true
                                    FluText {
                                        text: qsTr("SysEfficiency:")
                                        font.pixelSize: 12
                                        Layout.preferredWidth: 120
                                        elide: Text.ElideRight
                                    }
                                    //Item { Layout.fillWidth: true }
                                    FluText {
                                        text: dcData.SysEfficiency.toFixed(1) + " %"
                                        font.bold: true
                                        font.pixelSize: 12
                                        color: FluTheme.primaryColor  
                                        Layout.alignment: Qt.AlignRight
                                    }
                                }
                            
                                                            // 负载率
                                RowLayout {
                                    Layout.fillWidth: true
                                    FluText {
                                        text: qsTr("Load Rate:")
                                        font.pixelSize: 12
                                        Layout.preferredWidth: 120
                                        elide: Text.ElideRight
                                    }
                                    //Item { Layout.fillWidth: true }
                                    FluText {
                                        text: dcData.LoadRate.toFixed(1) + " %"
                                        font.bold: true
                                        font.pixelSize: 12
                                        color: dcData.LoadRate >= 80 ? "#f44336" : 
                                               dcData.LoadRate >= 60 ? "#ff9800" : FluTheme.primaryColor
                                        Layout.alignment: Qt.AlignRight
                                    }
                                }
                        }
                    }
                }
                
                // 第二行第一列：均流信息
                FluFrame {
                    id: currentSharingInfoCard
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.preferredWidth: parent.width / 3
                    
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 8
                        
                        FluText {
                            text: qsTr("Current Sharing")
                            font.pixelSize: 14
                            font.bold: true
                            color: FluTheme.primaryColor
                            Layout.alignment: Qt.AlignHCenter
                            Layout.preferredHeight: 20
                        }
                        
                        GridLayout {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            columns: 1
                            rowSpacing: 6
                            
                                                            // 系统A均流
                                RowLayout {
                                    Layout.fillWidth: true
                                    FluText {
                                        text: qsTr("Sys.A.ShareCurr:")
                                        font.pixelSize: 12
                                        Layout.preferredWidth: 120
                                        elide: Text.ElideRight
                                    }
                                    //Item { Layout.fillWidth: true }
                                    FluText {
                                        text: dcData.Sys_A_ShareCurr.toFixed(2) + " A"
                                        font.bold: true
                                        font.pixelSize: 12
                                        color: FluTheme.primaryColor
                                        Layout.alignment: Qt.AlignRight
                                    }
                                }
                            
                                                            // 系统B均流
                                RowLayout {
                                    Layout.fillWidth: true
                                    FluText {
                                        text: qsTr("Sys.B.ShareCurr:")
                                        font.pixelSize: 12
                                        Layout.preferredWidth: 120
                                        elide: Text.ElideRight
                                    }
                                    //Item { Layout.fillWidth: true }
                                    FluText {
                                        text: dcData.Sys_B_ShareCurr.toFixed(2) + " A"
                                        font.bold: true
                                        font.pixelSize: 12
                                        color: FluTheme.primaryColor
                                        Layout.alignment: Qt.AlignRight
                                    }
                                }
                        }
                    }
                }
                
                // 第二行第二列：开关状态
                FluFrame {
                    id: breakerStatusInfoCard
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.preferredWidth: parent.width / 3
                    
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 8
                        
                        FluText {
                            text: qsTr("Breaker Status")
                            font.pixelSize: 14
                            font.bold: true
                            color: FluTheme.primaryColor
                            Layout.alignment: Qt.AlignHCenter
                            Layout.preferredHeight: 20
                        }
                        
                        GridLayout {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            columns: 1
                            rowSpacing: 8
                            
                                                            // 负载开关
                                RowLayout {
                                    Layout.fillWidth: true
                                    FluText {
                                        text: qsTr("Load Breaker:")
                                        font.pixelSize: 12
                                        Layout.preferredWidth: 120
                                        elide: Text.ElideRight
                                    }
                                    Rectangle {
                                        width: 16
                                        height: 16
                                        radius: 8
                                        color: dcData.LoadBreaker == 0x1 ? "#4caf50" : (dcData.LoadBreaker == 0x2 || dcData.LoadBreaker == 0x3) ? "#f44336" : "#9e9e9e"
                                        border.width: 1
                                        border.color: FluTheme.primaryColor
                                    }
                                    //Item { Layout.fillWidth: true }
                                    FluText {
                                        text: getLoadBreakerStatus(dcData.LoadBreaker)
                                        font.bold: true
                                        font.pixelSize: 12
                                        color: dcData.LoadBreaker == 0x1 ? "#4caf50" : (dcData.LoadBreaker == 0x2 || dcData.LoadBreaker == 0x3) ? "#f44336" : "#9e9e9e"
                                        Layout.alignment: Qt.AlignRight
                                    }
                                }
                            
                                                            // 均流开关
                                RowLayout {
                                    Layout.fillWidth: true
                                    FluText {
                                        text: qsTr("Share Breaker:")
                                        font.pixelSize: 12
                                        Layout.preferredWidth: 120
                                        elide: Text.ElideRight
                                    }
                                    Rectangle {
                                        width: 16
                                        height: 16
                                        radius: 8
                                        color: dcData.ShareBreaker > 0 ? "#4caf50" : "#f44336"
                                        border.width: 1
                                        border.color: FluTheme.primaryColor
                                    }
                                    //Item { Layout.fillWidth: true }
                                    FluText {
                                        text: dcData.ShareBreaker > 0 ? qsTr("ON") : qsTr("OFF")
                                        font.bold: true
                                        font.pixelSize: 12
                                        color: dcData.ShareBreaker > 0 ? "#4caf50" : "#f44336"
                                        Layout.alignment: Qt.AlignRight
                                    }
                                }
                        }
                    }
                }
                
                // 第二行第三列：系统状态总览
                FluFrame {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.preferredWidth: parent.width / 3
                    
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 8
                        
                        FluText {
                            text: qsTr("System Overview")
                            font.pixelSize: 14
                            font.bold: true
                            color: FluTheme.primaryColor
                            Layout.alignment: Qt.AlignHCenter
                            Layout.preferredHeight: 20
                        }
                        
                        GridLayout {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            columns: 1
                            rowSpacing: 4
                            
                                                            // 系统总能量
                                RowLayout {
                                    Layout.fillWidth: true
                                    FluText {
                                        text: qsTr("Total Energy:")
                                        font.pixelSize: 12
                                        Layout.preferredWidth: 120
                                        elide: Text.ElideRight
                                    }
                                    //Item { Layout.fillWidth: true }
                                    FluText {
                                        text: dcData.SysTotalEnergy.toFixed(1) + " Wh"
                                        font.bold: true
                                        font.pixelSize: 12
                                        color: FluTheme.primaryColor
                                        Layout.alignment: Qt.AlignRight
                                    }
                                }
                            
                                                            // 整流负载率
                                RowLayout {
                                    Layout.fillWidth: true
                                    FluText {
                                        text: qsTr("Rect LoadRate:")
                                        font.pixelSize: 12
                                        Layout.preferredWidth: 120
                                        elide: Text.ElideRight
                                    }
                                    //Item { Layout.fillWidth: true }
                                    FluText {
                                        text: dcData.RectLoadRate.toFixed(1) + " %"
                                        font.bold: true
                                        font.pixelSize: 12
                                        color: dcData.RectLoadRate >= 80 ? "#f44336" : 
                                               dcData.RectLoadRate >= 60 ? "#ff9800" : FluTheme.primaryColor
                                        Layout.alignment: Qt.AlignRight
                                    }
                                }               
                        }
                    }
                }
            }
        }
    }

    // 定义DC Branch Info标签页组件
    Component {
        id: dcBranchInfoComponent
        Rectangle {
            anchors.fill: parent
            color: "transparent"

            // 列配置
            property var columnConfig: [
                { title: "Current", unit: "A", dataKey: "loadCurr", decimals: 2 },
                { title: "Power", unit: "W", dataKey: "activePower", decimals: 2 },
                { title: "Energy", unit: "Wh", dataKey: "energy", decimals: 2 }
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

                                    // 表头
                                    FluText {
                                        anchors.centerIn: parent
                                        text: rowLayout.currentRowIndex === 0 ? modelData.title : ""
                                        font.pixelSize: 13
                                        font.weight: Font.Medium
                                        color: FluTheme.fontPrimaryColor
                                        verticalAlignment: Text.AlignVCenter
                                        horizontalAlignment: Text.AlignHCenter
                                        visible: rowLayout.currentRowIndex === 0
                                    }

                                    // 数据单元格
                                    Rectangle {
                                        id: dataCell
                                        anchors.centerIn: parent
                                        width: 80
                                        height: 26
                                        color: FluTheme.dark ? Qt.rgba(0.18, 0.18, 0.18, 1) : Qt.rgba(0.97, 0.98, 0.98, 1)
                                        border.color: FluTheme.dark ? Qt.rgba(0.33, 0.33, 0.33, 1) : Qt.rgba(0.88, 0.88, 0.88, 1)
                                        border.width: 1
                                        radius: 2
                                        visible: rowLayout.currentRowIndex > 0

                                        FluText {
                                            anchors.centerIn: parent
                                            text: {
                                                if (rowLayout.currentRowIndex <= 0 || !dcBranchData) return "---";
                                                var branchKey = "branch" + rowLayout.currentRowIndex;
                                                var branchInfo = dcBranchData[branchKey];
                                                if (!branchInfo) return "---";
                                                var dataKey = modelData.dataKey;
                                                var decimals = modelData.decimals || 2;
                                                if (!branchInfo.hasOwnProperty(dataKey)) return "---";
                                                var result = branchInfo[dataKey].toFixed(decimals);
                                                return result;
                                            }
                                            font.pixelSize: 13
                                            color: FluTheme.fontPrimaryColor
                                            elide: Text.ElideRight
                                            verticalAlignment: Text.AlignVCenter
                                            horizontalAlignment: Text.AlignHCenter
                                        }
                                    }

                                    // 单位标签
                                    FluText {
                                        anchors.left: dataCell.right
                                        anchors.leftMargin: 8
                                        anchors.verticalCenter: dataCell.verticalCenter
                                        
                                        text: rowLayout.currentRowIndex > 0 ? (modelData.unit || "") : ""
                                        font.pixelSize: 13
                                        color: FluTheme.fontSecondaryColor
                                        visible: rowLayout.currentRowIndex > 0 && (modelData.unit || "") !== ""
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // 主标签视图
    FluTabView {
        id: tabView
        anchors.fill: parent
        anchors.margins: 10
        addButtonVisibility: false
        closeButtonVisibility: FluTabViewType.Never
        
        Component.onCompleted: {
            // 添加两个标签页
            tabView.appendTab("qrc:/image/favicon.ico", qsTr("DC Info"), dcInfoComponent, {})
            tabView.appendTab("qrc:/image/favicon.ico", qsTr("DC Branch Info"), dcBranchInfoComponent, {})
        }
    }

    function getLoadBreakerStatus(value) {
        var intValue = parseInt(value) || 0;
        switch(intValue) {
        case 0x0: return qsTr("Uninstall");
        case 0x1: return qsTr("ON");
        case 0x2: return qsTr("OFF");
        case 0x3: return qsTr("TRIP");
        default: return qsTr("Unknown");
        }
    }
}
