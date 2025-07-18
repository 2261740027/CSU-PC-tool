pragma Singleton

import QtQuick 2.15
import FluentUI 1.0

FluObject{
    property var navigationView
    property var paneItemMenu

    FluPaneItem{
        id:item_home
        count: 0
        title: qsTr("Home")
        menuDelegate: paneItemMenu
        infoBadge: FluBadge{
            count: item_home.count
        }
        icon: FluentIcons.Home
        url: "qrc:/User/ui/page/P_main.qml"
        onTap: {
            if(navigationView.getCurrentUrl()){
                item_home.count = 0
            }
            navigationView.push(url)
        }
    }

    FluPaneItemExpander{
    id: item_expander_basic_input
        title: qsTr("Info")
        icon: FluentIcons.AllApps
        FluPaneItem{
            title: qsTr("Main Info")
            menuDelegate: paneItemMenu
            url: "qrc:/User/ui/page/P_Info_mainInfo.qml"
            onTap: {
                navigationView.push(url)
            }
        }

        FluPaneItem{
            title: qsTr("10Kv Isolator")
            menuDelegate: paneItemMenu
            url: "qrc:/User/ui/page/P_Info_10KvIsolator.qml"
            onTap: {
                navigationView.push(url)
            }
        }

        FluPaneItem{
            title: qsTr("AC Infomation")
            menuDelegate: paneItemMenu
            url: "qrc:/User/ui/page/P_Info_ACInfo.qml"
            onTap: {
                navigationView.push(url)
            }
        }

        FluPaneItem{
            title: qsTr("Alarm Log")
            menuDelegate: paneItemMenu
            url: "qrc:/User/ui/page/P_info_AlarmLog.qml"
            onTap: {
                navigationView.push(url)
            }
        }
      
    }

    FluPaneItem{
        id:item_setting
        count: 0
        title: qsTr("Setting")
        menuDelegate: paneItemMenu
        infoBadge: FluBadge{
            count: item_setting.count
        }
        icon: FluentIcons.Home
        url: "qrc:/User/ui/page/P_setting.qml"
        onTap: {
            if(navigationView.getCurrentUrl()){
                item_setting.count = 0
            }
            navigationView.push(url)
        }
    }


    function getRecentlyAddedData(){
        var arr = []
        var items = navigationView.getItems();
        for(var i=0;i<items.length;i++){
            var item = items[i]
            if(item instanceof FluPaneItem && item.extra && item.extra.recentlyAdded){
                arr.push(item)
            }
        }
        arr.sort(function(o1,o2){ return o2.extra.order-o1.extra.order })
        return arr
    }

    function getRecentlyUpdatedData(){
        var arr = []
        var items = navigationView.getItems();
        for(var i=0;i<items.length;i++){
            var item = items[i]
            if(item instanceof FluPaneItem && item.extra && item.extra.recentlyUpdated){
                arr.push(item)
            }
        }
        return arr
    }

    function getSearchData(){
        if(!navigationView){
            return
        }
        var arr = []
        var items = navigationView.getItems();
        for(var i=0;i<items.length;i++){
            var item = items[i]
            if(item instanceof FluPaneItem){
                if (item.parent instanceof FluPaneItemExpander)
                {
                    arr.push({title:`${item.parent.title} -> ${item.title}`,key:item.key})
                }
                else
                    arr.push({title:item.title,key:item.key})
            }
        }
        return arr
    }

    function startPageByItem(data){
        navigationView.startPageByItem(data)
    }
}
