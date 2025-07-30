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
    // 添加页面数据缓存，避免深层绑定
    property var pageDataCache: null
    property var pageAttributeCache: null

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
            updateAllData();
        }
    }

    Connections {
        id: itemSetResultConnection
        target: pageManager
        enabled: root.isPageActive
        function onItemSetResult(name, resultCode, message) {
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

    // 添加页面属性变化监听
    Connections {
        id: pageAttributeConnection
        target: pageManager
        enabled: root.isPageActive
        function onPageAttributeChanged() {
            if (!root.isPageActive) return;
            updatePageAttributeCache();
        }
    }


    // ==================== 页面生命周期管理 ====================
    Component.onCompleted: {
        root.isPageActive = true;

        // 注册清理任务
        cleanupTasks.push(dataConnection);
        cleanupTasks.push(itemSetResultConnection);
        cleanupTasks.push(pageAttributeConnection);

        // 通知页面切换
        pageManager.notifyPageSwitch("configSys");

        // 初始化缓存 - 确保在组件创建前完成
        updatePageDataCache();
        updatePageAttributeCache();

        // 创建标签页
        createTab();

        // 初始化数据
        updateAllData();
    }

    Component.onDestruction: {
        performCleanup();
    }

   // ==================== 第4层：数据更新函数 ====================
    function updateAllData() {
        if (!pageManager.pageData) {
            return;
        }

        // 更新数据缓存
        updatePageDataCache();
        
        var sourceData = pageDataCache;
        
        // 更新sysConfig数据
        updateSysConfigData(sourceData);
    }

    // 新增：更新页面数据缓存
    function updatePageDataCache() {
        pageDataCache = pageManager.pageData;
    }

    // 新增：更新页面属性缓存
    function updatePageAttributeCache() {
        var newValue = pageManager.pageAttributeValue;
        Qt.callLater(function() {
            pageAttributeCache = newValue;
        });
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
        
        root.isPageActive = false;
        
        for (var i = 0; i < cleanupTasks.length; i++) {
            var task = cleanupTasks[i];
            if (task && typeof task === 'object') {
                task.enabled = false;  // 先禁用连接
                task.target = null;    // 再断开目标
            }
        }
        
        clearDynamicTabs();
        
        clearDataStructures();
        
        cleanupTasks = null;
        dynamicTabs = null;
    }

    function clearDataStructures() {
        // 清理数据对象
        if (sysConfigData) {
            sysConfigData = null;
        }
 
        if (sysParaOneData) {
            sysParaOneData = null;
        }
        
        // 清理缓存
        pageDataCache = null;
        pageAttributeCache = null;
        
        // 清理模型数组
        acDataModel = null;
        battTempSensorDataModel = null;
        sysParaFourOptionModel = null;
        sysParaOneDataModel = null;
        sysParaTwoDataModel = null;
        sysParaFourDataModel = null;
    }

    function clearDynamicTabs() {
        if (tab_view && tab_view.count > 0) {
            for (var i = tab_view.count - 1; i >= 0; i--) {
                var tab = tab_view.getTab(i);
                if (tab && tab.item) {
                    clearComponentRecursively(tab.item);
                }
                tab_view.removeTab(i);
            }
        }

        dynamicTabs = [];
    }

    function clearComponentRecursively(component) {
        if (!component) return;
        
        if (component.children) {
            for (var i = 0; i < component.children.length; i++) {
                clearComponentRecursively(component.children[i]);
            }
        }
        
        if (component.hasOwnProperty("isDestroyed")) {
            component.isDestroyed = true;
        }
        
        if (component.hasOwnProperty("model")) {
            component.model = null;
        }

        if (component.hasOwnProperty("displayText")) {
            component.displayText = "";
        }
    }
    
   
    // ==================== combox选项 ============================
    property var acDataModel: [ {label: "", setName: "", editable: true, options: [] } ]
    property var battTempSensorDataModel: [ {label: "", setName: "", editable: true, options: [] }]
    property var sysParaFourOptionModel: [ {label: "", setName: "", editable: true, options: [] }]

    property var sysParaOneDataModel: [{label: qsTr("csuNum"), setName: "csuNum", editable: false, unit: "" },
                                       {label: qsTr("AC Num"), setName: "acNum", editable: true, unit: "" },
                                       {label: qsTr("10kV AC NUM"), setName: "ac10kvNum", editable: true, unit: "" },
                                       {label: qsTr("*CSU-A Rect Num"), setName: "csuARectNum", editable: true, unit: "" },
                                       {label: qsTr("Battery Pack Num"), setName: "batteryPackNum", editable: true, unit: "" },
                                       {label: qsTr("Transfomer Temp Unit Num"), setName: "transformerTempNum", editable: true, unit: "" },
                                       {label: qsTr("*CSU-B Rect Num"), setName: "csuBRectNum", editable: true, unit: "" },
                                       {label: qsTr("CSUA Battery"), setName: "csuABatteryNum", editable: true, unit: "" },
                                       {label: qsTr("Transformer Fan Num"), setName: "transformerFanNum", editable: true, unit: "" },
                                       {label: qsTr("*CSU-C Rect Num"), setName: "csuCRectNum", editable: true, unit: "" },
                                       {label: qsTr("State Branch Num"), setName: "stateBranchNum", editable: true, unit: "" },
                                       {label: qsTr("Extend State Branch Num"), setName: "extendStateBranchNum", editable: true, unit: "" },
                                       {label: qsTr("Load Fuse Num"), setName: "loadFuseNum", editable: true, unit: "" },
                                       {label: qsTr("CSUA DC Branch Num"), setName: "csuADcBranchNum", editable: true, unit: "" },
                                       {label: qsTr("CSUB DC Branch Num"), setName: "csuBDcBranchNum", editable: true, unit: "" },
                                       {label: qsTr("Mixed Board Num"), setName: "mixedBoardNum", editable: true, unit: "" },
                                       {label: qsTr("Meter Num"), setName: "meterNum", editable: true, unit: "" },
                                       {label: qsTr("AC Base From Rect"), setName: "acBaseFromRect", editable: true, unit: "" },
                                       {label: qsTr("Diode Num"), setName: "diodeNum", editable: true, unit: "" },
                                       {label: qsTr("Fan Rotation Cycle"), setName: "fanRotationCycle", editable: true, unit: "" },
                                       {label: qsTr("Main Voltage"), setName: "mainVoltage", editable: true, unit: "V" },
                                       {label: qsTr("Main Current"), setName: "mainCurrent", editable: true, unit: "A" }]

     property var sysParaTwoDataModel: [{label: qsTr("SysA Share Curr Zero Threshold"), setName: "rmsAShareCurrZeroTH", editable: true, unit: "A" },
                                       {label: qsTr("SysB Share Curr Zero Threshold"), setName: "rmsBShareCurrZeroTH", editable: true, unit: "A" },
                                       {label: qsTr("SysA Share OC Threshold"), setName: "rmsAShareOverCurrTH", editable: true, unit: "A" },
                                       {label: qsTr("SysB Share OC Threshold"), setName: "rmsBShareOverCurrTH", editable: true, unit: "A" },
                                       {label: qsTr("*Rack Volt Diff"), setName: "rackVoltDiff", editable: true, unit: "V" },
                                       {label: qsTr("*Adjust Volt Diff"), setName: "systemAdjustVoltageDiff", editable: true, unit: "V" },
                                       {label: qsTr("*Rect Loadshare Diff"), setName: "rectifierLoadShareDiff", editable: true, unit: "A" },
                                       {label: qsTr("Sys Softstart Delay"), setName: "startupDelay", editable: true, unit: "V" },
                                       {label: qsTr("Rect Startup Volt"), setName: "rectStartupVolt", editable: true, unit: "V" },
                                       {label: qsTr("Rect Softstart Delay"), setName: "rectSoftStartDelay", editable: true, unit: "S" },
                                       {label: qsTr("Start Temp Of Transformer Fan"), setName: "startTempofFanTH", editable: true, unit: "℃" },
                                       {label: qsTr("System Rated Power"), setName: "systemRatedPower", editable: true, unit: "KW" },
                                       {label: qsTr("Full Speed Of Transformer Fan"), setName: "fullSpeedTempofFanTH", editable: true, unit: "℃" },
                                       {label: qsTr("Stop Temp Of Transformer Fan"), setName: "stopTempOfFanTH", editable: true, unit: "℃" },
                                       {label: qsTr("Min Fan Speed"), setName: "minFanSpeedTH", editable: true, unit: "RMP" },
                                       {label: qsTr("Max Fan Speed"), setName: "maxFanSpeedTH", editable: true, unit: "RMP" },
                                       {label: qsTr("Double Fan Max Speed FullLoad"), setName: "fullloadDfanMaxSpeedTH", editable: true, unit: "RMP" },
                                       {label: qsTr("Single Fan Max Speed FullLoad"), setName: "fullloadSfanMaxSpeedTH", editable: true, unit: "RMP" },
                                       {label: qsTr("Input OP Protection"), setName: "inputOpProtection", editable: true, unit: "KW" },
                                       {label: qsTr("Input Limit Power Recv"), setName: "inputLimitPowerRecv", editable: true, unit: "KW" },
                                       {label: qsTr("Buff Limit Power"), setName: "buffLimitPowerSet", editable: true, unit: "％" },
                                       {label: qsTr("Buff Limit Curr"), setName: "buffLimitCurrent", editable: true, unit: "C" },
                                       {label: qsTr("Static Duration"), setName: "staticDuration", editable: true, unit: "" },
                                       {label: qsTr("Input RP num"), setName: "inputRMNum", editable: true, unit: "" }]
    
    property var sysParaFourDataModel: [ {label: qsTr("CSU-Sys Softstart Delay"), setName: "csuSysSoftStartDelay", editable: true, unit: "S" },
                                          {label: qsTr("CSU-Rect Softstart Delay"), setName: "csuRectSoftStartDelay", editable: true, unit: "S" },
                                          {label: qsTr("CSU-Rect Startup Volt"), setName: "csuRectStartUpVolt", editable: true, unit: "V" },
                                          {label: qsTr("CSU-RectVoltlRising"), setName: "csuRectVoltIRisingSlope", editable: true, unit: "V/H" },]


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

    Loader {
        id: battTempSensorLoader
        source: "qrc:/User/ui/page/pageComBoxOption/Option_SystemPara.qml"
        onLoaded: {
            var arr = [];
            for (var i = 1; i <= 8; ++i) {
                arr.push({ label: qsTr("Batt Temp Sensor") + i,
                           setName: "battTempSensor" + i,
                           editable: true,
                           options: battTempSensorLoader.item.optionBattTempSensor });
            }
            root.battTempSensorDataModel = arr;
        }
    }

    Loader{
        id: sysParaFourLoader
        source: "qrc:/User/ui/page/pageComBoxOption/Option_SystemPara.qml"
        onLoaded: {
            root.sysParaFourOptionModel = [ {label: "CSU-Volt Spec",     setName: "csuVoltSpec",editable: false, options: sysParaFourLoader.item.optionSysVoltageMode },
                                          {label: "CSU-Rect Model",   setName: "csuRectModel",editable: true, options: sysParaFourLoader.item.optionRectModel  },
                                          {label: "CSU-RectVoltageIncrease",      setName: "csuRectVoltageIncrease",editable: true, options: sysParaFourLoader.item.optionEnableDisable },
                                          {label: "CSU-RectStartUpInSequence",        setName: "csuRectStartUpInSequence",editable: true, options: sysParaFourLoader.item.optionEnableDisable  }
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
          SysParaOne {
          }
      }
  
      property Component sysParaTwoComponentSource: Component {
          SysParaTwo {
          }
      }

    property Component sysParaThreeComponentSource: Component {
        SysParaThree {}
    }

    property Component sysParaFourComponentSource: Component {
        SysParaFour {}
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
                        pageManager.setItemData("clearEnergy", 1);
                    }
                }
            }
        }
    }
    // system para. 1
    component SysParaOne: FocusScope{
        id: sysParaOneRoot
        anchors.fill:parent

        MouseArea {
            anchors.fill: parent
            z: -1
            onClicked: {
                if (Window.window.activeFocusItem) {
                    Window.window.activeFocusItem.focus = false;
                }
            }
        }

        PagaQuerryTypeSelect{
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: 232
            anchors.topMargin: 16
        }

        GridLayout {
            anchors.centerIn: parent
            //height: parent.height
            anchors.bottomMargin: 32

            columnSpacing: 95
            rowSpacing: 24
            columns: 3

            Repeater {
                model: sysParaOneDataModel
                Layout.alignment: Qt.AlignRight
                SystemParaTextBox {
                    label: modelData.label
                    setName: modelData.setName
                    editable: modelData.editable
                    unit: modelData.unit
                    valueType: root.pageAttributeCache ? root.pageAttributeCache["pageQuerryType"] : 0
                    // model: modelData.options
                }
            }
        }
    }

    // sys para.2
    component SysParaTwo: FocusScope{
        id: sysParaTwoRoot
        anchors.fill: parent

        MouseArea {
            anchors.fill: parent
            z: -1
            onClicked: {
                if (Window.window.activeFocusItem) {
                    Window.window.activeFocusItem.focus = false;
                }
            }
        }

        PagaQuerryTypeSelect{
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: 232
            anchors.topMargin: 16
        }

        GridLayout {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: 12
            anchors.horizontalCenterOffset: 40

            columnSpacing: parent.width * 0.2
            rowSpacing: parent.height *0.015
            columns: parent.width > 1000 ? 3:2

            Repeater {
                model: sysParaTwoDataModel
                Layout.alignment: Qt.AlignRight
                SystemParaTextBox {
                    label: modelData.label
                    setName: modelData.setName
                    editable: modelData.editable
                    unit: modelData.unit
                    valueType: root.pageAttributeCache ? root.pageAttributeCache["pageQuerryType"] : 0
                }
            }
        }
    }

    // sys para.3
    component SysParaThree: FocusScope {
        id: sysParaThreeRoot
        anchors.fill: parent

        MouseArea {
            anchors.fill: parent
            z: -1
            onClicked: {
                if (Window.window.activeFocusItem) {
                    Window.window.activeFocusItem.focus = false;
                }
            }
        }

        GridLayout {
            anchors.centerIn: parent
            //height: parent.height
            anchors.bottomMargin: 32
            columnSpacing: 95
            rowSpacing: 24
            columns: 2

            Repeater {
                model: battTempSensorDataModel
                Layout.alignment: Qt.AlignRight
                SystemParaItemComm {
                  label: modelData.label
                  setName: modelData.setName
                  model: modelData.options
                  editable: true
                }
            }
        }
    }

    // sys para.4
    component SysParaFour: FocusScope{
        id: sysParaFourRoot
        anchors.fill: parent

        MouseArea {
            anchors.fill: parent
            z: -1
            onClicked: {
                if (Window.window.activeFocusItem) {
                    Window.window.activeFocusItem.focus = false;
                }
            }
        }

        PageFourItemSelect{
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: 512
            anchors.topMargin: 18
        }

        GridLayout {
            anchors.centerIn: parent
            anchors.bottomMargin: 32
            columnSpacing: 140
            columns: 2

            ColumnLayout {
                spacing: 16
                Repeater {
                    model: sysParaFourOptionModel
                    Layout.alignment: Qt.AlignRight
                    SystemParaItemComm {
                        label: modelData.label
                        setName: modelData.setName
                        model: modelData.options
                        editable: modelData.editable
                        valueType: root.pageAttributeCache ? root.pageAttributeCache["pageQuerryType"] : 0
                        multipleCsu: root.pageAttributeCache ? root.pageAttributeCache["csuIndex"] : 0
                    }
                }
            }

            ColumnLayout {
                spacing: 16
                Repeater {
                    model: sysParaFourDataModel
                    Layout.alignment: Qt.AlignRight
                    SystemParaTextBox {
                        label: modelData.label
                        setName: modelData.setName
                        editable: modelData.editable
                        unit: modelData.unit
                        valueType: root.pageAttributeCache ? root.pageAttributeCache["pageQuerryType"] : 0
                        multipleCsu: root.pageAttributeCache ? root.pageAttributeCache["csuIndex"] : 0
                    }
                }
            }
        }
    }
    
