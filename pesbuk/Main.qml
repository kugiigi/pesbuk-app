import QtQuick 2.12
import QtQuick.Controls 2.5
import Lomiri.Components 1.3 as UT
import Lomiri.PushNotifications 0.1
import QtQuick.Layouts 1.12
import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Suru 2.2
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

    Material.theme: Suru.theme == Suru.Dark ? Material.Dark : Material.Light
    Material.accent: Material.Indigo

    // Change theme in real time when set to follow system theme
    // Only works when the app gets unfocused then focused
    // Possibly ideal so the change won't happen while the user is using the app
    property string previousTheme: Theme.name
    Connections {
        target: Qt.application
        onStateChanged: {
            if (previousTheme !== theme.name) {
                appWindow.Suru.theme = Theme.name == "Ubuntu.Components.Themes.SuruDark" ? Suru.Dark : Suru.Light
                theme.name = Theme.name
                theme.name = ""
            }
            previousTheme = Theme.name
        }
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
            UT.LomiriNumberAnimation{
                easing: UT.LomiriAnimation.StandardEasing
                duration: UT.LomiriAnimation.SleepyDuration
            }
        }
    }
    
    UT.MainView{
        id: mainView
        
        applicationName: "pesbuk.kugiigi"
        anchors.fill: parent
        objectName: "mainView"  
        
        readonly property string version: "2.3"
        readonly property bool wide: width >= units.gu(120)
        
        readonly property string siteMode: wide ? "Desktop" : "Phone"
        readonly property bool desktopMode: appSettings.baseSite === 2
                                                || (appSettings.baseSite === 3 && mainView.siteMode === "Desktop")
                                                || appSettings.forceDesktopVersion

        property bool blockOpenExternalUrls: false
        property bool runningLocalApplication: false
        property bool openExternalUrlInOverlay: false
        property bool popupBlockerEnabled: true
        property bool fullscreen: false

        theme.name: appSettings.style === "Suru" ? "" : "Lomiri.Components.Themes.Ambiance"

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
            wide: mainView.wide
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
                        { title: i18n.tr("View Profile"), type: "URL",url: webViewPage.baseURL + "/profile", iconName: "account" }
                        ,{ title: i18n.tr("Marketplace"), type: "URL",url: webViewPage.baseURL + "/marketplace", iconName: "stock_store" }
                        ,{ title: i18n.tr("Pages"), type: "URL",url: webViewPage.baseURL + "pages", iconName: "stock_document" }
                        ,{ title: i18n.tr("Saved"), type: "URL",url: webViewPage.baseURL + "/saved", iconName: "bookmark" }
                        ,{ title: i18n.tr("Groups"), type: "URL",url: webViewPage.baseURL + "/groups", iconName: "contact-group" }
                        ,{ title: i18n.tr("Events"), type: "URL",url: webViewPage.baseURL + "/events", iconName: "event" }
                        ,{ title: i18n.tr("On This Day"), type: "URL",url: webViewPage.baseURL + "/onthisday", iconName: "calendar-today" }
                        ,{ title: i18n.tr("Reels"), type: "URL",url: webViewPage.baseURL + "/reel", iconName: "stock_video" }
                    ]
            
            active: true
            asynchronous: true
            sourceComponent: MenuDrawer{
                    id: drawer
                     
                     model:  [
                        { enabled: true, title: i18n.tr("Friends"), type: "URL",url: webViewPage.baseURL + "/friends" + (!mainView.desktopMode ? "/center/requests/" : ""), iconName: "contact", notifyText: webViewPage.requestsCount }
                        ,{ 
                            enabled: !mainView.desktopMode
                            , title: i18n.tr("Search")
                            , type: "JS"
                            , url: "var button = document.querySelector('div.m[aria-label=\"Search\"]') || document.querySelector('a[name=Search ]') \
                                    || document.querySelector('input[type=search ]'); if(button){button.click()}"
                            , iconName: "find"
                        }
                        ,{
                            enabled: true
                            , title: i18n.tr("Menu")
                            , type: "JS"
                            , url: "var button = document.querySelector('div.m[data-action-id=\"32747\"') || document.querySelector('a[name=More].touchable'); \
                                    if(button){button.click()};"
                            , iconName: "navigation-menu"
                        }
                        ,{ enabled: true, title: i18n.tr("More"), type: "Menu",url: moreActions, iconName: "other-actions" }
                        ,{ enabled: appSettings.baseSite !== 2, title: i18n.tr("Desktop site"), type: "Toggle", url: "appSettings.forceDesktopVersion = !appSettings.forceDesktopVersion", iconName: "computer-symbolic", initialValue: appSettings.forceDesktopVersion }
                        ,{ enabled: true, title: i18n.tr("About"), type: "PAGE",url: Qt.resolvedUrl("AboutPage.qml"), iconName: "info" }
                    ]

                    rowActions: [
                        Common.RowMenuAction {
                            text: i18n.tr("Settings")
                            icon.name: "settings"
                            closeMenuOnTrigger: true
                            type: "PAGE"
                            url: Qt.resolvedUrl("SettingsPage.qml")
                        }
                        , Common.RowMenuAction {
                            text: i18n.tr("Feeds")
                            icon.name: "rssreader-app-symbolic"
                            closeMenuOnTrigger: true
                            type: "JS"
                            url: "var button = document.querySelector('div.m[data-action-id=\"32738\"') \
                                    || document.querySelector('div.m[data-action-id=\"32753\"') \
                                    || document.querySelector('div.m[data-action-id=\"32756\"') \
                                    || document.querySelector('div.m[data-action-id=\"32752\"') \
                                    || document.querySelector('div.m[data-action-id=\"32751\"') \
                                    || document.querySelector('a[name=" + "\"News Feed\"" + "].touchable'); if(button){button.click()}"
                            notifyText: webViewPage.feedsCount
                        }
                        , Common.RowMenuAction {
                            text: i18n.tr("Messages")
                            icon.name: "message"
                            closeMenuOnTrigger: true
                            // type: mainView.desktopMode ? "URL" : "JS"
                            type: "URL"
                            url: {
                                // if (mainView.desktopMode) {
                                    return (appSettings.messengerDesktop ? "https://www.facebook.com" : webViewPage.baseURL) + "/messages"
                                // }
                                // TODO: Disabled for now since ID changes depending on the current page :(
                                // data-comp-id is closer but still changes
                                // return "var button = document.querySelector('div.m[data-action-id=\"32723\"'); if(button){button.click()}"
                            }
                            notifyText: webViewPage.messagesCount
                        }
                        ,Common.RowMenuAction {
                            text: i18n.tr("Notifications")
                            icon.name: "notification"
                            closeMenuOnTrigger: true
                            // type: mainView.desktopMode ? "URL" : "JS"
                            type: "URL"
                            url: {
                                // if (mainView.desktopMode) {
                                    return webViewPage.baseURL + "/notifications"
                                // }

                                // return "var button = document.querySelector('div.m[data-action-id=\"32704\"') \
                                //         || document.querySelector('div.m[data-action-id=\"32717\"'); if(button){button.click()}"
                            }
                            notifyText: webViewPage.notificationsCount
                        }
                    ]

                    onOpened: applicationHeader.holdTimeout = true
                    onClosed: applicationHeader.holdTimeout = false
                }

            visible: status == Loader.Ready
        }

        Common.GoIndicator {
            id: goForwardIcon

            iconName: "go-next"
            swipeProgress: bottomBackForwardHandle.swipeProgress
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
            swipeProgress: bottomBackForwardHandle.swipeProgress
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
                    color: bottomBackForwardHandle.pressed ? UT.LomiriColors.silk : UT.LomiriColors.ash
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

