import QtQuick 2.9
import QtQuick.Controls 2.2

Label {
    id: headerTitle
    
    font.pixelSize: units.gu(3)
    elide: Label.ElideRight
    fontSizeMode: Text.HorizontalFit
    minimumPixelSize: 10
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
}
