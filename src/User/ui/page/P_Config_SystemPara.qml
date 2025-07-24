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

    property var sysParaOneData: Qt.createQmlObject('
        import QtQuick 2.0;
        QtObject {
            property real csuNum: 0;
            property real acNum: 0;
            property real ac10kvNum: 0;
            property real csuARectNum: 0;
            property real batteryPackNum: 0;
            property real transformerTempNum: 0;
            property real csuBRectNum: 0;
            property real csuABatteryNum: 0;
            property real transformerFanNum: 0;
            property real csuCRectNum: 0;
            property real stateBranchNum: 0;
            property real extendStateBranchNum: 0;
            property real loadFuseNum: 0;
            property real csuADcBranchNum: 0;
            property real csuBDcBranchNum: 0;
            property real mixedBoardNum: 0;
            property real meterNum: 0;
            property real acBaseFromRect: 0;
            property real diodeNUm: 0;
            property real fanRotationCycle: 0;
            property real mainVoltage: 0;
            property real mainCurrent: 0;
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

    Connections {
        id: itemSetResultConnection
        target: pageManager
        enabled: root.isPageActive
        function onItemSetResult(name, resultCode, message) {
            console.log("itemSetResult:", name, resultCode, message);
            if(resultCode === 0)
            {
                showSuccess(qsTr("set success!"))
            }
            else
            {
                showError(qsTr("set failed!"))
            }
        }
    }



    // ==================== 页面生命周期管理 ====================
    Component.onCompleted: {
        console.log("configSys page created");
        root.isPageActive = true;

        // 注册清理任务
        cleanupTasks.push(dataConnection);
        cleanupTasks.push(itemSetResultConnection);

        // 通知页面切换
        pageManager.notifyPageSwitch("configSys");

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
            console.log("sysConfig page cleanup completed");
        });
    }

    function clearDataStructures() {
        sysConfigData = null;
        console.log("sysConfig data structures cleared");
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
    
   
    // ==================== combox选项 ============================
    property var acDataModel: [ {label: "", setName: "", editable: true, options: [] } ]

    property var sysParaOneDataModel: [{label: qsTr("csuNum"), setName: "csuNum", editable: false, options: [] },
                                       {label: qsTr("AC Num"), setName: "acNum", editable: true, options: [] },
                                       {label: qsTr("10kV AC NUM"), setName: "ac10kvNum", editable: true, options: [] },
                                       {label: qsTr("*CSU-A Rect Num"), setName: "csuARectNum", editable: true, options: [] },
                                       {label: qsTr("Battery Pack Num"), setName: "batteryPackNum", editable: true, options: [] },
                                       {label: qsTr("Transfomer Temp Unit Num"), setName: "transformerTempNum", editable: true, options: [] },
                                       {label: qsTr("*CSU-B Rect Num"), setName: "csuBRectNum", editable: true, options: [] },
                                       {label: qsTr("CSUA Battery"), setName: "csuABatteryNum", editable: true, options: [] },
                                       {label: qsTr("Transformer Fan Num"), setName: "transformerFanNum", editable: true, options: [] },
                                       {label: qsTr("*CSU-C Rect Num"), setName: "csuCRectNum", editable: true, options: [] },
                                       {label: qsTr("State Branch Num"), setName: "stateBranchNum", editable: true, options: [] },
                                       {label: qsTr("Extend State Branch Num"), setName: "extendStateBranchNum", editable: true, options: [] },
                                       {label: qsTr("Load Fuse Num"), setName: "loadFuseNum", editable: true, options: [] },
                                       {label: qsTr("CSUA DC Branch Num"), setName: "csuADcBranchNum", editable: true, options: [] },
                                       {label: qsTr("CSUB DC Branch Num"), setName: "csuBDcBranchNum", editable: true, options: [] },
                                       {label: qsTr("Mixed Board Num"), setName: "mixedBoardNum", editable: true, options: [] },
                                       {label: qsTr("Meter Num"), setName: "meterNum", editable: true, options: [] },
                                       {label: qsTr("AC Base From Rect"), setName: "acBaseFromRect", editable: true, options: [] },
                                       {label: qsTr("Diode Num"), setName: "diodeNum", editable: true, options: [] },
                                       {label: qsTr("Fan Rotation Cycle"), setName: "fanRotationCycle", editable: true, options: [] },
                                       {label: qsTr("Main Voltage"), setName: "mainVoltage", editable: true, options: [] },
                                       {label: qsTr("Main Current"), setName: "mainCurrent", editable: true, options: [] }]

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

    // ==================== UI显示 ============================

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

    property Component sysConfigComponentSource: Component {
        SysConfigTabContent {}
    }

    property Component sysParaOneComponentSource: Component {
        SysParaOne {}
    }


    // system Config组件
    component SysConfigTabContent: Item {

        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 20
        anchors.bottomMargin: 20


        height: parent.height
        width: (parent.width/4)*3

        GridLayout {
            anchors.centerIn: parent
            height: parent.height
            anchors.bottomMargin: 32
            columnSpacing: 100
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

            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 32
                Layout.preferredWidth: 240
                spacing: 8
                Item{
                    id: clearEnergyFrameItem
                    Layout.preferredWidth: 100
                }
                FluButton {
                    Layout.preferredWidth: 140
                    anchors.leftMargin: 8

                    text: qsTr("Clear Energy")
                    onClicked: {

                        console.log("Save button clicked");
                        pageManager.setItemData("clearEnergy", 1);
                    }
                }
            }
        }
    }
    // system para. 1
    component SysParaOne: Item{
        id: sysParaOneRoot

        anchors.fill:parent
        property var valueType: 0       

        FluRadioButtons {
            spacing: 8
            orientation: Qt.Horizontal
            currentIndex: sysParaOneRoot.valueType
            

            FluRadioButton {
                text:"value"
                onClicked: {
                    sysParaOneRoot.valueType = 0
                }
            }

            FluRadioButton {
                text:"Max"
                onClicked: {
                    sysParaOneRoot.valueType = 1
                }
            }

            FluRadioButton {
                text:"Min"
                onClicked: {
                    sysParaOneRoot.valueType = 2
                }
            }
        }

        GridLayout {
            anchors.centerIn: parent
            //height: parent.height
            anchors.bottomMargin: 32
            columnSpacing: 100
            rowSpacing: 24
            columns: 3
        
            Repeater {
                model: sysParaOneDataModel
                Layout.alignment: Qt.AlignRight
                SystemParaTextBox {
                    label: modelData.label
                    setName: modelData.setName
                    editable: modelData.editable
                    valueType: sysParaOneRoot.valueType
                    // model: modelData.options
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
        Layout.preferredHeight: 32
        Layout.preferredWidth: 240

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
                    //showSuccess(qsTr("This is an InfoBar in the Success Style"))

                    pageManager.setItemData(systemParaItemRoot.setName, selectedOption.value);
                }
            }
        }
    }

    component SystemParaTextBox: Item {
        id: systemParaTextBoxRoot
        property string label: ""
        property string setName: ""
        property bool editable: true
        property var valueType: 0

        Layout.fillWidth: true
        Layout.preferredHeight: 32
        Layout.preferredWidth: 200

        RowLayout {
            spacing: 8

            FluText {
                Layout.preferredWidth: 100
                Layout.fillWidth: true
                text: label + ":"
                horizontalAlignment: Text.AlignRight
            }

            FluTextBox {
                id: dataInput
                Layout.preferredWidth: 100
                Layout.fillWidth: true

                property string valueKey: systemParaTextBoxRoot.setName + getSysParaPostfix(systemParaTextBoxRoot.valueType)
                property var valueData: pageManager.pageData[valueKey]

                enabled: systemParaTextBoxRoot.editable && (valueData !== undefined)
                text: valueData !== undefined ? valueData : "---"

                validator: RegularExpressionValidator {
                    // 允许负号，1位可以是0或-0，2位及以上不能以0开头
                    regularExpression: /^-?(0|[1-9]\d{0,5})(\.\d{1,2})?$/
                }

                onCommit: {
                    //console.log("onPressed", dataInput.text);
                    console.log("valueType", systemParaTextBoxRoot.valueType);
                    handleSysParaValueSet(systemParaTextBoxRoot.setName, systemParaTextBoxRoot.valueType, dataInput.text)
                }
            }
        }
    }

    function createTab() {
        console.log("Creating AC Info tabs");

        var sysConfigTab = tab_view.appendTab("qrc:/image/favicon.ico",
                                              qsTr("System config"),
                                              sysConfigComponentSource,
                                              );
        dynamicTabs.push(sysConfigTab);

        var sysParaOneTab = tab_view.appendTab("qrc:/image/favicon.ico",
                                               qsTr("System para. 1"),
                                               sysParaOneComponentSource,
                                               );
        dynamicTabs.push(sysParaOneTab);

        console.log("Created", dynamicTabs.length, "tabs");
    }

    function handleSysParaValueSet(setName, valueType, value)
    {
        if(valueType === 0)  // value
        {
            pageManager.setItemData(setName, value);
            //sysParaOneData[setName] = value
        }
        else if(valueType === 1) // max
        {
            //sysParaOneData[setName] = value
        }
        else if(valueType === 2) // min
        {

        }

    }

    function getSysParaPostfix(valueType)
    {
        if(valueType === 0)
        {
            return ""
        }
        else if(valueType === 1)
        {
            return "Max"
        }
        else if(valueType === 2)
        {
            return "Min"
        }
    }
}
