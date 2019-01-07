import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

ColumnLayout{
    id: customZoomFactor
    
    Label{
        Layout.fillWidth: true
        
        text: i18n.tr("Zoom factor") + ":"
    }
    
    SpinBox {
        id: spinBox
        
        property int decimals: 2
        property real realValue: value / 100
        
        from: 25
        to: 500
        stepSize: 25
        
        validator: DoubleValidator {
            bottom: Math.min(spinBox.from, spinBox.to)
            top:  Math.max(spinBox.from, spinBox.to)
        }
    
        Component.onCompleted: {
            value = appSettings.zoomFactor * 100
        }
        
        textFromValue: function(value, locale) {
            return Number(value / 100).toLocaleString(locale, 'f', spinBox.decimals)
        }
        
        valueFromText: function(text, locale) {
            return Number.fromLocaleString(locale, text) * 100
        }
        
        onValueModified: {
            appSettings.zoomFactor = (value / 100)
        }
    }
}
