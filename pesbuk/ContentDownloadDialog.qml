import QtQuick 2.4
import Lomiri.Components 1.3
import Lomiri.Components.Popups 1.3
import Lomiri.Content 1.3

Component {
    PopupBase {
        id: downloadDialog
        objectName: "downloadDialog"
        anchors.fill: parent
        property var activeTransfer
        property string downloadId
        property var singleDownload
        property string mimeType
        property string filename
        property string icon: MimeDatabase.iconForMimetype(mimeType)
        property alias contentType: peerPicker.contentType

        signal startDownload(string downloadId, var download, string mimeType)

        Component {
            id: downloadOptionsComponent
            Dialog {
                id: downloadOptionsDialog
                objectName: "downloadOptionsDialog"
                Column {
                    spacing: units.gu(2)

                    Item {
                        width: parent.width
                        height: mimetypeIcon.height

                        Icon {
                            id: mimetypeIcon
                            name: icon != "" ? icon : "save"
                            height: units.gu(4.5)
                            width: height
                        }

                        Label {
                            id: filenameLabel
                            anchors.top: mimetypeIcon.top
                            anchors.left: mimetypeIcon.right
                            anchors.leftMargin: units.gu(2)
                            anchors.right: parent.right
                            anchors.rightMargin: units.gu(2)
                            elide: Text.ElideMiddle
                            text: downloadDialog.filename
                        }

                        Label {
                            anchors.top: filenameLabel.bottom
                            anchors.left: filenameLabel.left
                            anchors.right: filenameLabel.right
                            elide: Text.ElideRight
                            font.capitalization: Font.Capitalize
                            text: MimeDatabase.nameForMimetype(downloadDialog.mimeType)
                        }
                    }

                    Label {
                        width: parent.width
                        text: i18n.tr("Choose an application to open this file or add it to the downloads folder.")
                        wrapMode: Text.Wrap
                        visible: peerModel.peers.length > 0
                    }

                    Button {
                        text: i18n.tr("Choose an application")
                        objectName: "chooseAppButton"
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: units.gu(22)
                        height: units.gu(4)
                        visible: peerModel.peers.length > 0
                        onClicked: {
                            PopupUtils.close(downloadOptionsDialog)
                            pickerRect.visible = true
                        }
                    }

                    Button {
                        text: i18n.tr("Download")
                        objectName: "downloadFileButton"
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: units.gu(22)
                        height: units.gu(4)
                        onClicked: {
                            startDownload(downloadId, singleDownload, mimeType)
                            PopupUtils.close(downloadDialog)
                        }
                    }

                    Button {
                        text: i18n.tr("Cancel")
                        objectName: "cancelDownloadButton"
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: units.gu(22)
                        height: units.gu(4)
                        onClicked: PopupUtils.close(downloadDialog)
                    }
                }
            }
        }

        ContentPeerModel {
            id: peerModel
            handler: ContentHandler.Destination
            contentType: downloadDialog.contentType
        }

        Rectangle {
            id: pickerRect
            anchors.fill: parent
            visible: false
            ContentPeerPicker {
                id: peerPicker
                handler: ContentHandler.Destination
                objectName: "contentPeerPicker"
                visible: parent.visible

                onPeerSelected: {
                    activeTransfer = peer.request()
                    activeTransfer.downloadId = downloadDialog.downloadId
                    activeTransfer.state = ContentTransfer.Downloading
                    PopupUtils.close(downloadDialog)
                }

                onCancelPressed: {
                    PopupUtils.close(downloadDialog)
                }
            }
        }

        Component.onCompleted: {
            PopupUtils.open(downloadOptionsComponent, downloadDialog)
        }
    }
}

