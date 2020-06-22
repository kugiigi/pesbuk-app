import QtQuick 2.9
//~ import Ubuntu.Components 1.3 as UITK
import Ubuntu.Content 1.3
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import "MimeTypeMapper.js" as MimeTypeMapper
import "."
import "components"

Dialog {
    id: picker
    objectName: "contentPickerDialog"


    property var request
    property var activeTransfer
    property bool allowMultipleFiles
    
    property real maximumWidth: 500
    property real preferredWidth: appWindow.width
    
    property real maximumHeight: 500
    property real preferredHeight: appWindow.height > 600 ? appWindow.height / 2 : appWindow.height - 20
    
    width: preferredWidth > maximumWidth ? maximumWidth : preferredWidth
    height: preferredHeight > maximumHeight ? maximumHeight : preferredHeight

    x: (appWindow.width - width) / 2
    parent: ApplicationWindow.overlay
    padding: 0
    topPadding: 0
    
    closePolicy: transferInprogress.visible ? Popup.NoAutoClose : Popup.CloseOnEscape | Popup.CloseOnPressOutside

    modal: true
    
    signal fileAccept(var files)

    onFileAccept: accept()

    onAboutToShow: {
        var mimeTypes = request.acceptedMimeTypes
        
        console.log("Requesting for: " + mimeTypes)
        peerPicker.contentType = ContentType.All
        if(mimeTypes) {
            var arrayLength = mimeTypes.length
            if(arrayLength > 0) {
                var contentType
                var prevContentType
                for (var i = 0; i < arrayLength; i++) {
                    contentType = MimeTypeMapper.mimeTypeToContentType(mimeTypes[i])
                    
                    if (prevContentType && (contentType != prevContentType || contentType == ContentType.Unknown)){
                        contentType = ContentType.All
                        break;
                    }
                    
                    prevContentType = contentType
                }
                peerPicker.contentType = contentType
            }
        }
    }

    function openDialog(){
        y = Qt.binding(function(){return appWindow.width > 500 ? (appWindow.height - height) / 2 : (appWindow.height - height)})
        open()
    }

    Rectangle {
        anchors.fill: parent
        
        ColumnLayout {
            id: transferInprogress
            
            anchors.centerIn: parent
            spacing: 20
            
            visible: picker.activeTransfer ? picker.activeTransfer.state === ContentTransfer.InProgress || picker.activeTransfer.state === ContentTransfer.Initiated : false
            
            Label {
                text: i18n.tr("Transfer in progress")
                font.pixelSize: 20
                horizontalAlignment: Text.AlignHCenter
                Layout.fillWidth: true
                    
            }
            
            BusyIndicator {
                id: indicator
                
                running: true
                Layout.alignment: Qt.AlignHCenter
            }
            
            Button {
                id: cancelTransfer

                text: i18n.tr("Cancel")
                Layout.alignment: Qt.AlignHCenter
                
                onClicked: {
                    picker.activeTransfer.state = ContentTransfer.Aborted
                }
            }
        }

        ContentPeerPicker {
            id: peerPicker
            
            headerText: i18n.tr("Upload from")
            anchors.fill: parent
            visible: !transferInprogress.visible
            contentType: ContentType.All
            handler: ContentHandler.Source

            onPeerSelected: {
                if (allowMultipleFiles) {
                    peer.selectionType = ContentTransfer.Multiple
                } else {
                    peer.selectionType = ContentTransfer.Single
                }
                picker.activeTransfer = peer.request()
                stateChangeConnection.target = picker.activeTransfer
            }

            onCancelPressed: {
                reject()
            }
        }
    }

    Connections {
        id: stateChangeConnection
        target: null
        onStateChanged: {
            if (picker.activeTransfer.state === ContentTransfer.Charged) {
                var selectedItems = []
                for(var i in picker.activeTransfer.items) {
                    selectedItems.push(String(picker.activeTransfer.items[i].url).replace("file://", ""))
                }
                fileAccept(selectedItems)
            }
        }
    }
}

