import QtQuick 2.9
import QtQuick.Controls 2.2
import Ubuntu.Components 1.3 as UT
import "components"
import "components/menudrawer"

Drawer {
    id: menuDrawer
    
    property alias model: listView.model
    
    readonly property real minimumWidth: 250
    readonly property real preferredWidth: mainView.width * 0.25
    
    width: preferredWidth < minimumWidth ? minimumWidth : preferredWidth
    height: appWindow.height
    interactive: stackView.depth === 1
    dragMargin: 0
    
    function openTop(){
        listView.verticalLayoutDirection = ListView.TopToBottom
        open()
    }
    
    function openBottom(){
        listView.verticalLayoutDirection = ListView.BottomToTop
        open()
    }
    
    function resetListIndex(){
        listView.currentIndex = -1
    }

    ListView {
        id: listView

        focus: true
        currentIndex: -1
        anchors.fill: parent
        anchors.topMargin: applicationHeader.expanded ? applicationHeader.height - applicationHeader.defaultHeight : 0

        delegate: ItemDelegate {
            id: itemDelegate
            
            width: parent.width
            text: modelData.title
            highlighted: ListView.isCurrentItem
            
            function triggerAction(type, url){
                switch(type){
                    case "PAGE":
                        stackView.push(url)
                    break
                    case "URL":
                        webview.url = url
                    break
                    case "JS":
                        webview.runJavaScript(url)
                    break
                    case "Menu":
                        if(menuLoader.item.visible){
                            menuLoader.item.close()
                        }else{
                            menuLoader.item.open()
                        }
                    break
                }
            }
            
            indicator: UT.Icon {
                 id: iconMenu
                 
                 implicitWidth: 25
                 implicitHeight: implicitWidth
                 anchors.left: parent.left
                 anchors.leftMargin: 10
                 anchors.verticalCenter: parent.verticalCenter
                 name: modelData ? modelData.iconName : ""
                 color: UT.UbuntuColors.jet
             }
             leftPadding: iconMenu.implicitWidth + (iconMenu.anchors.leftMargin * 2)
            
            onClicked: {
                listView.currentIndex = index
                triggerAction(modelData.type, modelData.url)
                if(modelData.type !== "Menu"){
                    drawer.close()
                }
            }
            
            NotificationIndicator{
                id: notification
                
                text: modelData.notifyText ? modelData.notifyText : ""
                anchors{
                    verticalCenter: parent.verticalCenter
                    right: parent.right
                    rightMargin: 20
                }
            }
            
            Loader {
                id: menuLoader
                
                active: modelData.type === "Menu"
                asynchronous: true
                visible: status == Loader.Ready
                sourceComponent: MenuActions{
                        id: menuActions
                        
                        x: itemDelegate.width
                        model: modelData.url
                    }
            }  
        }

        ScrollIndicator.vertical: ScrollIndicator { }
    }
}