/*----------------------------------------系统组件--------------------------------------*/
    component SystemParaItem: Item {
        id: systemParaItemRoot
        property string label: ""
        property string setName: ""
        property bool editable: true
        property var model

        Layout.fillWidth: true
        Layout.preferredHeight: 32
        Layout.preferredWidth: 240

        // 添加缓存机制，避免深层绑定
        property string displayText: ""
        property bool isDestroyed: false

        function updateDisplayText() {
            if (isDestroyed) return;
            
            try {
                if (!root.sysConfigData || !model) {
                    displayText = "";
                    return;
                }

                var value = root.sysConfigData[setName];
                if (value === undefined || value === null) {
                    displayText = "";
                    return;
                }
                
                var option = model[value];
                if (!option) {
                    displayText = "";
                    return;
                }
                
                displayText = option.text || "";
            } catch (error) {
                displayText = "";
            }
        }

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
                enabled: systemParaItemRoot.editable && !systemParaItemRoot.isDestroyed
                model: systemParaItemRoot.model
                textRole: "text"
                
                contentItem: FluText {
                    anchors.fill: parent
                    anchors.leftMargin: 8

                    text: systemParaItemRoot.displayText
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }

                onActivated: {
                    if (systemParaItemRoot.isDestroyed) return;
                    
                    try {
                        var selectedOption = model[currentIndex];
                        if (!selectedOption) return;
                        
                        currentIndex = root.sysConfigData ? root.sysConfigData[systemParaItemRoot.setName] : 0;
                        pageManager.setItemData(systemParaItemRoot.setName, selectedOption.value);
                        systemParaItemRoot.displayText = selectedOption.text || "";
                    } catch (error) {
                        console.error("Error in onActivated for", systemParaItemRoot.setName, ":", error);
                    }
                }
            }
        }

        // 监听数据变化
        Connections {
            target: pageManager
            enabled: !systemParaItemRoot.isDestroyed
            
            function onPageDataChanged() {
                if (!systemParaItemRoot.isDestroyed) {
                    systemParaItemRoot.updateDisplayText();
                }
            }
        }

        // 组件初始化
        Component.onCompleted: {
            updateDisplayText();
        }

        // 组件销毁时清理资源
        Component.onDestruction: {
            isDestroyed = true;
            displayText = "";
            model = null;
        }
    }

    component SystemParaItemComm: Item {
        id: systemParaItemCommRoot
        property string label: ""
        property string setName: ""
        property bool editable: true

        property var valueType: 0
        property var multipleCsu: 0

        property var model

        Layout.fillWidth: true
        Layout.preferredHeight: 32
        Layout.preferredWidth: 240

        property string displayText: ""
        property bool isDestroyed: false

        function updateDisplayText() {
            if (isDestroyed) return;
            
            try {
                if (!root.pageDataCache || !model) {
                    displayText = "";
                    return;
                }


                var value = root.pageDataCache[setName + getSysParaValue(multipleCsu) + getSysParaPostfix(valueType)];


                if (value === undefined || value === null) {
                    displayText = "";
                    return;
                }
                
                var option = model[value];
                if (!option) {
                    displayText = "";
                    return;
                }
                
                displayText = option.text || "";
            } catch (error) {
                displayText = "";
            }
        }

        RowLayout {
            spacing: 8

            FluText {
                Layout.preferredWidth: 100
                Layout.fillWidth: true
                text: label + ":"
                horizontalAlignment: Text.AlignRight
            }

            FluComboBox {
                Layout.preferredWidth: 140
                Layout.fillWidth: true
                
                editable: false
                enabled: systemParaItemCommRoot.editable && !systemParaItemCommRoot.isDestroyed && (root.pageDataCache[setName + getSysParaValue(multipleCsu) + getSysParaPostfix(valueType)] !== undefined)
                model: systemParaItemCommRoot.model
                textRole: "text"
                
                contentItem: FluText {
                    anchors.fill: parent
                    anchors.leftMargin: 8
                    text: systemParaItemCommRoot.displayText
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }

                onActivated: {
                    if (systemParaItemCommRoot.isDestroyed) return;
                    
                    try {
                        var selectedOption = model[currentIndex];
                        if (!selectedOption) return;
                        
                        currentIndex = root.pageDataCache[systemParaItemCommRoot.setName] ? root.pageDataCache[systemParaItemCommRoot.setName] : 0;
                        handleSysParaValueSet(systemParaItemCommRoot.setName, systemParaItemCommRoot.valueType, systemParaItemCommRoot.multipleCsu, selectedOption.value);
                        systemParaItemCommRoot.displayText = selectedOption.text || "";
                        
                        console.log("Selected:", systemParaItemCommRoot.setName);
                    } catch (error) {
                        console.error("Error in onActivated for", systemParaItemCommRoot.setName, ":", error);
                    }
                }
            }
        }

        // 监听数据变化
        Connections {
            target: pageManager
            enabled: !systemParaItemCommRoot.isDestroyed
            
            function onPageDataChanged() {
                if (!systemParaItemCommRoot.isDestroyed) {
                    systemParaItemCommRoot.updateDisplayText();
                }
            }
        }

        // 组件初始化
        Component.onCompleted: {
            updateDisplayText();
        }

        // 组件销毁时清理资源
        Component.onDestruction: {
            isDestroyed = true;
            displayText = "";
            model = null;
        }
    }

    component SystemParaTextBox: Item {
        id: systemParaTextBoxRoot
        property string label: ""
        property string setName: ""
        property string unit: ""
        property bool editable: true
        property var valueType: 0
        property var multipleCsu: 0

        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.preferredHeight: 32
        Layout.preferredWidth: 200

        RowLayout {
            spacing: 8

            FluText {
                Layout.preferredWidth: 90
                Layout.fillWidth: true
                text: label + ":"
                horizontalAlignment: Text.AlignRight
            }

            FluTextBox {
                id: dataInput
                Layout.preferredWidth: 100
                Layout.fillWidth: true

                property string valueKey: systemParaTextBoxRoot.setName + getSysParaValue(systemParaTextBoxRoot.multipleCsu) + getSysParaPostfix(systemParaTextBoxRoot.valueType)

                property var valueData: root.pageDataCache ? root.pageDataCache[valueKey] : undefined

                enabled: systemParaTextBoxRoot.editable && (valueData !== undefined)
                
                validator: RegularExpressionValidator {
                    // 允许负号，1位可以是0或-0，2位及以上不能以0开头
                    regularExpression: /^-?(0|[1-9]\d{0,5})(\.\d{1,2})?$/
                }

                onValueDataChanged: {
                    // 如果文本框有焦点（正在编辑），不更新显示文本
                    if (focus) {
                        return;
                    }
                    
                    if (valueData === undefined) {
                        text = "---";
                    } else {
                        var formattedValue = formatNumber(valueData, 2);
                        if (formattedValue !== text) {
                            text = formattedValue;
                        }
                    }
                }

                Component.onCompleted: {
                    if (valueData === undefined) {
                        text = "---";
                    } else {
                        text = formatNumber(valueData, 2);
                    }
                }

                onCommit: {
                    handleSysParaValueSet(systemParaTextBoxRoot.setName, systemParaTextBoxRoot.valueType, systemParaTextBoxRoot.multipleCsu, dataInput.text)
                }
            }

            FluText { 
                text: unit
                Layout.preferredWidth: 10
                horizontalAlignment: Text.AlignRight | Text.AlignVCenter
            }
        }
    }

    component PagaQuerryTypeSelect: Item{
        FluRadioButtons {
            //spacing: 8
            orientation: Qt.Horizontal
            currentIndex: root.pageAttributeCache ? root.pageAttributeCache["pageQuerryType"] : 0
            
            // 直接绑定到 root.pageAttributeCache 确保同步
            property var directBinding: root.pageAttributeCache ? root.pageAttributeCache["pageQuerryType"] : 0
            onDirectBindingChanged: {
                if (currentIndex !== directBinding) {
                    currentIndex = directBinding;
                }
            }


            FluRadioButton {
                text:"value"
                onClicked: {
                    pageManager.changePageAttribute("pageQuerryType", 0);
                    pageManager.manualRefreshPage();
                }
            }

            FluRadioButton {
                text:"Max"
                onClicked: {
                    pageManager.changePageAttribute("pageQuerryType", 1);
                    pageManager.manualRefreshPage();
                }
            }

            FluRadioButton {
                text:"Min"
                onClicked: {
                    pageManager.changePageAttribute("pageQuerryType", 2);
                    pageManager.manualRefreshPage();
                }
            }
        }

    }

    component PageFourItemSelect: Item{
        FluText{
            id:csuIndexText
            width: 80
            height:32
            text:qsTr("CSU Select:")
        }

        FluComboBox {
            id: csuIndexComboBox
            anchors.left: csuIndexText.right
            anchors.top: csuIndexText.top
            anchors.topMargin: -6
            height: 32

            editable: false
            model: sysParaFourLoader.item ? sysParaFourLoader.item.optionCSU : []
            currentIndex: {
                if (!root.pageAttributeCache || !sysParaFourLoader.item || !sysParaFourLoader.item.optionCSU) {
                    return 0;
                }
                var csuIndex = root.pageAttributeCache["csuIndex"];
                if (csuIndex === undefined || csuIndex === null) {
                    return 0;
                }
                return Math.max(0, Math.min(csuIndex - 1, sysParaFourLoader.item.optionCSU.length - 1));
            }
            textRole: "text"

            contentItem: FluText {
                anchors.fill: parent
                anchors.leftMargin: 8
                text: {
                    if (!parent.model || parent.model.length === 0) {
                        return "----";
                    }
                    if (parent.currentIndex < 0 || parent.currentIndex >= parent.model.length) {
                        return "----";
                    }
                    var item = parent.model[parent.currentIndex];
                    return item && item.text ? item.text : "----";
                }
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }

            onActivated: {
                if (model && model[currentIndex]) {
                    pageManager.changePageAttribute("csuIndex", model[currentIndex].value)
                    pageManager.manualRefreshPage();
                }
            }
        }

        PagaQuerryTypeSelect{
            id: csuIndexSelect
            height: 32
            anchors.left: csuIndexComboBox.right
            anchors.leftMargin: 60
            anchors.top: csuIndexComboBox.top
            anchors.topMargin: 4
        }
    }

    function createTab() {

        var sysConfigTab = tab_view.appendTab("qrc:/image/favicon.ico",
                                              qsTr("System config"),
                                              sysConfigComponentSource,
                                              );
        dynamicTabs.push(sysConfigTab);

        var sysParaOneTab = tab_view.appendTab("qrc:/image/favicon.ico",
                                               qsTr("System para. 1"),
                                               sysParaOneComponentSource
                                               );
        dynamicTabs.push(sysParaOneTab);

        var sysParaTwoTab = tab_view.appendTab("qrc:/image/favicon.ico",
                                               qsTr("System para. 2"),
                                               sysParaTwoComponentSource
                                               );
        dynamicTabs.push(sysParaTwoTab);

        var sysParaThreeTab = tab_view.appendTab("qrc:/image/favicon.ico",
                                               qsTr("System para. 3"),
                                               sysParaThreeComponentSource,
                                               );
        dynamicTabs.push(sysParaThreeTab);

        var sysParaFourTab = tab_view.appendTab("qrc:/image/favicon.ico",
                                               qsTr("System para. 4"),
                                               sysParaFourComponentSource
                                               );
        dynamicTabs.push(sysParaFourTab);


    }

    function handleSysParaValueSet(setName, valueType, multipleCsu, value)
    {
        pageManager.setItemData(setName + getSysParaValue(multipleCsu) + getSysParaPostfix(valueType), value);
        
    }

    function formatNumber(value, decimals) {
        return Number(value).toFixed(decimals).replace(/\.?0+$/, '')
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

    function getSysParaValue(multipleCsu)
    {
        if(multipleCsu === 0)
        {
            return "";
        }
        else
        {
            return multipleCsu;
        }
    }
}
