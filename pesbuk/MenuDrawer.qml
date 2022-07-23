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
            visible: modelData.enabled
            height: modelData.enabled ? implicitHeight : 0
            checkable: modelData.type == "Toggle"
            checked: modelData.initialValue ? modelData.initialValue : false

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
                    case "Toggle":
                        checked = !checked
                        eval(modelData.url)
                        break
                }
            }

            icon.name: modelData ? modelData.iconName : ""
            icon.color: theme.palette.normal.backgroundText
            indicator: Switch {
                id: switchDesktopSite

                visible: modelData.type == "Toggle"
                anchors.right: parent.right
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                checked: itemDelegate.checked
                    onClicked: itemDelegate.clicked()
            }

            onClicked: {
                if (modelData.type !== "Menu") {
                    drawer.close()
                }
                listView.currentIndex = index
                triggerAction(modelData.type, modelData.url)
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
