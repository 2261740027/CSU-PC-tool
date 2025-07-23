import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0

FluContentPage {
    id: root
    title: qsTr("System Parameter")

    // ==================== 第1层：清理任务管理 ====================
    property var cleanupTasks: []
    property var dynamicTabs: []
    property bool isPageActive: false

    // ==================== 第2层：数据缓存层 ====================

    property var sysConfigData: Qt.createQmlObject('
        import QtQuick 2.0;
        QtObject {
            property real systemMode: 0;
            property real loadCurrSrc: 0;
            property real rectifierModel: 0;
            property real gfdFunc: 0;
            property real sysVoltageMode: 0;
            property real calStoragePos: 0;
            property real batteryConnectType: 0;
            property real essFunction: 0;
            property real limitInputPower: 0;
            property real limitBuffCurr: 0;
            property real rectifierVpgmCmd: 0;
            property real essInterface: 0;
            property real battery: 0;
            property real batteryMicroCurrent: 0;
            property real buzzer: 0;
            property real sysAShareFunc: 0;
            property real sysBShareFunc: 0;
            property real acSenseSource: 0;
            property real sysWorkMode: 0;
            property real rectVoltageIncrease: 0;
            property real rectStartUpInSequence: 0;
        }', root)

    
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
        console.log("configSys page created");
        root.isPageActive = true;

        // 注册清理任务
        cleanupTasks.push(dataConnection);

        // 通知页面切换
        pageManager.notifyPageSwitch("configSys");

        // 初始化数据
        updateAllACData();
    }

    Component.onDestruction: {
        console.log("ACInfo page destruction started");
        performCleanup();
    }

   // ==================== 第4层：数据更新函数 ====================
    function updateAllACData() {
        if (!pageManager.pageData) {
            console.warn("pageManager.pageData is null");
            return;
        }

        var sourceData = pageManager.pageData;
        
        // 更新sysConfig数据
        updateSysConfigData(sourceData);
        
        console.log("All sysConfig data updated successfully");
    }

    function updateSysConfigData(sourceData) {

        sysConfigData.systemMode = sourceData["systemMode"] || 0;
        sysConfigData.loadCurrSrc = sourceData["loadCurrSrc"] || 0;
        sysConfigData.rectifierModel = sourceData["rectifierModel"] || 0;
        sysConfigData.gfdFunc = sourceData["gfdFunc"] || 0;
        sysConfigData.sysVoltageMode = sourceData["sysVoltageMode"] || 0;
        sysConfigData.calStoragePos = sourceData["calStoragePos"] || 0;
        sysConfigData.batteryConnectType = sourceData["batteryConnectType"] || 0;
        sysConfigData.essFunction = sourceData["essFunction"] || 0;
        sysConfigData.limitInputPower = sourceData["limitInputPower"] || 0;
        sysConfigData.limitBuffCurr = sourceData["limitBuffCurr"] || 0;
        sysConfigData.rectifierVpgmCmd = sourceData["rectifierVpgmCmd"] || 0;
        sysConfigData.essInterface = sourceData["essInterface"] || 0;
        sysConfigData.battery = sourceData["battery"] || 0;
        sysConfigData.batteryMicroCurrent = sourceData["batteryMicroCurrent"] || 0;
        sysConfigData.buzzer = sourceData["buzzer"] || 0;
        sysConfigData.sysAShareFunc = sourceData["sysAShareFunc"] || 0;
        sysConfigData.sysBShareFunc = sourceData["sysBShareFunc"] || 0;
        sysConfigData.acSenseSource = sourceData["acSenseSource"] || 0;
        sysConfigData.sysWorkMode = sourceData["sysWorkMode"] || 0;
        sysConfigData.rectVoltageIncrease = sourceData["rectVoltageIncrease"] || 0;
        sysConfigData.rectStartUpInSequence = sourceData["rectStartUpInSequence"] || 0;
    }

    // ==================== 第5层：清理管理层 ====================
    function performCleanup() {
        console.log("Starting layered cleanup for sysConfig page");
        
        // 第1步：标记页面为非活跃状态
        root.isPageActive = false;
        
        // 第2步：清理动态创建的标签页
        // clearDynamicTabs();
        
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
        //dynamicTabs = null;
        
        // 第6步：强制垃圾回收
        Qt.callLater(function() {
            gc();
            console.log("ACInfo page cleanup completed");
        });
    }

    function clearDataStructures() {
        sysConfigData = null;
        console.log("sysConfig data structures cleared");
    }
    
   
    // combox选项
    property var acDataModel: [ {label: "", setName: "", editable: true, options: [] } ]

    Loader {
        id: optionLoader
        source: "qrc:/User/ui/page/pageComBoxOption/Option_SystemPara.qml"
        onLoaded: {
            root.acDataModel = [ {label: "Sys Pattern",     setName: "systemMode",editable: true, options: optionLoader.item.optionSysPattern },
                                 {label: "Load Curr SRC",   setName: "loadCurrSrc",editable: true, options: optionLoader.item.optionLoadCurrSrc  },
                                 {label: "Rect Model",      setName: "rectifierModel",editable: true, options: optionLoader.item.optionRectModel },
                                 {label: "GFD FUNC",        setName: "gfdFunc",editable: true, options: optionLoader.item.optionGfdFunc  },
                                 {label: "Volt Spec",       setName: "sysVoltageMode",editable: false, options: optionLoader.item.optionSysVoltageMode },
                                 {label: "Calib Para Pos",     setName: "calStoragePos",editable: true, options: optionLoader.item.optionCalStoragePos },
                                 {label: "Battery Connect Type", setName: "batteryConnectType",editable: true, options: optionLoader.item.optionBatteryConnectType },
                                 {label: "ESS Function",       setName: "essFunction",editable: true, options: optionLoader.item.optionESSFunction },
                                 {label: "Limit Input Power", setName: "limitInputPower",editable: true, options: optionLoader.item.optionLimitInputPower },
                                 {label: "Limit Buff Curr",   setName: "limitBuffCurr",editable: true, options: optionLoader.item.optionLimitBuffCurr },
                                 {label: "Rect Cmd Type", setName: "rectifierVpgmCmd",editable: true, options: optionLoader.item.optionRectifierVpgmCmd },
                                 {label: "ESS Interface",      setName: "essInterface",editable: true, options: optionLoader.item.optionESSInterface },
                                 {label: "Battery Type",            setName: "battery",editable: true, options: optionLoader.item.optionBattery },
                                 {label: "MicroCurr Detec", setName: "batteryMicroCurrent",editable: true, options: optionLoader.item.optionBatteryMicroCurrent },
                                 {label: "Buzzer", setName: "buzzer",editable: true, options: optionLoader.item.optionBuzzer },
                                 {label: "SysA Share Func", setName: "sysAShareFunc",editable: true, options: optionLoader.item.optionSysAShareFunc },
                                 {label: "SysB Share Func", setName: "sysBShareFunc",editable: true, options: optionLoader.item.optionSysBShareFunc },
                                 {label: "AC Sense Source", setName: "acSenseSource",editable: true, options: optionLoader.item.optionAcSenseSource },
                                 {label: "Sys Work Mode", setName: "sysWorkMode",editable: true, options: optionLoader.item.optionSysWorkMode },
                                 {label: "Rect Voltage Increase", setName: "rectVoltageIncrease",editable: true, options: optionLoader.item.optionRectVoltageIncrease },
                                 {label: "Rect Start Up In Sequence", setName: "rectStartUpInSequence",editable: true, options: optionLoader.item.optionRectStartUpInSequence }
                                ];
        }
    }

    FluFrame {

        anchors.fill: parent
        anchors.bottomMargin: 8
        anchors.topMargin: 4
        anchors.rightMargin: 4

        Item{
            anchors.centerIn: parent
            height: parent.height
            width: (parent.width/4)*3

            GridLayout {
                anchors.fill: parent
                anchors.bottomMargin: 32
                columns: 2

                Repeater {
                    model: acDataModel
                    Layout.alignment: Qt.AlignRight
                    SystemParaItem {
                        label: modelData.label
                        setName: modelData.setName
                        model: modelData.options
                        editable: modelData.editable
                    }
                }


                Item{
                    Layout.fillWidth: true
                    
                    Item{
                        id: clearEnergyFrameItem
                        width:108
                        height:32
                    }

                    FluButton {
                        anchors.left: clearEnergyFrameItem.right
                        width:140
                        
                        text: qsTr("Clear Energy")
                        onClicked: {

                            console.log("Save button clicked");
                            pageManager.setItemData("clearEnergy", 1);
                        }
                    }
                }
                
            }

        }

    }

    component SystemParaItem: Item {
        id: systemParaItemRoot
        property string label: ""
        property string setName: ""
        property bool editable: true
        property var model

        Layout.fillWidth: true

        RowLayout {
            spacing: 8

            FluText {
                Layout.preferredWidth: 100
                Layout.fillWidth: true

                text: label+":"
                horizontalAlignment: Text.AlignRight
                
            }

            FluComboBox {
                Layout.preferredWidth: 140
                Layout.fillWidth: true
                
                editable: false
                enabled: systemParaItemRoot.editable
                model: systemParaItemRoot.model
                textRole: "text"
                
                contentItem: FluText {
                    anchors.fill: parent
                    anchors.leftMargin: 8

                    text: (root.sysConfigData && model[root.sysConfigData[systemParaItemRoot.setName]]) ? model[root.sysConfigData[systemParaItemRoot.setName]].text : ""
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }

                onActivated: {
                    var selectedOption = model[currentIndex];
                    currentIndex = root.sysConfigData ? root.sysConfigData[systemParaItemRoot.setName] : 0;

                    console.log("Selected:", systemParaItemRoot.setName, "Value:", selectedOption.value);
                    showSuccess(qsTr("This is an InfoBar in the Success Style"))

                    pageManager.setItemData(systemParaItemRoot.setName, selectedOption.value);
                }
            }
        }
    }
}
