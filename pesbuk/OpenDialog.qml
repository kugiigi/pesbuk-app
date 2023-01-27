import QtQuick 2.4
import Lomiri.Components 1.3
import Lomiri.Components.Popups 1.0
import Lomiri.Content 1.3

PopupBase {
    id: openDialog
    property var activeTransfer
    property var path

    Rectangle {
        anchors.fill: parent

        ContentItem {
            id: exportItem
        }

        ContentPeerPicker {
            visible: openDialog.visible
            handler: ContentHandler.Destination
            contentType: ContentType.All

            onPeerSelected: {
                activeTransfer = peer.request();
                var items = [];
                exportItem.url = path;
                console.log(path);
                items.push(exportItem);
                activeTransfer.items = items;
                activeTransfer.state = ContentTransfer.Charged;

                PopupUtils.close(openDialog)
            }

            onCancelPressed: {
                PopupUtils.close(openDialog)
            }
        }
    }
}
