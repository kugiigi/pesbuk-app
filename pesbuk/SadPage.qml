import QtQuick 2.4
import Ubuntu.Components 1.3

Rectangle {
    property var webview

    Column {
        anchors {
            fill: parent
            margins: units.gu(4)
        }
        spacing: units.gu(4)

        Image {
            anchors.horizontalCenter: parent.horizontalCenter
            source: "assets/tab-error.png"
        }

        Label {
            anchors {
                left: parent.left
                right: parent.right
            }

            wrapMode: Text.Wrap
            horizontalAlignment: Text.AlignHCenter
            text: webview ? i18n.tr("Oops, something went wrong.") : ""
        }

        Button {
            anchors.horizontalCenter: parent.horizontalCenter
            objectName: "reloadButton"
            text: i18n.tr("Reload")
            color: theme.palette.normal.positive
            onClicked: webview.reload()
        }
    }
}
