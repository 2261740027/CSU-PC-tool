import QtQuick 2.15
import FluentUI 1.0

QtObject {

    readonly property var optionCSU: [
        //{ text: qsTr("----"), value: 0 },
        { text: qsTr("CSU A"), value: 1 , },
        { text: qsTr("CSU B"), value: 2 ,},
        { text: qsTr("CSU C"), value: 3 ,},
    ]

    readonly property var optionCLMode: [
        { text: qsTr("Curr.Limit"), value: 0 },
        { text: qsTr("Volt.Limit"), value: 1 },
        { text: qsTr("Manual"), value: 2 },
    ]

    readonly property var optionDisableEnable: [
        { text: qsTr("Disable"), value: 0 },
        { text: qsTr("Enable"), value: 1 },
    ]

}
