import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import Ubuntu.Components 1.3 as UT

Rectangle{
    id: bottomEdgeHint
    
    color: UT.UbuntuColors.jet
    opacity: 0.8
    
    MouseArea{
        anchors.fill: parent
    }
    
    ColumnLayout{
        anchors{
            left: parent.left
            right: parent.right
            verticalCenter: parent.verticalCenter
        }
        Label{
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.margins: 40
            
            font.pixelSize: 20
            text: i18n.tr("You can swipe from either side of the bottom edge to activate the actions in the header. \n Try it now!")
            wrapMode: Text.Wrap
            color: "white"
            horizontalAlignment: Text.AlignHCenter
        }
        
        Button{
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            
            text: i18n.tr("Okay")
            
            onClicked:{
                appSettings.firstRun = false
            }
        }
    }
    
    Rectangle{
        id: edgeHint
        
        color: UT.UbuntuColors.blue
        height: 10
        anchors{
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        
        PropertyAnimation { 
            id: appearAnimation
            
            running: visible
            target: edgeHint
            alwaysRunToEnd: true
            property: "opacity"
            to: 1
            duration: UT.UbuntuAnimation.SlowDuration
            easing: UT.UbuntuAnimation.StandardEasing
            onStopped: hideAnimation.start()
        }
        
        PropertyAnimation {
             id: hideAnimation
             
             target: edgeHint
             alwaysRunToEnd: true
             property: "opacity"
             to: 0
             duration: UT.UbuntuAnimation.SlowDuration
             easing: UT.UbuntuAnimation.StandardEasing
             onStopped: appearAnimation.start()
         }
    }
}
