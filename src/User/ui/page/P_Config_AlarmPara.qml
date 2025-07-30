import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0

FluContentPage {
    id: root
    title: qsTr("Alarm Parameter")

    // ==================== 第1层：清理任务管理 ====================
    property var cleanupTasks: []
    property var dynamicTabs: []
    property bool isPageActive: false


    Component.onCompleted: {
        root.isPageActive = true;

        // 通知页面切换
        pageManager.notifyPageSwitch("configAlarmPara");

        updateAllData();

        // 创建标签页
        createTab();
    }

    Component.onDestruction: {
        //performCleanup();
    }

    // ==================== 第2层：数据缓存层 ====================
    property var pageDataCache: null
    property var pageAttributeCache: null
    
    // ==================== 第3层：连接管理层 ====================

    // 监听页面数据
    Connections {
        id: dataConnection
        target: pageManager
        enabled: root.isPageActive

        function onPageDataChanged() {
            if (!root.isPageActive) return;
            updatePageDataCache();
        }
    }

    // 监听页面属性
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

    property var sysParaAcConfig: [ {label: qsTr("AC Volt High"), setName: "acVoltageHigh", editable: true, unit: "V" },
                                         {label: qsTr("AC Unbalance"), setName: "acUnbalance", editable: true, unit: "％" },
                                         {label: qsTr("AC Freq High"), setName: "acFreqHigh", editable: true, unit: "Hz" },
                                         {label: qsTr("AC Volt Low"), setName: "acVoltageLow", editable: true, unit: "V" },
                                         {label: qsTr("AC Over Curr"), setName: "acOverCurrent", editable: true, unit: "A" },
                                         {label: qsTr("AC Freq Low"), setName: "acFreqLow", editable: true, unit: "Hz" },
                                         {label: qsTr("AC Off Volt"), setName: "acFailure", editable: true, unit: "V" },
                                         {label: qsTr("AC Restore Volt"), setName: "acRecover", editable: true, unit: "V" }]

    property var sysParaProtectConfig: [ {label: qsTr("CSU A DC OV"), setName: "systemADCVoltageHigh", editable: true, unit: "V" },
                                         {label: qsTr("CSU A DC LV"), setName: "systemADCVoltagelow", editable: true, unit: "V" },
                                         {label: qsTr("Battery OT"), setName: "batteryAtemperaturehigh", editable: true, unit: "℃" },
                                         {label: qsTr("CSU B DC OV"), setName: "systemBDCVoltageHigh", editable: true, unit: "V" },
                                         {label: qsTr("CSU B DC LV"), setName: "systemBDCVoltagelow", editable: true, unit: "V" },
                                         {label: qsTr("Ambient OT"), setName: "batteryBtemperaturehigh", editable: true, unit: "℃" },
                                         {label: qsTr("CSU C DC OV"), setName: "systemCDCVoltageHigh", editable: true, unit: "V" },
                                         {label: qsTr("CSU C DC LV"), setName: "systemCDCVoltagelow", editable: true, unit: "V" },
                                         {label: qsTr("Ambient LT"), setName: "batteryCtemperaturehigh", editable: true, unit: "℃" },

                                         {label: qsTr("Dischg Unbalance"), setName: "batteryUnbalanceDischarge", editable: true, unit: "C" },
                                         {label: qsTr("Negative IR"), setName: "gfdPositiveImpedanceLow", editable: true, unit: "Kohm" },
                                         {label: qsTr("Sys Curr Share Diff"), setName: "sysCurrShareDiff", editable: true, unit: "A" },
                                         {label: qsTr("Total Load OC"), setName: "sysLoadOverCurr", editable: true, unit: "A" },
                                         {label: qsTr("Positive IR"), setName: "gfdNegativeImpedanceLow", editable: true, unit: "Kohm" },
                                         {label: qsTr("Batt Lo SOC"), setName: "battLoS", editable: true, unit: "％" },
                                         {label: qsTr("Main DC OV"), setName: "mainDcOV", editable: true, unit: "V" },
                                         {label: qsTr("Main DC LV"), setName: "mainDCLV", editable: true, unit: "V" },
                                         {label: qsTr("Battery cell OV"), setName: "batteryCellOV", editable: true, unit: "V" },
                                         ]


    // ==================== UI显示 ====================

    property Component alarmParaOneComponentSource: Component {
        AlarmParaOne {}
    }

    FluFrame{
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

    // alarm para1

    component AlarmParaOne: Item {
        id: alarmParaOneRoot
        anchors.fill: parent
        
        PagaQuerryTypeSelect{
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: 232
            anchors.topMargin: 8
        }
        
        ColumnLayout{
            anchors.fill: parent
            spacing: 8

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 24
            }
            
            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredHeight: parent.height * 0.3

                GridLayout {
                    anchors.centerIn: parent
                    anchors.bottomMargin: 32
                    columnSpacing: 80
                    rowSpacing: 16
                    columns: 3

                    Repeater {
                        model: sysParaAcConfig
                        Layout.alignment: Qt.AlignCenter
                        SystemParaTextBox {
                            label: modelData.label
                            setName: modelData.setName
                            editable: modelData.editable
                            unit: modelData.unit
                            valueType: pageManager.pageAttributeValue ? pageManager.pageAttributeValue["pageQuerryType"] : 0
                            // model: modelData.options
                        }
                    }
                }

            }

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredHeight: parent.height * 0.7

                GridLayout {
                    anchors.centerIn: parent
                    anchors.bottomMargin: 32
                    columnSpacing: 80
                    rowSpacing: 16
                    columns: 3

                    Repeater {
                        model: sysParaProtectConfig
                        Layout.alignment: Qt.AlignCenter
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
        }
    }

    //-----------------------------组件---------------------------//
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
                text: valueData !== undefined ? formatNumber(valueData, 2) : "---"

                validator: RegularExpressionValidator {
                    // 允许负号，1位可以是0或-0，2位及以上不能以0开头
                    regularExpression: /^-?(0|[1-9]\d{0,5})(\.\d{1,2})?$/
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

        var alarmParaOneTab = tab_view.appendTab("qrc:/image/favicon.ico",
                                              qsTr("Alarm para. 1"),
                                              alarmParaOneComponentSource,
                                              );
        dynamicTabs.push(alarmParaOneTab);

        // var sysParaOneTab = tab_view.appendTab("qrc:/image/favicon.ico",
        //                                        qsTr("System para. 1"),
        //                                        sysParaOneComponentSource,
        //                                        );
        // dynamicTabs.push(sysParaOneTab);

        console.log("Created", dynamicTabs.length, "tabs");
    }

    component PagaQuerryTypeSelect: Item{

        FluRadioButtons {
            //spacing: 8
            orientation: Qt.Horizontal
            currentIndex: pageManager.pageAttributeValue ? pageManager.pageAttributeValue["pageQuerryType"] : 0

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
