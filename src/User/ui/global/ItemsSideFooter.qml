pragma Singleton

import QtQuick 2.15
import FluentUI 1.0

FluObject {

    property var navigationView
    property var paneItemMenu

    id:footer_items

    FluPaneItemSeparator{}

    FluPaneItem{
        title:qsTr("About")
        icon:FluentIcons.Contact
        onTapListener:function(){
            FluRouter.navigate("/about")
        }
    }

}
