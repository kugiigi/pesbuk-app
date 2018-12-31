import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import Ubuntu.Components 1.3 as UT
    
ItemDelegate {
    id: navigationItem
    
    property alias title: titleLabel.text
    property alias subtitle: subtitleLabel.text
    property alias iconName: icon.name
    property string url
    
    anchors{
        left: parent.left
        right: parent.right
    }
    
    height: 60
    
    onClicked: flickable.externalLinkConfirmation(url)
    
    contentItem: RowLayout{
        UT.Icon{
            id: icon
            
            Layout.preferredWidth: 20
            Layout.preferredHeight: Layout.preferredWidth
            Layout.alignment: Qt.AlignVCenter
            visible: name
        }
        
        ColumnLayout{
            Layout.fillHeight: false
            Layout.alignment: Qt.AlignVCenter
            
            spacing: 2
            Label {
                id: titleLabel
                
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                Layout.preferredHeight: font.pixelSize

                font.pixelSize: 14
                elide: Text.ElideRight
//~                 color: theme.normal.backgroundText
                visible: text
            }
            
            Label {
                id: subtitleLabel
                
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                Layout.preferredHeight: font.pixelSize

                font.pixelSize: 11
                elide: Text.ElideRight
//~                 color: theme.normal.backgroundText
                visible: text
            }
        }
        
        UT.Icon{
            Layout.preferredWidth: 20
            Layout.preferredHeight: Layout.preferredWidth
            name: "go-next"
        }
    }
}

