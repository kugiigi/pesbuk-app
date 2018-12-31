import QtQuick 2.9
import Qt.labs.settings 1.0


Item{
    id: settingsComponent
    
    //Settings page
    property alias style: settings.style
    property alias zoomFactor: settings.zoomFactor
    property alias hideHeader: settings.hideHeader
    
    //User data
    property alias firstRun: settings.firstRun
    
    Settings {
        id: settings
    
        //Settings page
        property string style: "Material"
        property real zoomFactor: 1
        property bool hideHeader: true
        
        //User data
        property bool firstRun: true
    }
}
