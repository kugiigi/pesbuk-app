
import QtQuick 2.4
import Lomiri.Components 1.3
import Lomiri.Components.Popups 1.0
import Lomiri.Content 1.3

PopupBase {
    id: picker

    property var activeTransfer

    Rectangle {
        anchors.fill: parent

        ContentTransferHint {
            anchors.fill: parent
            activeTransfer: picker.activeTransfer
        }

        ContentPeerPicker {
            anchors.fill: parent
            visible: true
            contentType: ContentType.Pictures
            handler: ContentHandler.Source

            onPeerSelected: {
                if (model.allowMultipleFiles) {
                    peer.selectionType = ContentTransfer.Multiple
                } else {
                    peer.selectionType = ContentTransfer.Single
                }
                picker.activeTransfer = peer.request()
                stateChangeConnection.target = picker.activeTransfer
            }

            onCancelPressed: {
                model.reject()
                webview.reload()
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
                model.accept(selectedItems)
            }
        }
    }

    Component.onCompleted: {
        show()
    }
}
