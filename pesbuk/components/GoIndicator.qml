import QtQuick 2.9
import Ubuntu.Components 1.3

Icon {
    id: goForwardIcon

    property string iconName
    property real dragDistance
    property bool enabled: true
    property bool heldState: false

    visible: opacity > 0
    opacity: 0
    name: iconName
    color: heldState ? UbuntuColors.blue : UbuntuColors.ash
    width: units.gu(2)
    height: width

    function show() {
        opacity = enabled ? 1 : 0.2
        width = Qt.binding( function() { return units.gu(2) + (Math.min(dragDistance != 0 ? Math.abs(dragDistance) : 0), units.gu(10)) } )
    }

    function hide() {
        opacity = 0
        width = units.gu(2)
        heldState = false
    }

    Behavior on width {
        SpringAnimation { spring: 2; damping: 0.2 }
    }

    Behavior on opacity {
        UbuntuNumberAnimation {
            duration: UbuntuAnimation.FastDuration
        }
    }

    Behavior on color {
        ColorAnimation {
            duration: UbuntuAnimation.FastDuration
        }
    }
}
