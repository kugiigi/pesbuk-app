import QtQuick 2.9
import QtQuick.Controls 2.2
import Morph.Web 0.1
import QtWebEngine 1.7
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.UnityWebApps 0.1 as UnityWebApps
import Ubuntu.Content 1.1
import QtMultimedia 5.8
import QtSystemInfo 5.0
import "components"
import "actions" as Actions
import "."

BasePage {
    id: page
    
    readonly property string baseURL: switch(appSettings.baseSite){
                                case 0:
                                    "https://touch.facebook.com"
                                break
                                case 1: 
                                    "https://m.facebook.com"
                                break
                                case 2: 
                                    "https://www.facebook.com"
                                break
                                case 3:
                                    mainView.siteMode === "Phone" ? "https://touch.facebook.com" : "https://www.facebook.com"
                                break
                                default:
                                    "https://touch.facebook.com"
                                break
                                
                            }
    readonly property string home: baseURL + "/home.php?sk="
    
    property alias webView: webview
    
    // Specific Facebook values
    property string messagesCount
    property string notificationsCount
    property string requestsCount
    property string feedsCount
    property string notificationExists: messagesCount || notificationsCount || requestsCount || feedsCount
    property int notifyCount: parseInt(messagesCount ? messagesCount : 0) + parseInt(notificationsCount ? notificationsCount : 0) + parseInt(requestsCount ? requestsCount : 0) + parseInt(feedsCount ? feedsCount : 0)
    
    title: webview.title
//~     headerRightActions: [testAction, testAction2, homeAction, reloadAction, forwardAction, backAction]
    headerRightActions: [toggleFBHeader, homeAction, reloadAction, forwardAction, backAction]
    
    BaseHeaderAction{
        id: backAction
        
        enabled: webview.canGoBack
        text: i18n.tr("Back")
        iconName: "back"
        
        onTrigger:{
            //Disabled because the built-in back button doesn't retain scroll position
//~             webview.runJavaScript("var button = document.querySelector('div#MBackNavBar'), style = window.getComputedStyle(button), display = style.getPropertyValue('display'); display"
//~                     , function(result){goBack(result)})
                    
//~             function goBack(result){
//~                 if(result === "none"){
//~                     console.log("goBack")
//~                     webview.goBack()
//~                 }else{
//~                     console.log("runJavaScript")
//~                     webview.runJavaScript("var button = document.querySelector('div#MBackNavBar'); if(button){button.click()}")
//~                 }
//~             }
            webview.goBack()
        }
    }
    
    BaseHeaderAction{
        id: testAction
        
        text: i18n.tr("Test")
        iconName: "go-next"
    
        onTrigger:{
            webview.runJavaScript("var test = document.querySelector('a[name=\"Notifications\"] span[data-sigil=count]'); test.innerHTML = \"" + Math.floor((Math.random() * 10) + 1) + '";')
        }
    }
    BaseHeaderAction{
        id: testAction2
        
        text: i18n.tr("Test 2")
        iconName: "go-next"
    
        onTrigger:{
//~             webview.runJavaScript("var test = document.querySelector('a[name=\"Friend Requests\"] span[data-sigil=count]'); test.innerHTML = \"" + Math.floor((Math.random() * 10) + 1) + '";')
            webview.runJavaScript("var test = document.querySelector('a[name=\"Notifications\"] span[data-sigil=count]'); test.innerHTML = '0'")
        }
    }
    
    BaseHeaderAction{
        id: forwardAction
        
        enabled: webview.canGoForward
        text: i18n.tr("Forward")
        iconName: "go-next"
    
        onTrigger:{
            webview.goForward()
        }
    }
    
    BaseHeaderAction{
        id: homeAction
        
        text: i18n.tr("Home")
        iconName: "go-home"
    
        onTrigger:{
            webview.url = page.home
        }
    }
    
    BaseHeaderAction{
        id: reloadAction
        
        text: i18n.tr("Reload")
        iconName: "reload"
    
        onTrigger:{
            webview.reload()
        }
    }
    
    BaseHeaderAction{
        id: goTopAction
        
        text: i18n.tr("Go to top")
        iconName: "go-up"
    
        onTrigger:{
            webview.goToTop();
        }
    }
    
    BaseHeaderAction{
        id: toggleFBHeader
        
        enabled: !mainView.desktopMode
        text: appSettings.hideHeader ? i18n.tr("Show header") : i18n.tr("Hide header")
        iconName: appSettings.hideHeader ? "view-on" : "view-off"
    
        onTrigger:{
           appSettings.hideHeader = !appSettings.hideHeader;
           webview.runJavaScript("toggleHeader(" + !appSettings.hideHeader + ");")
        }
    }
    
    BaseHeaderAction{
        id: headerExpandAction
        
        text: applicationHeader.expanded ? i18n.tr("Reset Header") : i18n.tr("Reach Header")
        iconName: applicationHeader.expanded ? "up" : "down"
    
        onTrigger:{
            applicationHeader.expanded = !applicationHeader.expanded
        }
    }

    WebEngineView {
        id: webview

        property var currentWebview: webview

        settings.fullScreenSupportEnabled: false

        anchors.fill: parent
        zoomFactor: appSettings.zoomFactor
        url: page.home

        userScripts: [fbNoBanner, noHeader, notifier]
        WebEngineScript {
            id: fbNoBanner
            name: "oxide://fb-no-appbanner/"
            sourceUrl: Qt.resolvedUrl("js/fb-no-appbanner.js")
            runOnSubframes: true
        }
        WebEngineScript {
            id: noHeader
            name: "oxide://fb-no-header/"
            sourceUrl: Qt.resolvedUrl("js/fb-no-header.js")
            injectionPoint: WebEngineScript.DocumentReady
            runOnSubframes: true
            worldId: WebEngineScript.MainWorld
        }
        WebEngineScript {
            id: notifier
            name: "oxide://notifier/"
            sourceUrl: Qt.resolvedUrl("js/notifier.js")
            runOnSubframes: true
        }
        
        function goToTop(){
            runJavaScript("window.scrollTo(0, 0); ")
        }
        
        function goToBottom(){
            runJavaScript("window.scrollTo(0, " + webview.contentsSize.height +"); ")
        }
        
        onLoadingChanged: {
            if (!loading) {
                runJavaScript("toggleHeader(" + !appSettings.hideHeader + ")")
            }
        }
        
        onJavaScriptConsoleMessage: {
//~             console.log(message + " - " + lineNumber + " - " + sourceID)
            var parsedData = JSON.parse(message)
            var notifyEnabled
            var notifyTitle
            var notifyIcon
            var notifyBody
            var notifyUrl
            var notifySound
            if(parsedData.type){
                var parsedValue = !parsedData.value || parsedData.value === "0" ? "" : parsedData.value
                switch(parsedData.type){
                    case "NOTIFY":
                        switch(parsedData.name){
                            case "Notifications":
                                page.notificationsCount = parsedValue
                                notifyEnabled = appSettings.pushNotification.enable
                                if(notifyEnabled){
                                    notifyIcon = "notification"
                                    notifyTitle = i18n.tr("New Facebook notification", "New Facebook notifications", parsedValue)
                                    notifyBody = i18n.tr("notification", "notifications", parsedValue)
                                    notifyUrl = "pesbuk://notifications"
                                    notifySound = appSettings.pushNotification.sound
                                }
                            break
                            case "Messages":
                                page.messagesCount = parsedValue
                                notifyEnabled = appSettings.pushMessage.enable
                                if(notifyEnabled){
                                    notifyIcon = "message"
                                    notifyTitle = i18n.tr("New Facebook message", "New Facebook messages", parsedValue)
                                    notifyBody = i18n.tr("message", "messages", parsedValue)
                                    notifyUrl = "pesbuk://messages"
                                    notifySound = appSettings.pushMessage.sound
                                }
                            break
                            case "Feeds":
                                page.feedsCount = parsedValue
                                notifyEnabled = appSettings.pushFeed.enable
                                if(notifyEnabled){
                                    notifyIcon = "rssreader-app-symbolic"
                                    notifyTitle = i18n.tr("New items in your Facebook feeds")
                                    notifyBody = i18n.tr("feed", "feeds", parsedValue)
                                    notifyUrl = "pesbuk://feeds"
                                    notifySound = appSettings.pushFeed.sound
                                }
                            break
                            case "Requests":
                                page.requestsCount = parsedValue
                                notifyEnabled = appSettings.pushRequest.enable
                                if(notifyEnabled){
                                    notifyIcon = "contact"
                                    notifyTitle = i18n.tr("New Facebook friend request", "New Facebook friend requests", parsedValue)
                                    notifyBody = i18n.tr("friend request", "friend requests", parsedValue)
                                    notifyUrl = "pesbuk://requests"
                                    notifySound = appSettings.pushRequest.sound
                                }
                            break
                        }
                        if(!parsedValue){
//~                             console.log("clear Persistent")
                            pushClient.clearPersistent([parsedData.name.toLowerCase()]);
                        }
                        if(parsedValue && parsedData.push && notifyEnabled){
                            notifyBody = i18n.tr("You have %2 new %1","You have %2 new %1", parsedValue).arg(notifyBody).arg(parsedValue)
                            pushClient.sendPush(parsedData.name.toLowerCase(), notifyTitle, notifyBody, notifyIcon, notifyUrl, notifySound)
                        }
                        
                        
                    break
                }
            }
        }
        
        onContextMenuRequested: {
            //TODO: Disable default context menu
            request.accepted = true
            console.log("context requested")
        }
        
        SwipeArea{
            id: downSwipeArea
            
            readonly property real expansionThreshold: applicationHeader.maxHeight
            
            direction: SwipeArea.Downwards
            enabled: webview.scrollPosition === Qt.point(0,0)
            z: 1
            anchors.fill: parent
            grabGesture: false
            onDistanceChanged: {
                if(distance > 0){
                    if((distance + applicationHeader.height) >= expansionThreshold){
                        applicationHeader.expanded = true
                    }
                }	
            }
        }
        
        SwipeArea{
            id: upSwipeArea
            
            direction: SwipeArea.Upwards
            enabled: applicationHeader.expanded
            z: 1
            anchors.fill: parent
            grabGesture: false
            onDraggingChanged:{
                if(dragging){
                    applicationHeader.expanded = false
                }
            }
        }
        
        ScrollPositioner{z: 5; mode: "Down";}
            
        WebEngineProfile {
            id: webContext 

            property alias userAgent: webContext.httpUserAgent
            property alias dataPath: webContext.persistentStoragePath

            dataPath: dataLocation

//~             userAgent: "Mozilla/5.0 (Linux; U; Android 4.1.1; es-; AVA-V470 Build/GRK39F) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1"
//~             userAgent: "Mozilla/5.0 (Linux; Ubuntu 16.04; Android 5.0; Nexus 5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/${CHROMIUM_VERSION} Mobile Safari/537.36"

            persistentCookiesPolicy: WebEngineProfile.ForcePersistentCookies

        }

        onJavaScriptDialogRequested: function(request) {

            switch (request.type)
            {
                case JavaScriptDialogRequest.DialogTypeAlert:
                    request.accepted = true;
                    var alertDialog = PopupUtils.open(Qt.resolvedUrl("AlertDialog.qml"));
                    alertDialog.message = request.message;
                    alertDialog.accept.connect(request.dialogAccept);
                    break;
    
                case JavaScriptDialogRequest.DialogTypeConfirm:
                    request.accepted = true;
                    var confirmDialog = PopupUtils.open(Qt.resolvedUrl("ConfirmDialog.qml"));
                    confirmDialog.message = request.message;
                    confirmDialog.accept.connect(request.dialogAccept);
                    confirmDialog.reject.connect(request.dialogReject);
                    break;
    
                case JavaScriptDialogRequest.DialogTypePrompt:
                    request.accepted = true;
                    var promptDialog = PopupUtils.open(Qt.resolvedUrl("PromptDialog.qml"));
                    promptDialog.message = request.message;
                    promptDialog.defaultValue = request.defaultText;
                    promptDialog.accept.connect(request.dialogAccept);
                    promptDialog.reject.connect(request.dialogReject);
                    break;
    
                case 3:
                    request.accepted = true;
                    var beforeUnloadDialog = PopupUtils.open(Qt.resolvedUrl("BeforeUnloadDialog.qml"));
                    beforeUnloadDialog.message = request.message;
                    beforeUnloadDialog.accept.connect(request.dialogAccept);
                    beforeUnloadDialog.reject.connect(request.dialogReject);
                    break;
            }

       }

        onFileDialogRequested: function(request) {

            switch (request.mode)
            {
                case FileDialogRequest.FileModeOpen:
                    request.accepted = true;
                    var fileDialogSingle = PopupUtils.open(Qt.resolvedUrl("ContentPickerDialog.qml"));
                    fileDialogSingle.allowMultipleFiles = false;
                    fileDialogSingle.accept.connect(request.dialogAccept);
                    fileDialogSingle.reject.connect(request.dialogReject);
                    break;
    
                case FileDialogRequest.FileModeOpenMultiple:
                    request.accepted = true;
                    var fileDialogMultiple = PopupUtils.open(Qt.resolvedUrl("ContentPickerDialog.qml"));
                    fileDialogMultiple.allowMultipleFiles = true;
                    fileDialogMultiple.accept.connect(request.dialogAccept);
                    fileDialogMultiple.reject.connect(request.dialogReject);
                    break;
    
                case FilealogRequest.FileModeUploadFolder:
                case FileDialogRequest.FileModeSave:
                    request.accepted = false;
                    break;
            }

        }

        onAuthenticationDialogRequested: function(request) {
    
            switch (request.type)
            {
                //case WebEngineAuthenticationDialogRequest.AuthenticationTypeHTTP:
                case 0:
                    request.accepted = true;
                    var authDialog = PopupUtils.open(Qt.resolvedUrl("HttpAuthenticationDialog.qml"), webview.currentWebview);
                    authDialog.host = UrlUtils.extractHost(request.url);
                    authDialog.realm = request.realm;
                    authDialog.accept.connect(request.dialogAccept);
                    authDialog.reject.connect(request.dialogReject);
    
                    break;
    
                //case WebEngineAuthenticationDialogRequest.AuthenticationTypeProxy:
                case 1:
                    request.accepted = false;
                    break;
              }
    
           }

        onNewViewRequested: function(request) {
            Qt.openUrlExternally(request.requestedUrl);
        }

    Loader {
        anchors {
            fill: webview
        }
        active: webProcessMonitor.crashed || (webProcessMonitor.killed && !webview.currentWebview.loading)
        sourceComponent: SadPage {
            webview: webview
            objectName: "overlaySadPage"
        }
        WebProcessMonitor {
            id: webProcessMonitor
            webview: webview
        }
        asynchronous: true
      }
    }
    
    Loader {
        id: contentHandlerLoader
        source: "ContentHandler.qml"
        asynchronous: true
    }
    
    Loader {
        id: downloadLoader
        source: "Downloader.qml"
        asynchronous: true
    }
    
    Loader {
        id: filePickerLoader
        source: "ContentPickerDialog.qml"
        asynchronous: true
    }
    
    Loader {
        id: downloadDialogLoader
        source: "ContentDownloadDialog.qml"
        asynchronous: true
    }
}
