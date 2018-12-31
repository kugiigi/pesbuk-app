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
    
    
    readonly property string home: "https://touch.facebook.com"
    property alias webView: webview
    
    // Specific Facebook values
    property int messagesCount
    property int notificationsCount
    property int requestsCount
    property int feedsCount
    property int totalCount: messagesCount + notificationsCount + requestsCount + feedsCount
    
    title: webview. title
    headerRightActions: [headerExpandAction, homeAction, reloadAction, forwardAction, backAction]
    
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

        userScripts: [
            WebEngineScript {
               name: "oxide://fb-no-appbanner/"
               sourceUrl: Qt.resolvedUrl("js/fb-no-appbanner.js")
               runOnSubframes: true
           },
           WebEngineScript {
               name: "oxide://fb-no-header/"
               sourceUrl: appSettings.hideHeader ? Qt.resolvedUrl("js/fb-no-header.js") : Qt.resolvedUrl("js/fb-with-header.js")
               injectionPoint: WebEngineScript.DocumentReady
               runOnSubframes: true
           },
           WebEngineScript {
               name: "oxide://notifier/"
               sourceUrl: Qt.resolvedUrl("js/notifier.js")
               injectionPoint: WebEngineScript.DocumentReady
               runOnSubframes: true
           }
        ]
        
        onJavaScriptConsoleMessage: {
            console.log(message)
            var parsedData = JSON.parse(message)
            if(parsedData.type){
                switch(parsedData.type){
                    case "NOTIFY":
                        switch(parsedData.name){
                            case "Notifications":
                                page.notificationsCount = parsedData.value
                            break
                            case "Messages":
                                page.messagesCount = parsedData.value
                            break
                            case "Feeds":
                                page.feedsCount = parsedData.value
                            break
                            case "Requests":
                                page.requestsCount = parsedData.value
                            break
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
        
//~         SwipeArea{
//~             id: bottomSwipeArea
            
//~             direction: SwipeArea.Downwards
//~             enabled: webview.scrollPosition === Qt.point(0,0)
//~             z: 1
//~             anchors.fill: parent
//~             grabGesture: false
//~             onDistanceChanged: {
//~                 if(distance > 0){
//~                     if(applicationHeader.height < applicationHeader.expansionThreshold){
//~                         applicationHeader.height = 50 + distance
//~                     }
                    
//~                     if(applicationHeader.height >= applicationHeader.expansionThreshold){
//~                         applicationHeader.expanded = true
//~                     }
//~                 }	
//~             }
//~         }
        
//~             ScrollPositioner{}
            
        WebEngineProfile {
            id: webContext 

            property alias userAgent: webContext.httpUserAgent
            property alias dataPath: webContext.persistentStoragePath

            dataPath: dataLocation

            userAgent: "Mozilla/5.0 (Linux; U; Android 4.1.1; es-; AVA-V470 Build/GRK39F) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1"

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
