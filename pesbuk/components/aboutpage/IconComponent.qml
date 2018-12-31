import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import Ubuntu.Components 1.3 as UT

ColumnLayout {
    id: iconComponent
    
    spacing: 0

    UT.UbuntuShape {
        id: iconShape
        
        Layout.preferredWidth: 150
        Layout.preferredHeight: Layout.preferredWidth
        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
        
        aspect: UT.UbuntuShape.Flat
        radius: "large"

        source: Image {
            source: "../../icon.svg"
            sourceSize.width: parent.width
            sourceSize.height: parent.height
            asynchronous: true
        }
    }
    
    Label {
        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
        
        text: "© Pesbuk " + i18n.tr("Version") + " " + mainView.version
        font.pixelSize: 15
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
    
    Label {
        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
        
        text: i18n.tr("Released under license") + " <a href='https://www.gnu.org/licenses/gpl-3.0.en.html' title='GNU GPL v3'>GNU GPL v3</a>"
        font.pixelSize: 15
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        onLinkActivated: {
            flickable.externalLinkConfirmation(link)
        }
    }
}
