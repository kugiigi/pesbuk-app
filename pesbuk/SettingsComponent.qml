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
        
        property var pushFeed: {"enable": false, "sound": false}
        property var pushNotification: {"enable": true, "sound": false}
        property var pushMessage: {"enable": true, "sound": true}
        property var pushRequest: {"enable": true, "sound": false}
        
        //User data
        property bool firstRun: true
        property string pushToken
    }
}
