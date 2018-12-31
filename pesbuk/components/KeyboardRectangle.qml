import QtQuick 2.9

Item{
	id: keyboardRectangle
		
	height: keyboard.target.visible ? keyboard.target.keyboardRectangle.height / (units.gridUnit / 8) : 0
	anchors{
		left: parent.left
		right: parent.right
		bottom: parent.bottom
	}
    
    Connections {
        id: keyboard
        
        target: Qt.inputMethod
    }
}
