import QtQuick 2.9
import QtQuick.Controls 2.2
import "components"
//~ import "."

ApplicationWindow {
    id: mainView
    
    readonly property string version: "1.0"
    readonly property QtObject drawer: drawerLoader.item
    
    property alias webview: webViewPage.webView
    
    property bool blockOpenExternalUrls: false
    property bool runningLocalApplication: false
    property bool openExternalUrlInOverlay: false
    property bool popupBlockerEnabled: true
    property bool fullscreen: false
    
    objectName: "mainView"  
    visible: true
    title: "Pesbuk"
    
    header: ApplicationHeader{
        id: applicationHeader
        
        flickable: stackView.currentItem.flickable
        leftActions: [menuAction]
        rightActions: stackView.currentItem ? stackView.currentItem.headerRightActions : 0
    }
    
    BaseHeaderAction{
        id: menuAction
        
        enabled: drawerLoader.visible
        text: stackView.depth > 1 ? i18n.tr("Back") : i18n.tr("Menu")
        iconName: stackView.depth > 1 ? "back" : "navigation-menu"
        notifText: webViewPage.totalCount
        
        onTrigger:{
            if (stackView.depth > 1) {
                    stackView.pop()
                    drawer.resetListIndex()
                } else {
                    if(isBottom){
                        drawer.openBottom()
                    }else{
                        drawer.openTop()
                    }
                }
            }
    }
    

    WebViewPage{
        id: webViewPage
    }
   
    StackView {
        id: stackView
        
        initialItem: webViewPage
        
        anchors{
            left: parent.left
            right: parent.right
            top: parent.top
            bottom: keyboardRec.top
//~             bottomMargin: 25
        }  
    }
   
    SettingsComponent{
        id: appSettings
    }
   
    KeyboardRectangle{
        id: keyboardRec
    }
    
    Loader {
        id: drawerLoader
        
        active: true
        asynchronous: true
        sourceComponent: MenuDrawer{
                id: drawer
                 
                 model:  [
                    { title: i18n.tr("Notifications"), type: "URL" ,url: "https://touch.facebook.com/notifications", iconName: "notification", notifyText: webViewPage.notificationsCount }
                    ,{ title: i18n.tr("Messages"), type: "URL",url: "https://touch.facebook.com/messages", iconName: "message", notifyText: webViewPage.messagesCount }
                    ,{ title: i18n.tr("Feeds"), type: "JS",url: "var button = document.querySelector('a[name=" + "\"News Feed\"" + "].touchable'); if(button){button.click()}", iconName: "rssreader-app-symbolic", notifyText: webViewPage.feedsCount }
                    ,{ title: i18n.tr("Friends"), type: "URL",url: "https://touch.facebook.com/friends", iconName: "contact", notifyText: webViewPage.requestsCount }
                    ,{ title: i18n.tr("Search"), type: "JS",url: "var button = document.querySelector('a[name=Search].touchable'); if(button){button.click()}", iconName: "find" }
                    ,{ title: i18n.tr("Menu"), type: "JS",url: "var button = document.querySelector('a[name=More].touchable'); if(button){button.click()};", iconName: "navigation-menu" }
                    ,{ title: i18n.tr("Groups"), type: "URL",url: "https://m.facebook.com/groups", iconName: "contact-group" }
                    ,{ title: i18n.tr("Marketplace"), type: "URL",url: "https://touch.facebook.com/marketplace", iconName: "stock_store" }
                    ,{ title: i18n.tr("Events"), type: "URL",url: "https://m.facebook.com/events", iconName: "event" }
                    ,{ title: i18n.tr("Settings"), type: "PAGE",url: Qt.resolvedUrl("SettingsPage.qml"), iconName: "settings" }
                    ,{ title: i18n.tr("About"), type: "PAGE",url: Qt.resolvedUrl("AboutPage.qml"), iconName: "info" }
                ]
            }

        visible: status == Loader.Ready
    }
    
    Loader {
        id: rightSwipeAreaLoader
        
        z: 20
        active: true
        asynchronous: true
        visible: status == Loader.Ready
        sourceComponent: BottomSwipeArea{
            onTriggered: applicationHeader.triggerRight(true)
        }
        
        anchors{
            right: parent.right
            left: parent.horizontalCenter
            bottom: parent.bottom
        }
    }  
    
    Loader {
        id: leftSwipeAreaLoader
        
        z: 20
        active: true
        asynchronous: true
        visible: status == Loader.Ready
        sourceComponent: BottomSwipeArea{
            onTriggered: applicationHeader.triggerLeft(true)
        }
        
        anchors{
            left: parent.left
            right: parent.horizontalCenter
            bottom: parent.bottom
        }
    } 
    
    Loader {
        id: bottomEdgeHintLoader
        
        z: 10
        active: appSettings.firstRun
        asynchronous: true
        visible: status == Loader.Ready
        sourceComponent: BottomEdgeHint{}
        
        anchors{
            fill: parent
        }
    } 
   
 }   

