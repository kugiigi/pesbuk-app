import QtQuick.Controls 2.2

Dialog {
    id: addDialog
    
    property real maximumWidth: 300
    property real preferredWidth: parent.width * 0.80
    
    width: preferredWidth > maximumWidth ? maximumWidth : preferredWidth

    x: (parent.width - width) / 2
    parent: ApplicationWindow.overlay

    modal: true
    
    standardButtons: Dialog.Ok | Dialog.Cancel
    
    function openBottom(){
        y = (parent.height - height - 20)
        open()
    }
    
    function openNormal(){
        y = (parent.height - height) / 2
        open()
    }
}
