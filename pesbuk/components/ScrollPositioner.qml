import QtQuick 2.9
import QtQuick.Controls 2.2
import Ubuntu.Components 1.3 as UT

RoundButton {
    id: root

    readonly property int timeout: 500
    
    property string mode: "Down"
    property bool hide: false
    
    visible: opacity != 0
    opacity: {
        if (!root.hide) {
            if (root.mode === "Up") {
                root.parent.visibleArea.yPosition
                        + root.parent.visibleArea.heightRatio > 0.10 ? 1 : 0
            } else {
                root.parent.visibleArea.yPosition
                        + root.parent.visibleArea.heightRatio < 0.95 ? 1 : 0
            }
        } else {
            0
        }
    }

    anchors {
        right: parent.right
        rightMargin: 20
        bottom: parent.bottom
        bottomMargin: 30
    }

    Connections {
        id: parentFlickable
        target: root.parent

        onVerticalVelocityChanged: {
            if(target.verticalVelocity === 0){
                timer.start()
            }else{
                timer.stop()
                root.hide = false
                if (target.verticalVelocity < 0) {
                    root.mode = "Up"
                } else{
                    root.mode = "Down"
                }
            }
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
        timer.start()
        if (mode === "Up") {
            root.parent.scrollPosition = Qt.point(0, root.parent.contentsSize.height)
        } else {
            root.parent.scrollPosition = Qt.point(0, 0)
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
