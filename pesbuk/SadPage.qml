import QtQuick 2.4
import Ubuntu.Components 1.3
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.5 as QQC2
import QtQuick.Controls.Suru 2.2

Rectangle {
    id: sadTab

    property var webview

    color: Suru.backgroundColor

    signal closeTabRequested()

    ColumnLayout {
        anchors {
            left: parent.left
            right: parent.right
            verticalCenter: parent.verticalCenter
            verticalCenterOffset: -units.gu(10)
            margins: units.gu(4)
        }
        spacing: units.gu(3)

        Icon {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredHeight: units.gu(10)
            Layout.preferredWidth: units.gu(10)
            name: "dialog-warning-symbolic"
        }

        Label {
            Layout.fillWidth: true
            wrapMode: Text.Wrap
            horizontalAlignment: Text.AlignHCenter
            text: webview ? i18n.tr("The rendering process has been closed.") : ""
        }

        Label {
            Layout.fillWidth: true
            wrapMode: Text.Wrap
            horizontalAlignment: Text.AlignHCenter
            font.weight: Font.Light
            text: {
                return i18n.tr("Something went wrong while displaying %1.").arg(webview.url)
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.maximumWidth: units.gu(40)
            Layout.alignment: Qt.AlignHCenter
            spacing: units.gu(2)

            QQC2.Button {
                objectName: "closeTabButton"
                Layout.fillWidth: true
                visible: false
                icon {
                    name: "close"
                    width: units.gu(1.5)
                    height: units.gu(1.5)
                }
                // FIXME: Remove workaround for icon and label spacing
                text: " " + i18n.tr("Close tab")
                onClicked: closeTabRequested()
            }

            QQC2.Button {
                objectName: "reloadButton"
                Layout.fillWidth: true
                icon {
                    name: "reload"
                    width: units.gu(1.5)
                    height: units.gu(1.5)
                }
                // FIXME: Remove workaround for icon and label spacing
                text: " " + i18n.tr("Reload")
                onClicked: {
                    webview.reload()
                    sadTab.visible = false
                }
            }
        }
    }
}
