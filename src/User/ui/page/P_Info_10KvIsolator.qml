import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import FluentUI 1.0


FluContentPage {

    title: qsTr("10KvIsolator")

    property var colors : [FluColors.Yellow,FluColors.Orange,FluColors.Red,FluColors.Magenta,FluColors.Purple,FluColors.Blue,FluColors.Teal,FluColors.Green]

    Component.onCompleted: {
        // 连接信号到C++槽函数
        pageManager.notifyPageSwitch("info10KvIsolator");
        createTab()
    }

    Component.onDestruction: {

    }

    Component{
        id:info10KvIsolatorTab1
        Rectangle{
            anchors.fill: parent
        }
    }

    function createTab(){
        tab_view.appendTab("qrc:/image/favicon.ico",qsTr("10Kv AC Isolator Info1"),info10KvIsolatorTab1,{})
        tab_view.appendTab("qrc:/image/favicon.ico",qsTr("10Kv AC Isolator Info2"),info10KvIsolatorTab1,{})
        tab_view.appendTab("qrc:/image/favicon.ico",qsTr("10Kv AC Isolator Info3"),info10KvIsolatorTab1,{})
    }


    FluFrame{
        anchors.fill: parent
        anchors.bottomMargin: 12
        anchors.rightMargin: 12


        //padding: 8
        FluTabView{
            id:tab_view
            addButtonVisibility: false
            closeButtonVisibility: FluTabViewType.Never
            tabWidthBehavior: FluTabViewType.Equal
            onNewPressed:{
                createTab()
            }
        }
    }

}
