import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3


ColumnLayout{
    id: sectionItem
    
    property alias text: label.text
    
    spacing: 0
    anchors{
        left: parent.left
        right: parent.right
    }
    
    
    Label {
        id: label
        
        Layout.topMargin: 10
        Layout.leftMargin: 10
        
        font.weight: Font.Medium
        font.pixelSize: 10
        elide: Text.ElideRight
//~         color: theme.normal.backgroundText
    }
    
    Rectangle{
        id: border
        
        Layout.preferredHeight: 2
        Layout.fillWidth: true
        color: "#888888"
    }
 }   
