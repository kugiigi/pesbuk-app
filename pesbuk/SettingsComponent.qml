import QtQuick 2.9
import Qt.labs.settings 1.0


Item{
    id: settingsComponent
    
    //Settings page
    property alias style: settings.style
    property alias zoomFactor: settings.zoomFactor
    property alias hideHeader: settings.hideHeader
    property alias pushToken: settings.pushToken
    property alias baseSite: settings.baseSite
    property alias messengerDesktop: settings.messengerDesktop
    property alias messengerZoomFactor: settings.messengerZoomFactor
    property alias headerExpand: settings.headerExpand
    property alias headerAutoHide: settings.headerAutoHide
    
    property alias pushFeed: settings.pushFeed
    property alias pushNotification: settings.pushNotification
    property alias pushMessage: settings.pushMessage
    property alias pushRequest: settings.pushRequest
    
    //User data
    property alias firstRun: settings.firstRun
    
    Settings {
        id: settings
    
        //Settings page
        property string style: "Material"
        property real zoomFactor: 1
        property bool hideHeader: true
        property int baseSite: 0
        property bool messengerDesktop: false
        property real messengerZoomFactor: 1
        property bool headerExpand: true
        property bool headerAutoHide: false
        
        property var pushFeed: {"enable": false, "sound": false}
        property var pushNotification: {"enable": true, "sound": false}
        property var pushMessage: {"enable": true, "sound": true}
        property var pushRequest: {"enable": true, "sound": false}
        
        //User data
        property bool firstRun: true
        property string pushToken
    }
}
