import QtQuick 2.15
import FluentUI 1.0

QtObject {

    // 56F302  系统模式
    readonly property var optionSysPattern: [
        { text: qsTr("standard"), value: 0 },
        { text: qsTr("sys-I"), value: 1 },
        { text: qsTr("JS-PANAMA_V2"), value: 2 },
        { text: qsTr("sys-II"), value: 3 },
        { text: qsTr("PANAMA_V2"), value: 4 },
        { text: qsTr("PANAMA_V1"), value: 5 }
    ]

    // 56F305 
    readonly property var optionLoadCurrSrc: [
        { text: qsTr("Sensor"), value: 0 },
        { text: qsTr("Calcu"), value: 1 },
        { text: qsTr("MixedBoard"), value: 2 },
    ]

    // 56F304
    readonly property var optionRectModel: [
        { text: qsTr("U2LC300AA"), value: 0 },
        { text: qsTr("U2TA300AA"), value: 1 },
        { text: qsTr("U2TB030BB"), value: 2 },
        { text: qsTr("U4LC125BA"), value: 3 },
        { text: qsTr("U2AE300AA"), value: 4 },
        { text: qsTr("U4LC125BB"), value: 5 },
        { text: qsTr("U3TA300AB"), value: 6 },
        { text: qsTr("U2TA300AQ"), value: 7 },
        { text: qsTr("U3TA300AS"), value: 8 },
        { text: qsTr("U2TA300AH"), value: 9 },
    ]
    
    // 56E002
    readonly property var optionGfdFunc: [
        { text: qsTr("Disable"), value: 0 },
        { text: qsTr("Enable"), value: 1 },
    ]

    readonly property var optionSysVoltageMode: [
        { text: qsTr("mode240v"), value: 0 },
        { text: qsTr("mode336v"), value: 1 },
    ]

    readonly property var optionCalStoragePos: [
        { text: qsTr("Local"), value: 0 },
        { text: qsTr("Mixed Board"), value: 1 },
    ]

    readonly property var optionBatteryConnectType: [
        { text: qsTr("Breaker"), value: 0 },
        { text: qsTr("Fuse"), value: 1 },
        { text: qsTr("Union"), value: 2 },
        { text: qsTr("Uninstall"), value: 3 },
    ]

    readonly property var optionESSFunction: [
        { text: qsTr("Disable"), value: 0 },
        { text: qsTr("Enable"), value: 1 },
    ]

    readonly property var optionLimitInputPower: [
        { text: qsTr("Disable"), value: 0 },
        { text: qsTr("Enable"), value: 1 },
    ]

    readonly property var optionLimitBuffCurr: [
        { text: qsTr("Disable"), value: 0 },
        { text: qsTr("Enable"), value: 1 },
    ]

    readonly property var optionRectifierVpgmCmd: [ 
        { text: qsTr("6 bytes"), value: 0 },
        { text: qsTr("8 bytes"), value: 1 },
    ]

    readonly property var optionESSInterface: [     
        { text: qsTr("COM"), value: 0 },
        { text: qsTr("WEB"), value: 1 },
    ]

    readonly property var optionBattery: [
        { text: qsTr("Lead acid"), value: 0 },
        { text: qsTr("Li-thium"), value: 1 },
    ]

    readonly property var optionBatteryMicroCurrent: [
        { text: qsTr("Disable"), value: 0 },
        { text: qsTr("MicroCurrDetec"), value: 1 },
        { text: qsTr("Meter"), value: 2 },
    ]

    readonly property var optionBuzzer: [
        { text: qsTr("Uninstall"), value: 0 },
        { text: qsTr("Install"), value: 1 },
    ]

    readonly property var optionSysAShareFunc: [
        { text: qsTr("Disable"), value: 0 },
        { text: qsTr("Enable"), value: 1 },
    ]

    readonly property var optionSysBShareFunc: [
        { text: qsTr("Disable"), value: 0 },
        { text: qsTr("Enable"), value: 1 },
    ]

    readonly property var optionAcSenseSource: [
        { text: qsTr("detect"), value: 0 },
        { text: qsTr("Disable"), value: 1 },
        { text: qsTr("meters"), value: 2 },
    ]

    readonly property var optionSysWorkMode: [
        { text: qsTr("Master"), value: 0 },
        { text: qsTr("Slave"), value: 1 },
    ]

    readonly property var optionRectVoltageIncrease: [
        { text: qsTr("Disable"), value: 0 },
        { text: qsTr("Enable"), value: 1 },
    ]

    readonly property var optionRectStartUpInSequence: [
        { text: qsTr("Disable"), value: 0 },
        { text: qsTr("Enable"), value: 1 },
    ]

}
