import QtQuick 2.9
import QtQuick.Controls 2.2
import Ubuntu.Components 1.3 as UT

Rectangle{
    id: notificationIndicator
    
    property alias text: label.text
    property bool indicatorOnly: false
    
    visible: text !== "0" && text
    width: indicatorOnly ? 15 : label.width + 6
    height: indicatorOnly ? width : 20
    
    color: UT.UbuntuColors.red
    radius: indicatorOnly ? width : 2
    
    Label{
        id: label
        
        visible: !indicatorOnly
        color: "white"
        anchors.centerIn: parent
    }
}
