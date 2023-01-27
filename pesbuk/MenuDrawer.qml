import QtQuick 2.9
import QtQuick.Controls 2.12
import Ubuntu.Components 1.3 as UT
import QtQuick.Controls.Suru 2.2
import "components"
import "components/menudrawer"

Drawer {
    id: menuDrawer
    
    property alias model: listView.model
    property list<Action> rowActions
    property bool shownAtBottom: false
    
    readonly property real minimumWidth: 250
    readonly property real preferredWidth: mainView.width * 0.25

    property alias currentIndex: listView.currentIndex
    
    width: preferredWidth < minimumWidth ? minimumWidth : preferredWidth
    height: appWindow.height
    interactive: stackView.depth === 1
    dragMargin: 0
    
    function openTop(){
        shownAtBottom = false
        open()
    }
    
    function openBottom(){
        shownAtBottom = true
        open()
    }
    
    function resetListIndex(){
        listView.currentIndex = -1
    }

    ActionRowMenu {
        id: rowActionMenu

        model: menuDrawer.rowActions
        separatorAtTop: menuDrawer.shownAtBottom
        menu: menuDrawer

        anchors {
            topMargin: applicationHeader.expanded ? applicationHeader.height - applicationHeader.defaultHeight : 0
            left: parent.left
            right: parent.right
        }

        state: "default"
        states: [
            State {
                name: "default"
                when: !menuDrawer.shownAtBottom
                AnchorChanges {
                    target: rowActionMenu
                    anchors.top: parent.top
                    anchors.bottom: undefined
                }
                AnchorChanges {
                    target: listView
                    anchors.top: rowActionMenu.bottom
                    anchors.bottom: listView.parent.bottom
                }
            }
            , State {
                name: "bottom"
                when: menuDrawer.shownAtBottom
                AnchorChanges {
                    target: rowActionMenu
                    anchors.top: undefined
                    anchors.bottom: rowActionMenu.parent.bottom
                }
                AnchorChanges {
                    target: listView
                    anchors.top: listView.parent.top
                    anchors.bottom: rowActionMenu.top
                }
            }
        ]
    }

    ListView {
        id: listView

        focus: true
        currentIndex: -1
        clip: true
        anchors {
            left: parent.left
            right: parent.right
        }
        verticalLayoutDirection: menuDrawer.shownAtBottom ? ListView.BottomToTop : ListView.TopToBottom
        keyNavigationWraps: false
        boundsBehavior: Flickable.StopAtBounds

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
            icon.color: Suru.tertiaryForegroundColor
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
