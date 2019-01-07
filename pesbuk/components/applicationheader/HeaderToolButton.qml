import QtQuick 2.9
import QtQuick.Controls 2.2
import Ubuntu.Components 1.3 as UT
import "../"

ToolButton {
    id: headerToolButton
    
    property alias iconName: icon.name
    property alias notifText: notification.text
    
    anchors.bottom: parent.bottom
    padding: 10
    
    height: applicationHeader.defaultHeight

    UT.Icon {
        id: icon
        
        anchors.centerIn: parent
        implicitWidth: 30
        implicitHeight: implicitWidth
        color: headerTitle.color
    }
    
    NotificationIndicator{
        id: notification
        
        indicatorOnly: true
        anchors{
            right: parent.right
            rightMargin: 5
            top: parent.top
            topMargin: 5
        }
    }
}
