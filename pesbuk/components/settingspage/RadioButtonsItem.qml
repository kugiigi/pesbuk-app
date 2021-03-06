import QtQuick 2.9
import QtQuick.Controls 2.2

GroupBox {
    id: radioButtonsItem
    
    property string text
    property int currentIndex
    property alias model: repeater.model
    
    //For anchoring additional elements
    readonly property alias mainContent: column
    
    title: text + ":"
    width: parent.width
    focusPolicy: Qt.NoFocus
    
    label: Label {
        id: label
        
        text: radioButtonsItem.title
        verticalAlignment: Text.AlignVCenter
    }
    
    Column {
        id: column
        
        spacing: 5
        width: parent.width
        
        Repeater {
            id: repeater
            
            RadioButton {
                text: modelData
                width: parent.width
                checked: radioButtonsItem.currentIndex == index
                focusPolicy: Qt.TabFocus
                onCheckedChanged: {
                    if(checked){
                        radioButtonsItem.currentIndex = index
                    }
                }
            }
        }
    }
}
