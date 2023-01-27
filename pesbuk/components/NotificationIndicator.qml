import QtQuick 2.9
import QtQuick.Controls 2.2
import Ubuntu.Components 1.3 as UT
import QtQuick.Controls.Suru 2.2

Rectangle{
    id: notificationIndicator
    
    property alias text: label.text
    property bool indicatorOnly: false
    property bool small: false
    
    visible: text !== "0" && text
    width: indicatorOnly ? small ? Suru.units.gu(1) : Suru.units.gu(2)
                         : label.width + (small ? Suru.units.gu(0.5) : Suru.units.gu(1))
    height: indicatorOnly ? width
                          : small ? units.gu(1.5) : units.gu(2.5)
    
    color: UT.UbuntuColors.red
    radius: indicatorOnly ? width
                          : small ? units.gu(0.3) : units.gu(0.5)
    
    UT.Label {
        id: label
        
        visible: !indicatorOnly
        color: "white"
        anchors.centerIn: parent
        textSize: notificationIndicator.small ? UT.Label.XSmall : UT.Label.Small
    }
}
