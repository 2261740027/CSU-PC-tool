import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0
import "../global"

FluContentPage {
    id: root
    title: qsTr("Battery Parameter")
    property bool isPageActive: false
    property var pageDataCache: null
    property var pageAttributeCache: null

    property var dynamicTabs: []

    Component.onCompleted: {
        root.isPageActive = true;

        // // 注册清理任务
        // cleanupTasks.push(dataConnection);
        // cleanupTasks.push(itemSetResultConnection);
        // cleanupTasks.push(pageAttributeConnection);

        // // 通知页面切换
        pageManager.notifyPageSwitch("configBattPara");

        // // 初始化缓存 - 确保在组件创建前完成
        // updatePageDataCache();
        // updatePageAttributeCache();

        // 创建标签页
        createTab();

        // // 初始化数据
        updateAllData();
    }

    Component.onDestruction: {
        //performCleanup();
    }

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

    // ==================== 第4层：数据管理 ====================

    property var battParaOptionDataMod: [ {label: "", setName: "", editable: true, options: [] } ]

    property var battParaConfig: [ {label: qsTr("Batt Cap"), setName: "batteryTotalCapacity", editable: true, unit: "AH" },
                                    {label: qsTr("Float Volt"), setName: "systemFloatVoltage", editable: true, unit: "V" },
                                    {label: qsTr("Equ Volt"), setName: "systemEqualizeVoltage", editable: true, unit: "V" },
                                    {label: qsTr("Equ Boost Cap"), setName: "equBoostCap", editable: true, unit: "％" },
                                    {label: qsTr("Equ Boost Volt"), setName: "boostChargeDepthVoltage", editable: true, unit: "V" },
                                    {label: qsTr("Equ Boost Curr"), setName: "boostChargeChargeCurrent", editable: true, unit: "C" },
                                    {label: qsTr("Equ Period"), setName: "equalizEperiod", editable: true, unit: "Month" },
                                    {label: qsTr("Equ Max Time"), setName: "equalizeMaxTime", editable: true, unit: "Hr" },
                                    {label: qsTr("Equ extra Time"), setName: "equalizeAdditionalTime", editable: true, unit: "Hr" },
                                    {label: qsTr("Equ Terminal Curr"), setName: "equalizeTerminalCurrent", editable: true, unit: "C10" },
                                    {label: qsTr("Charge CL Level2"), setName: "batteryFloatChargeCurr", editable: true, unit: "C10" },
                                    {label: qsTr("Charge CL Level3"), setName: "batteryEqualizeChargeCurr", editable: true, unit: "C10" },
                                    {label: qsTr("Charge CL Level1"), setName: "batteryDpVoltChargeCurr", editable: true, unit: "C10" },
                                    {label: qsTr("Rectifiel CL"), setName: "batteryManualChargeCurrLimit", editable: true, unit: "A" },
                                    {label: qsTr("Batt Chg OC"), setName: "batteryOverCurrent", editable: true, unit: "C10" },
                                    {label: qsTr("Batt Brk TripVolt"), setName: "batteryBreakerTripVoltage", editable: true, unit: "V" },
                                    {label: qsTr("Batt Brk TripCurr"), setName: "batteryBreakerTripCurr", editable: true, unit: "C10" },
                                ]

    Loader {
        id: battParaLoader
        source: "qrc:/User/ui/page/pageComBoxOption/Option_BattPara.qml"
        onLoaded: { 
            root.battParaOptionDataMod = [ {label: qsTr("CL Mode"), setName: "systemClmode", editable: true, options: battParaLoader.item.optionCLMode },
                                          {label: qsTr("Equ Function"), setName: "equalizeFunction", editable: true, options: battParaLoader.item.optionDisableEnable },
                                          {label: qsTr("Boost Volt Func"), setName: "boostDepthVoltCharge", editable: true, options: battParaLoader.item.optionDisableEnable },
                                          {label: qsTr("Boost Cap Func"), setName: "boostDischargeCapCharge", editable: true, options: battParaLoader.item.optionDisableEnable },
                                          {label: qsTr("Boost Curr Func"), setName: "boostChargeCurrCharge", editable: true, options: battParaLoader.item.optionDisableEnable },
                                          {label: qsTr("Boost Cyc Func"), setName: "boostCharge", editable: true, options: battParaLoader.item.optionDisableEnable },
                                        ];
        }
    }

    // ==================== UI显示 ====================

    property Component battParaOneComponentSource: Component {
        BattParaOne {}
    }

    property Component battParaTwoComponentSource: Component {
        BattParaTwo {}
    }

    FluFrame{
        anchors.fill: parent
        anchors.topMargin: 4
        anchors.leftMargin: 4
        anchors.rightMargin: 4
        anchors.bottomMargin: 4

        FluTabView {
            id: tab_view
            anchors.fill: parent
            addButtonVisibility: false
            closeButtonVisibility: FluTabViewType.Never
            tabWidthBehavior: FluTabViewType.Equal
        }

    }

    // batt para1
    component BattParaOne: FocusScope {
        id: battParaOneRoot
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

        PageSelectItem{
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: 512
            anchors.topMargin: 18
        }

        // CustCalendarPicker{
        //     anchors.centerIn: parent
        // }

        CustTimePicker{
            anchors.centerIn: parent
            hourFormat:FluTimePickerType.HH
            onAccepted: {
                    showSuccess(current.toLocaleTimeString(Qt.locale("de_DE")))
                }
        }

        ColumnLayout{
            anchors.fill: parent
            spacing: 8

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 24
            }

            // Item {
            //     Layout.fillWidth: true
            //     Layout.fillHeight: true
            //     Layout.preferredHeight: parent.height * 0.7

            //     GridLayout {
            //         anchors.centerIn: parent
            //         anchors.bottomMargin: 32
            //         columnSpacing: 80
            //         rowSpacing: 16
            //         columns: 3

            //         Repeater {
            //             model: battParaConfig
            //             Layout.alignment: Qt.AlignCenter
            //             SystemParaTextBox {
            //                 label: modelData.label
            //                 setName: modelData.setName
            //                 editable: modelData.editable
            //                 unit: modelData.unit
            //                 valueType: pageManager.pageAttributeValue ? pageManager.pageAttributeValue["pageQuerryType"] : 0
            //                 multipleCsu: pageManager.pageAttributeValue ? pageManager.pageAttributeValue["csuIndex"] : 0
            //                 // model: modelData.options
            //             }
            //         }
            //     }

            // }

            // Item {
            //     Layout.fillWidth: true
            //     Layout.fillHeight: true
            //     Layout.preferredHeight: parent.height * 0.3

            //     GridLayout {
            //         anchors.centerIn: parent
            //         anchors.bottomMargin: 32
            //         columnSpacing: 70
            //         rowSpacing: 16
            //         columns: 3

            //         Repeater {
            //             model: battParaOptionDataMod
            //             Layout.alignment: Qt.AlignCenter
            //             SystemParaItemComm {
            //                 label: modelData.label
            //                 setName: modelData.setName
            //                 model: modelData.options
            //                 editable: modelData.editable
            //                 valueType: root.pageAttributeCache ? root.pageAttributeCache["pageQuerryType"] : 0
            //                 multipleCsu: root.pageAttributeCache ? root.pageAttributeCache["csuIndex"] : 0
            //             }

            //         }
            //         Item {
            //             Layout.fillWidth: true
            //             Layout.fillHeight: true
            //             Layout.preferredHeight: 32
            //             Layout.preferredWidth: 200
            //         }
            //     }
            // }
        }
        
    }

    // batt para2
    component BattParaTwo: FocusScope {
        id: battParaTwoRoot
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

        PageSelectItem{
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: 512
            anchors.topMargin: 18
        }
        
    }

    component PageSelectItem: Item{
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
            model: battParaLoader.item ? battParaLoader.item.optionCSU : []
            currentIndex: {
                if (!root.pageAttributeCache || !battParaLoader.item || !battParaLoader.item.optionCSU) {
                    return 0;
                }
                var csuIndex = root.pageAttributeCache["csuIndex"];
                if (csuIndex === undefined || csuIndex === null) {
                    return 0;
                }
                return Math.max(0, Math.min(csuIndex - 1, battParaLoader.item.optionCSU.length - 1));
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

                //enabled: systemParaTextBoxRoot.editable && (valueData !== undefined)
                
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
                    focus = false
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
        Layout.preferredWidth: 200

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
                Layout.preferredWidth: 100
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

    
    //-----------------------------辅助函数---------------------------//

    function updateAllData() {
        updatePageDataCache();
        updatePageAttributeCache();
    }

    function updatePageDataCache() {
        pageDataCache = pageManager.pageData;
    }

    function updatePageAttributeCache() {
        pageAttributeCache = pageManager.pageAttributeValue;
    }

    function createTab() {
        console.log("Creating AC Info tabs");

        var battParaOneTab = tab_view.appendTab("qrc:/image/favicon.ico",
                                              qsTr("Batt.Para Config"),
                                              battParaOneComponentSource,
                                              );
        dynamicTabs.push(battParaOneTab);

        var battParaTwoTab = tab_view.appendTab("qrc:/image/favicon.ico",
                                              qsTr("TempComp&BT Config"),
                                              battParaTwoComponentSource,
                                              );
        dynamicTabs.push(battParaTwoTab);

        console.log("Created", dynamicTabs.length, "tabs");
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
