import QtQuick 2.9
import QtQuick.Controls 2.2
import Lomiri.Components 1.3 as UT
import QtQuick.Controls.Suru 2.2

Menu {
    id: menuActions
    
    property alias model: instantiator.model
    property bool isBottom: false

    margins: Suru.units.gu(2)

    function openBottom(){
        y = appWindow.height - height
        isBottom = true
        open()
    }
    
    function openTop(){
        y = 0
        isBottom = false
        open()
    }
    
    Instantiator {
        id: instantiator
        
        MenuItem {
            text: modelData ? modelData.text : ""
            visible: modelData ? modelData.enabled : false
            onTriggered: {
                menuActions.close()
                modelData.trigger(isBottom)
            }
            height: visible ? 45 : 0
            indicator: UT.Icon {
                 id: iconMenu
                 
                 implicitWidth: 20
                 implicitHeight: implicitWidth
                 anchors.left: parent.left
                 anchors.leftMargin: 10
                 anchors.verticalCenter: parent.verticalCenter
                 name: modelData ? modelData.iconName : ""
                 color: Suru.tertiaryForegroundColor
             }
             leftPadding: iconMenu.implicitWidth + (iconMenu.anchors.leftMargin * 2)
        }
        onObjectAdded: menuActions.insertItem(index, object)
        onObjectRemoved: menuActions.removeItem(object)
    }
}
