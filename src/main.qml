import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0
import "./User/ui/global"

FluWindow {
    id:window
    title: "PCTool"
    minimumWidth: 1075
    minimumHeight: 660
    launchMode: FluWindowType.SingleTask
    fitsAppBarWindows: true
    appBar: FluAppBar {
        height: 30
        showDark: true
        darkClickListener:(button)=>handleDarkChanged(button)
        closeClickListener: ()=>{dialog_close.open()}
        z:7
    }

    Component.onDestruction: {
        FluRouter.exit()
    }

    FluContentDialog{
        id: dialog_close
        title: qsTr("Quit")
        message: qsTr("Are you sure you want to exit the program?")
        negativeText: qsTr("Minimize")
        buttonFlags: FluContentDialogType.NegativeButton | FluContentDialogType.NeutralButton | FluContentDialogType.PositiveButton
        onNegativeClicked: {
            system_tray.showMessage(qsTr("Friendly Reminder"),qsTr("FluentUI is hidden from the tray, click on the tray to activate the window again"));
            timer_window_hide_delay.restart()
        }
        positiveText: qsTr("Quit")
        neutralText: qsTr("Cancel")
        onPositiveClicked:{
            FluRouter.exit(0)
        }
    }

    // 鼠标右键操作
    Component{
        id: nav_item_right_menu
        FluMenu{
            width: 186
            FluMenuItem{
                text: qsTr("Open in Separate Window")
                font: FluTextStyle.Caption
                onClicked: {
                    FluRouter.navigate("/pageWindow",{title:modelData.title,url:modelData.url})
                }
            }
        }
    }

    FluNavigationView{
        property int clickCount: 0
        id:nav_view
        width: parent.width
        height: parent.height
        cellWidth: 200
        z:999
        //Stack模式，每次切换都会将页面压入栈中，随着栈的页面增多，消耗的内存也越多，内存消耗多就会卡顿，这时候就需要按返回将页面pop掉，释放内存。该模式可以配合FluPage中的launchMode属性，设置页面的启动模式
        //                pageMode: FluNavigationViewType.Stack
        //NoStack模式，每次切换都会销毁之前的页面然后创建一个新的页面，只需消耗少量内存
        pageMode: FluNavigationViewType.NoStack
        items: ItemsSide
        footerItems:ItemsSideFooter
        topPadding:{
            if(window.useSystemAppBar){
                return 0
            }
            return FluTools.isMacos() ? 20 : 0
        }
        displayMode: GlobalModel.displayMode
        logo: "qrc:/image/Ace.ico"
        title:"PcTool"
        onLogoClicked:{
            clickCount += 1
            showSuccess("%1:%2".arg(qsTr("Click Time")).arg(clickCount))
            if(clickCount === 5){
                loader.reload()
                flipable.flipped = true
                clickCount = 0
            }
        }
        autoSuggestBox:FluAutoSuggestBox{
            iconSource: FluentIcons.Search
            items: ItemsSide.getSearchData()
            placeholderText: qsTr("Search")
            onItemClicked:
                (data)=>{
                    ItemsSide.startPageByItem(data)
                }
        }
        Component.onCompleted: {
            ItemsSide.navigationView = nav_view
            ItemsSide.paneItemMenu = nav_item_right_menu
            ItemsSideFooter.navigationView = nav_view
            ItemsSideFooter.paneItemMenu = nav_item_right_menu
            window.setHitTestVisible(nav_view.buttonMenu)
            window.setHitTestVisible(nav_view.buttonBack)
            window.setHitTestVisible(nav_view.imageLogo)
            setCurrentIndex(0)
        }
    }

}
