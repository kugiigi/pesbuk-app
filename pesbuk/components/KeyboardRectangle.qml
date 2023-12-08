import QtQuick 2.9
import QtQuick.Window 2.2

Item{
	id: keyboardRectangle

	height: Qt.inputMethod.visible ? Qt.inputMethod.keyboardRectangle.height / Screen.devicePixelRatio : 0
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
