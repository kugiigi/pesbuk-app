import QtQuick 2.12
import QtQuick.Controls 2.5
import Ubuntu.Components 1.3 as UT
import Ubuntu.PushNotifications 0.1
import QtQuick.Layouts 1.12
import "components" as Common

ApplicationWindow {
    id: appWindow
    
    readonly property QtObject drawer: drawerLoader.item
    property alias webview: webViewPage.webView
    property alias leftSwipeArea: leftSwipeAreaLoader.item
    property alias rightSwipeArea: rightSwipeAreaLoader.item
    
    property string displayMode: "Phone" //"Desktop" //"Phone" //"Tablet"
    
    visible: true
    title: "Pesbuk"
    
    width: switch (displayMode) {
               case "Phone":
                   units.gu(50)
                   break
               case "Tablet":
                   units.gu(100)
                   break
               case "Desktop":
                   units.gu(120)
                   break
               default:
                   units.gu(120)
                   break
               }
        height: switch (displayMode) {
                case "Phone":
                    units.gu(89)
                    break
                case "Tablet":
                    units.gu(56)
                    break
                case "Desktop":
                    units.gu(68)
                    break
                default:
                    units.gu(68)
                    break
                }
    
    header: ApplicationHeader{
            id: applicationHeader
            
            timesOut: (appSettings.headerHide == 2 || alwaysHidden) && stackView.inWebView
            alwaysHidden: appSettings.headerHide == 3
            
            flickable: stackView.currentItem.flickable
            leftActions: [menuAction]
            rightActions: stackView.currentItem ? stackView.currentItem.headerRightActions : 0
            expandable: appWindow.height > units.gu(60) && appSettings.headerExpand
            floating: timesOut

            Connections {
                enabled: webViewPage.webView
                target: webViewPage.webView
                onScrollPositionChanged: {
                    if (target.loadProgress == 100) {
                        timer.restart()
                    }
                }
            }
            
            Timer {
                id: timer

                running: false
                interval: 1
                onTriggered: {
                    if (!applicationHeader.expanded && appSettings.headerHide == 1) {
                        if (webViewPage.scrollDirection == "Downwards" && webViewPage.webView.scrollPosition.y > 2) {
                            applicationHeader.state = "Hidden"
                        } else {
                            applicationHeader.state = "Default"
                        }
                    }
                }
            }
        }

    Item {
        id: hoverShowHeader

        z: 1000
        visible: applicationHeader.timesOut && applicationHeader.state == "Hidden"
        height: 10
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }

        HoverHandler {
            id: hoverHander

            onHoveredChanged: {
                if (hovered) {
                    showHeaderOnHoverTimer.restart()
                } else {
                    showHeaderOnHoverTimer.stop()
                }
            }
        }

        Timer {
            id: showHeaderOnHoverTimer
            running: false
            interval: 200
            onTriggered: applicationHeader.state = "Default"
        }
    }

    ProgressBar {
        id: progressBar
        
        z: hoverShowHeader.z - 1
        from: 0
        to: 100
        value: webview.loadProgress
        visible: opacity !== 0
        opacity: value !== to  &&  webview.loading ? 1 : 0
        anchors {
            top: parent.top
            topMargin: applicationHeader.floating ? applicationHeader.height : 0
            left: parent.left
            right: parent.right
        }
        
        Behavior on opacity{ 
            UT.UbuntuNumberAnimation{
                easing: UT.UbuntuAnimation.StandardEasing
                duration: UT.UbuntuAnimation.SleepyDuration
            }
        }
    }
    
    UT.MainView{
        id: mainView
        
        applicationName: "pesbuk.kugiigi"
        anchors.fill: parent
        objectName: "mainView"  
        
        readonly property string version: "2.0"
        
        readonly property string siteMode: switch (true) {
                                    case width >= units.gu(120):
                                        "Desktop"
                                        break
                                    default:
                                        "Phone"
                                        break
                                }
        readonly property bool desktopMode: appSettings.baseSite === 2 || (appSettings.baseSite === 3 && mainView.siteMode === "Desktop")
        
        property bool blockOpenExternalUrls: false
        property bool runningLocalApplication: false
        property bool openExternalUrlInOverlay: false
        property bool popupBlockerEnabled: true
        property bool fullscreen: false
        
        theme.name: appSettings.style === "Suru" ? "" : "Ubuntu.Components.Themes.Ambiance"
        
        Common.BaseHeaderAction{
            id: menuAction
            
            enabled: drawerLoader.visible
            text: stackView.depth > 1 ? i18n.tr("Back") : i18n.tr("Menu")
            iconName: stackView.depth > 1 ? "back" : "navigation-menu"
            notifText: stackView.depth === 1 ? webViewPage.notificationExists : ""
            shortcut: stackView.depth > 1 ? StandardKey.Cancel : "Menu"
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
        
        // TODO: Not working
        Component.onCompleted: {
            if (args.values.url) {
                console.log("Incoming notification on Closed App: " + args.values.url)
                processURI(args.values.url)
            } else if (Qt.application.arguments && Qt.application.arguments.length > 0) {
        
                for (var i = 0; i < Qt.application.arguments.length; i++) {
                    if (Qt.application.arguments[i].match(/^pesbuk/) || Qt.application.arguments[i].match(/^https/)) {
                        console.log("Incoming notification: " + Qt.application.arguments[i])
                        processURI(Qt.application.arguments[i])
                    }
                }
            }
            
        }
        
        function processURI(uri){
            if(uri.match(/^pesbuk/)){
                var actionName = uri.replace("pesbuk://", "")
                
                switch(actionName){
                    case "messages":
                        webViewPage.webView.url = webViewPage.baseURL + "/messages"
                    break
                    case "notifications":
                        webViewPage.webView.url = webViewPage.baseURL + "/notifications"
                    break
                    case "requests":
                        webViewPage.webView.url = webViewPage.baseURL + "/friends/center/requests"
                    break
                    case "feeds":
                        webViewPage.webView.url = webViewPage.home
                    break
                }
            }
            
            if(uri.match(/^https/)){
                webViewPage.webView.url = uri
            }
        }
        
        UT.Arguments {
            id: args
        
            UT.Argument {
                name: 'url'
                help: i18n.tr('Facebook URL/Action')
                required: false
                valueNames: ['URL']
            }
        }
        
        Connections {
            target: UT.UriHandler
        
            onOpened: {
                console.log('Open from UriHandler')
        
                if (uris.length > 0) {
                    console.log('Incoming notification from UriHandler ' + uris[0]);
                    mainView.processURI(uris[0])
                }
            }
        }

        WebViewPage{
            id: webViewPage
        }
       
        StackView {
            id: stackView

            readonly property bool inWebView: currentItem == webViewPage

            initialItem: webViewPage
            
            anchors{
                left: parent.left
                right: parent.right
                
                top: parent.top
                bottom: keyboardRec.top
            }

            onDepthChanged: {
                if (depth > 1) {
                    applicationHeader.state = "Default"
                } else {
                    switch (appSettings.headerHide) {
                        case 0:
                        case 1:
                            applicationHeader.timeOutTimer.stop()
                            applicationHeader.state = "Default"
                            break
                        case 2:
                            applicationHeader.state = "Default"
                            applicationHeader.timeOutTimer.restart()
                            break;
                        case 3:
                            applicationHeader.state = "Hidden"
                            break
                    }
                }
            }
        }
       
        SettingsComponent{
            id: appSettings
        }
       
        Common.KeyboardRectangle{
            id: keyboardRec
        }
        
        PushClient {
            id: pushClient
            
            appId: "pesbuk.kugiigi_pesbuk"
            onTokenChanged: appSettings.pushToken = token
            
            onCountChanged: console.log("count: " + count)
            
            function sendPush(tag, title, body, iconName, url, sound){
                if(!appWindow.active){
                    var req = new XMLHttpRequest();
                    req.open("post", "https://push.ubports.com/notify", true);
                    req.setRequestHeader("Content-type", "application/json");
                    req.onreadystatechange = function() {
                            if ( req.readyState === XMLHttpRequest.DONE ) {
                                            console.log("push notification: ", req.responseText);
                            }
                    }
                    var approxExpire = new Date ();
                    approxExpire.setUTCMinutes(approxExpire.getUTCMinutes()+10);
                    var jsonData = JSON.stringify({
                            "appid" : appId,
                            "expire_on": approxExpire.toISOString(),
                            "token": appSettings.pushToken,
                            "replace_tag": tag,
                            "data": {
                                    "notification": {
                                            "tag": tag,
                                            "card": {
                                                    "actions": [url],
                                                    "icon": iconName,
                                                    "summary": title,
                                                    "body": body,
                                                    "popup": true,
                                                    "persist": true
                                            },
                                            "vibrate": true,
                                            "sound": sound,
                                            "emblem-counter": {
                                                "count": webViewPage.notifyCount,
                                                "visible": webViewPage.notifyCount ? true : false
                                            }
                                    }
                            }
                    })
                    req.send(jsonData);
                }
            }
        }
        
        Loader {
            id: drawerLoader
            
            readonly property var moreActions: [
                        { title: i18n.tr("View Profile"), type: "JS",url: "var menuButton = document.querySelector('a[name=More].touchable'); if(menuButton){menuButton.click()}; setTimeout(function(){var button = document.querySelector('div.mSideMenu ul li div.touchable a'); if(button){button.click()}}, 1000)", iconName: "account" }
                        ,{ title: i18n.tr("Marketplace"), type: "URL",url: webViewPage.baseURL + "/marketplace", iconName: "stock_store" }
                        ,{ title: i18n.tr("Pages"), type: "URL",url: webViewPage.baseURL + "/nt/?id=%2Fpages%2Fnt_launchpoint%2Fhome_pages%2F", iconName: "stock_document" }
                        ,{ title: i18n.tr("Saved"), type: "URL",url: webViewPage.baseURL + "/saved", iconName: "bookmark" }
                        ,{ title: i18n.tr("Groups"), type: "URL",url: webViewPage.baseURL + "/groups", iconName: "contact-group" }
                        ,{ title: i18n.tr("Events"), type: "URL",url: webViewPage.baseURL + "/events", iconName: "event" }
                        ,{ title: i18n.tr("On This Day"), type: "URL",url: webViewPage.baseURL + "/onthisday", iconName: "calendar-today" }
                        ,{ title: i18n.tr("Buy and Sell Groups"), type: "URL",url: webViewPage.baseURL + "/salegroups", iconName: "tag" }
                        ,{ title: i18n.tr("Jobs"), type: "URL",url: webViewPage.baseURL + "/jobs", iconName: "preferences-desktop-accessibility-symbolic" }
                    ]
            
            active: true
            asynchronous: true
            sourceComponent: MenuDrawer{
                    id: drawer
                     
                     model:  [
                        { enabled: true, title: i18n.tr("Notifications"), type: "URL" ,url: webViewPage.baseURL + "/notifications", iconName: "notification", notifyText: webViewPage.notificationsCount }
                        ,{ enabled: true, title: i18n.tr("Messages"), type: "URL",url: (appSettings.messengerDesktop ? "https://www.facebook.com" : webViewPage.baseURL) + "/messages", iconName: "message", notifyText: webViewPage.messagesCount }
                        ,{ enabled: true, title: i18n.tr("Feeds"), type: "JS",url: "var button = document.querySelector('a[name=" + "\"News Feed\"" + "].touchable'); if(button){button.click()}", iconName: "rssreader-app-symbolic", notifyText: webViewPage.feedsCount }
                        ,{ enabled: true, title: i18n.tr("Friends"), type: "URL",url: webViewPage.baseURL + "/friends" + (!mainView.desktopMode ? "/center/requests/" : ""), iconName: "contact", notifyText: webViewPage.requestsCount }
                        ,{ enabled: true, title: i18n.tr("Search"), type: "JS",url: "var button = document.querySelector('a[name=Search ]') || document.querySelector('input[type=search ]'); if(button){button.click()}", iconName: "find" }
                        ,{ enabled: true, title: i18n.tr("Menu"), type: "JS",url: "var button = document.querySelector('a[name=More].touchable'); if(button){button.click()};", iconName: "navigation-menu" }
                        ,{ enabled: true, title: i18n.tr("More"), type: "Menu",url: moreActions, iconName: "other-actions" }
                        ,{ enabled: appSettings.baseSite !== 2, title: i18n.tr("Desktop site"), type: "Toggle", url: "appSettings.forceDesktopVersion = !appSettings.forceDesktopVersion", iconName: "computer-symbolic", initialValue: appSettings.forceDesktopVersion }
                        ,{ enabled: true, title: i18n.tr("Settings"), type: "PAGE",url: Qt.resolvedUrl("SettingsPage.qml"), iconName: "settings" }
                        ,{ enabled: true, title: i18n.tr("About"), type: "PAGE",url: Qt.resolvedUrl("AboutPage.qml"), iconName: "info" }
                    ]

                    onOpened: applicationHeader.holdTimeout = true
                    onClosed: applicationHeader.holdTimeout = false
                }

            visible: status == Loader.Ready
        }

        Common.GoIndicator {
            id: goForwardIcon

            iconName: "go-next"
            dragDistance: bottomBackForwardHandle.distance
            enabled: appWindow.webview ? appWindow.webview.canGoForward
                                            : false
            anchors {
                right: parent.right
                verticalCenter: parent.verticalCenter
            }
        }

        Common.GoIndicator {
            id: goBackIcon

            iconName: "go-previous"
            dragDistance: bottomBackForwardHandle.distance
            enabled: appWindow.webview ? appWindow.webview.canGoBack
                                            : false
            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
            }
        }

        RowLayout {
            id: bottomGestures

            property real sideSwipeAreaWidth: appWindow.webview && !appWindow.webview.isFullScreen ?
                                                            appWindow.width * (appWindow.width > appWindow.height ? 0.15 : 0.30)
                                                            : 0

            anchors {
                bottom: parent.bottom
                left: parent.left
                right: parent.right
                top: parent.top
            }

            Loader {
                id: leftSwipeAreaLoader

                Layout.alignment: Qt.AlignLeft | Qt.AlignBottom
                active: true
                asynchronous: true
                visible: status == Loader.Ready
                sourceComponent: Common.BottomSwipeArea{
                    implicitWidth: bottomGestures.sideSwipeAreaWidth
                    onTriggered: {
                        applicationHeader.triggerLeft(true)
                        Common.Haptics.play()
                    }
                }
            }
            
             Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.alignment: Qt.AlignBottom
                visible: stackView.inWebView

                Rectangle {
                    id: bottomHint

                    visible: !appSettings.hideBottomHint
                    color: bottomBackForwardHandle.pressed ? UT.UbuntuColors.silk : UT.UbuntuColors.ash
                    radius: height / 2
                    height: bottomBackForwardHandle.pressed ? units.gu(1) : units.gu(0.5)
                    anchors {
                        left: parent.left
                        right: parent.right
                        bottom: parent.bottom
                        bottomMargin: units.gu(0.5)
                    }
                }

                Common.HorizontalSwipeHandle {
                    id: bottomBackForwardHandle
                    objectName: "bottomBackForwardHandle"

                    leftAction: goBackIcon
                    rightAction: goForwardIcon
                    immediateRecognition: true
                    usePhysicalUnit: true
                    height: units.gu(2)
                    swipeHoldDuration: 700
                    anchors {
                        left: parent.left
                        right: parent.right
                        bottom: parent.bottom
                    }

                    rightSwipeHoldEnabled: appWindow.webview ? appWindow.webview.canGoBack
                                                              : false
                    leftSwipeHoldEnabled: appWindow.webview ? appWindow.webview.canGoForward
                                                             : false
                    onRightSwipe:  appWindow.webview.goBack()
                    onLeftSwipe:  appWindow.webview.goForward()
                    onLeftSwipeHeld: webViewPage.showNavHistory(appWindow.webview.navigationHistory.forwardItems, true, navHistoryMargin)
                    onRightSwipeHeld: webViewPage.showNavHistory(appWindow.webview.navigationHistory.backItems, true, navHistoryMargin)
                    onPressedChanged: if (pressed) Common.Haptics.playSubtle()

                    Item {
                        id: navHistoryMargin
                        height: units.gu(10)
                        anchors {
                            left: parent.left
                            right: parent.right
                            bottom: parent.top
                        }
                    }
                }
            }

            Loader {
                id: rightSwipeAreaLoader

                Layout.alignment: Qt.AlignRight | Qt.AlignBottom
                active: true
                asynchronous: true
                visible: status == Loader.Ready
                sourceComponent: Common.BottomSwipeArea{
                    implicitWidth: bottomGestures.sideSwipeAreaWidth
                    onTriggered: {
                        applicationHeader.triggerRight(true)
                        Common.Haptics.play()
                    }
                }
            }
        }
        
        Loader {
            id: bottomEdgeHintLoader
            
            z: 10
            active: appSettings.firstRun
            asynchronous: true
            visible: status == Loader.Ready
            sourceComponent: Common.BottomEdgeHint{}
            
            anchors{
                fill: parent
            }
        } 

        // F5 or Ctrl+R: Reload current Tab
        Shortcut {
            sequence: "Ctrl+r"
            enabled: webViewPage.webView
            onActivated: webViewPage.webView.reload()
        }
        Shortcut {
            sequence: "F5"
            enabled: webViewPage.webView
            onActivated: webViewPage.webView.reload()
        }

        // Alt+← or Backspace: Goes to the previous page
        Shortcut {
            sequence: StandardKey.Back
            enabled: webViewPage.webView && webViewPage.webView.canGoBack
            onActivated: webViewPage.webView.goBack()
        }

        // Alt+→ or Shift+Backspace: Goes to the next page
        Shortcut {
            sequence: StandardKey.Forward
            enabled: webViewPage.webView && webViewPage.webView.canGoForward
            onActivated: webViewPage.webView.goForward()
        }

        Shortcut {
            sequence: StandardKey.Cancel
            enabled: stackView.depth > 1
            onActivated: menuAction.trigger(false)
        }
        Shortcut {
            sequence: "Menu"
            enabled: stackView.depth <= 1
            onActivated: menuAction.trigger(false)
        }
    }
   
 }   

