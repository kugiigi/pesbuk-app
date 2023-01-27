import QtQuick 2.9
import QtQuick.Controls 2.2
import Lomiri.Components 1.3 as UT

RoundButton {
    id: root

    readonly property int timeout: 500
    
    property string scrollDirection: "Upwards"
    property real previousScrollPosition: 0
    
    property string mode: "Up"
    property bool hide: false
    
    width: 65
    height: width
    visible: opacity != 0
    opacity: root.hide ? 0 : 1

    anchors {
        right: parent.right
        rightMargin: 20
        bottom: parent.bottom
        bottomMargin: 30
    }


    onScrollDirectionChanged: {
        if(scrollDirection === "Downwards"){
            root.mode = "Down"
        }else{
            root.mode = "Up"
        }
        
        timer.restart()
    }
    
    Connections {
        id: parentFlickable
        target: root.parent
        
        onScrollPositionChanged: {
            if(target.scrollPosition.y > root.previousScrollPosition){
                root.scrollDirection = "Downwards"
            }else{
                root.scrollDirection = "Upwards"
            }

            if (Math.abs(target.scrollPosition.y - root.previousScrollPosition) > 100) {
                root.previousScrollPosition = target.scrollPosition.y
            }
            
            root.hide = false
            timer.restart()
        }
    }

    Behavior on opacity {
        NumberAnimation {
            duration: 200
        }
    }

    UT.Icon {
        id: icon
        
        anchors.centerIn: root
        height: root.height / 2
        width: height
        name: mode === "Up" ? "up" : mode === "Down" ? "down" : ""
    }
    
    onClicked: {
        timer.restart()
        if (mode === "Up") {
            root.parent.goToTop();
        } else {
            root.parent.goToBottom();
        }
    }

    Timer {
        id: timer
        
        interval: timeout
        running: true
        
        onTriggered: {
            root.hide = true
        }
    }
}
