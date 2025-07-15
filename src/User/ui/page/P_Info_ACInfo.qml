import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0

FluContentPage {
    title: qsTr("AC Info")

    Component.onCompleted: {
        pageManager.notifyPageSwitch("infoAcInfo");
        createTab();
    }

    Component.onDestruction: {
        // 页面销毁时的清理工作
        deviceData = null;
        // 强制垃圾回收
        gc();
    }

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

    // 通用AC信息组件
    Component {
        id: acInfoComponent

        Item {
            // 从argument中获取传入的参数
            property var acNumber: argument ? argument.acNumber || 1 : 1
            //property string dataPrefix: argument ? argument.dataPrefix || "AC1" : "AC1"

            // AC数据配置模型
            property var acDataModel: [
                { index: 1, visible: true },
                { index: 2, visible: true },
                { index: 3, visible: acNumber !== 4 },
                { index: 4, visible: acNumber !== 4 }
            ]

            ColumnLayout {
                anchors.fill: parent
                // 使用Repeater批量生成AC信息显示项
                Repeater {
                    model: acDataModel
                    
                    Item {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 100
                        Layout.rightMargin: 16
                        Layout.leftMargin: 16
                        visible: modelData.visible

                        property string acIndex: "AC"+((acNumber - 1) * 4 + modelData.index).toString()
                        
                        RowLayout {
                            anchors.fill: parent
                            spacing: 50

                            // AC标题
                            FluText {
                                Layout.alignment: Qt.AlignCenter
                                text: acIndex + ":"
                                font.pixelSize: 15
                                font.weight: Font.DemiBold
                                color: FluTheme.fontPrimaryColor
                            }

                            // 数据表格
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
                                    text: "SPD" + ((acNumber - 1) * 4 + modelData.index).toString()
                                    font.pixelSize: 13
                                    Layout.alignment: Qt.AlignHCenter 
                                }

                                // 电压行
                                DataCell { text: visible ? pageManager.pageData[acIndex + "Phase1Voltage"].toFixed(2) : "---"; }
                                FluText { text: "V"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }
                                DataCell { text: visible ? pageManager.pageData[acIndex + "Phase2Voltage"].toFixed(2) : "---"; }
                                FluText { text: "V"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }
                                DataCell { text: visible ? pageManager.pageData[acIndex + "Phase3Voltage"].toFixed(2) : "---"; }
                                FluText { text: "V"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }
                                DataCell { text: visible ? pageManager.pageData[acIndex + "Frequency"].toFixed(2) : "---"; }
                                FluText { text: "Hz"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }
                                DataCell { text: getAcBreakerStatus(pageManager.pageData[acIndex + "BreakerStatus"]); }
                                Item { Layout.fillWidth: true }
                                StatusDot { dotColor: "#4caf50"; Layout.alignment: Qt.AlignHCenter }

                                // 电流行
                                DataCell { text: visible ? pageManager.pageData[acIndex + "Phase1Current"].toFixed(2) : "---"; }
                                FluText { text: "A"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }
                                DataCell { text: visible ? pageManager.pageData[acIndex + "Phase2Current"].toFixed(2) : "---"; }
                                FluText { text: "A"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }
                                DataCell { text: visible ? pageManager.pageData[acIndex + "Phase3Current"].toFixed(2) : "---"; }
                                FluText { text: "A"; font.pixelSize: 12; Layout.alignment: Qt.AlignVCenter }
                                Item { Layout.fillWidth: true; Layout.columnSpan: 5 }
                            }
                        }
                    }
                }
            }
        }
    }

    // total ac Info
    Component {
        id: acTotalInfoComponent
        Item {
            // 从argument中获取传入的参数
            property string dataPrefix: argument ? argument.dataPrefix || "TotalAc" : "TotalAc"

            // 数据配置模型
            property var acDataItems: [
                { title: "Power", dataType: "power", unit: "kWh", value: pageManager.pageData["TotalAcPower"] },
                { title: "Energy", dataType: "energy", unit: "kW", value: pageManager.pageData["TotalAcEnergy"] },
                { title: "PF", dataType: "frequency", unit: "", value: pageManager.pageData["TotalAcPowerFactor"] },
                { title: "Ia", dataType: "current1", unit: "A", value: pageManager.pageData["TotalAcPhase1Curretn"] },
                { title: "Ib", dataType: "current2", unit: "A", value: pageManager.pageData["TotalAcPhase2Curretn"] },
                { title: "Ic", dataType: "current3", unit: "A", value: pageManager.pageData["TotalAcPhase3Curretn"] }
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

                    // 使用Repeater批量生成DataUnit
                    Repeater {
                        model: acDataItems

                        DataUnit {
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                            title: modelData.title
                            //value: getDataByType(modelData.dataType, modelData.decimals)
                            value: modelData.value.toFixed(2)
                            unit: modelData.unit
                        }
                    }
                }
            }
        }
    }

    // 交流分路信息
    Component{
        id: acBranchInfoComponent
        Item{
            anchors.fill: parent

            // 列配置
            property var columnConfig: [
                { title: "Current", unit: "A", dataKey: "Current", decimals: 1 },
                { title: "PowerFactor", unit: " ", dataKey: "PowerFactor", decimals: 2 },
                { title: "Power", unit: "W", dataKey: "ActivePower", decimals: 0 },
                { title: "Energy", unit: "W.h", dataKey: "Energy", decimals: 0 }
            ]

            // 获取设备数据
            property var deviceData: pageManager.pageData || {}
            // 统一的布局参数
            readonly property int rowHeight: 40
            readonly property int labelWidth: 120
            readonly property int totalRows: 11 // 1行表头 + 10行数据

            // 表头单元格组件 - 移到前面定义
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

                        // 左侧填充空间
                        Item {
                            Layout.fillWidth: true
                            Layout.minimumWidth: 10
                        }

                        // 表头标题矩形框 - 与数据框对齐
                        Rectangle {
                            Layout.preferredWidth: 80 // 与数据框相同宽度
                            Layout.maximumWidth: 100 // 与数据框相同最大宽度
                            Layout.preferredHeight: 26 // 与数据框相同高度
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

                        // 单位文本占位（保持对齐）
                        FluText {
                            text: ""
                            font.pixelSize: 13
                            Layout.preferredWidth: 20
                            Layout.alignment: Qt.AlignVCenter
                        }

                        // 右侧填充空间
                        Item {
                            Layout.fillWidth: true
                            Layout.minimumWidth: 10
                        }
                    }
                }
            }

            // 数据单元格组件 - 移到前面定义
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

                        // 左侧填充空间
                        Item {
                            Layout.fillWidth: true
                            Layout.minimumWidth: 10
                        }

                        // 数值矩形框 - 减小长度
                        Rectangle {
                            Layout.preferredWidth: 80 // 固定宽度而不是fillWidth
                            Layout.maximumWidth: 100 // 最大宽度限制
                            Layout.preferredHeight: 26
                            Layout.alignment: Qt.AlignVCenter

                            color: FluTheme.dark ? Qt.rgba(0.18, 0.18, 0.18, 1) : Qt.rgba(0.97, 0.98, 0.98, 1)
                            border.color: FluTheme.dark ? Qt.rgba(0.33, 0.33, 0.33, 1) : Qt.rgba(0.88, 0.88, 0.88, 1)
                            border.width: 1
                            radius: 2

                            FluText {
                                anchors.centerIn: parent
                                text: pageManager.pageData["AcBranch" + rowIndex + columnData.dataKey].toFixed(2)
                                font.pixelSize: 13
                                color: FluTheme.fontPrimaryColor
                                elide: Text.ElideRight
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignHCenter
                            }
                        }

                        // 单位文本
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

                        // 右侧填充空间
                        Item {
                            Layout.fillWidth: true
                            Layout.minimumWidth: 10
                        }
                    }
                }
            }

            Item {
                anchors.fill: parent

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 0

                    // 统一的行生成器（包含表头和数据行）
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

                                    // 使用Loader根据行类型加载不同内容
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
            
            // 辅助函数：获取列数据
            function getColumnValue(rowIndex, dataKey, decimals) {
                // 引用刷新触发器，确保数据绑定追踪
                //dataRefreshTrigger;
                
                if (rowIndex < 0 || !dataKey) return "---"
                
                switch(dataKey) {
                    case "current":
                        return "0"
                    case "powerFactor":
                        return "0.85" // 示例数据
                    case "power":
                        return "1200" // 示例数据
                    case "energy":
                        return "2400" // 示例数据
                    default:
                        return "---"
                }
            }
        }
    }


    function createTab() {
        for(var i = 1; i <= 4; i++) {
            tab_view.appendTab("qrc:/image/favicon.ico",
                               qsTr("AC Info " + i),
                               acInfoComponent,
                               {
                                   "acNumber": i,
                                   "dataPrefix": "AC" + i
                               })
        }

        tab_view.appendTab("qrc:/image/favicon.ico",
                           qsTr("AC Total Info"),
                           acTotalInfoComponent,
                           {
                               "dataPrefix": "TotalAc"
                           })
        
        tab_view.appendTab("qrc:/image/favicon.ico",
                           qsTr("AC Branch Info"),
                           acBranchInfoComponent,
                           {
                               "dataPrefix": "ACBranch"
                           })
    }

    function getAcBreakerStatus(status) {
        var intValue = parseInt(status) || 0;
        switch(intValue)
        {
            case 0x0000:
                return qsTr("---");
            case 0x0001:
                return qsTr("On");
            case 0x0002:
                return qsTr("Off");
            case 0x0003:
                return qsTr("Trip");
        }
    }

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


    component DataUnit: Item {
        id: root
        
        // Properties
        property string title: ""
        property string value: ""
        property string unit: ""
        property alias titleColor: titleText.color
        property alias valueColor: valueText.color
        property alias unitColor: unitText.color
        
        // Layout properties
        Layout.fillWidth: true
        Layout.preferredHeight: 40
        
        RowLayout {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            spacing: 10
            
            // 标题文本
            FluText {
                id: titleText
                text: root.title
                font.pixelSize: 13
                color: FluTheme.fontPrimaryColor
                Layout.preferredWidth: 80
                Layout.alignment: Qt.AlignVCenter
                horizontalAlignment: Text.AlignRight
            }
            
            // 数值矩形框
            Rectangle {
                id: valueRect
                Layout.preferredWidth: 120
                Layout.preferredHeight: 26
                Layout.alignment: Qt.AlignVCenter
                color: FluTheme.dark ? Qt.rgba(0.18, 0.18, 0.18, 1) : Qt.rgba(0.97, 0.98, 0.98, 1)
                border.color: FluTheme.dark ? Qt.rgba(0.33, 0.33, 0.33, 1) : Qt.rgba(0.88, 0.88, 0.88, 1)
                border.width: 1
                radius: 2
                
                FluText {
                    id: valueText
                    anchors.centerIn: parent
                    text: root.value || "---"
                    font.pixelSize: 13
                    color: FluTheme.fontPrimaryColor
                    elide: Text.ElideRight
                }
            }
            
            // 单位文本
            FluText {
                id: unitText
                text: root.unit
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
}
