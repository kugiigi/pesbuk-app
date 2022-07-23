import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

RowLayout {
	id: comboBoxItem
	
	property string text
	property alias currentIndex: comboBox.currentIndex
	property alias model: comboBox.model
	property alias currentText: comboBox.currentText
	
	spacing: 10
    
	anchors{
		left: parent.left
		right: parent.right
	}
    
    function find(text, flags){
        var result = comboBox.find(text, flags)
        return result
    }

	Label {
		id: label
		
		Layout.preferredWidth: 120
		Layout.alignment: Qt.AlignVCenter
		text: comboBoxItem.text + ":"
	}

	ComboBox {
		id: comboBox
							
		Layout.maximumWidth: 200
		Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
	}
}
