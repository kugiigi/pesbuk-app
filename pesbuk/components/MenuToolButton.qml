import QtQuick 2.9
import Lomiri.Components 1.3
import QtQuick.Controls 2.5 as QQC2
import QtQuick.Controls.Suru 2.2

QQC2.ToolButton {
    id: menuToolButton

    property string iconName
    property color iconColor: Suru.foregroundColor
    property real iconWidth: units.gu(2)
    property real iconHeight: units.gu(2)
    property string tooltipText
    property string notifyText

    height: units.gu(5)
    width: height

    icon.name: iconName
    icon.color: iconColor
    icon.width: iconWidth
    icon.height: iconHeight

    QQC2.ToolTip.delay: 1000
    QQC2.ToolTip.visible: hovered
    QQC2.ToolTip.text: menuToolButton.tooltipText

    NotificationIndicator{
        id: notification

        z: 1
        text: menuToolButton.notifyText ? menuToolButton.notifyText : ""
        small: true
        anchors {
            top: parent.top
            topMargin: Suru.units.gu(1)
            right: parent.right
            rightMargin: Suru.units.gu(1.5)
        }
    }
}
